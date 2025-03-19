# Student ID: [Your Student ID here]

.data
prompt: .asciiz "Enter five positive integers: "
space: .asciiz " "
newline: .asciiz "\n"
array: .word 0:5         # 初始化5個整數陣列，每個值為0

.text
.globl main

# findMaxMin(int arr[], int size, int* max, int* min)
findMaxMin:
    # $a0 = array address
    # $a1 = size
    # $a2 = address of max
    # $a3 = address of min
    
    # 檢查陣列大小
    beqz $a1, empty_array    # 如果大小為0，跳轉
    
    # 初始化max和min為第一個元素
    lw $t0, 0($a0)      # $t0 = arr[0]
    sw $t0, 0($a2)      # *max = arr[0]
    sw $t0, 0($a3)      # *min = arr[0]
    
    # 初始化迴圈計數器
    li $t1, 1           # i = 1
    
loop:
    # 檢查迴圈條件
    bge $t1, $a1, loop_done    # if (i >= size) goto loop_done
    
    # 計算arr[i]的地址
    sll $t2, $t1, 2     # $t2 = i * 4
    add $t2, $a0, $t2   # $t2 = &arr[i]
    lw $t3, 0($t2)      # $t3 = arr[i]
    
    # 載入當前max和min
    lw $t4, 0($a2)      # $t4 = *max
    lw $t5, 0($a3)      # $t5 = *min
    
    # 檢查arr[i] > max
    ble $t3, $t4, check_min    # if (arr[i] <= *max) goto check_min
    sw $t3, 0($a2)      # *max = arr[i]
    
check_min:
    # 檢查arr[i] < min
    bge $t3, $t5, loop_continue    # if (arr[i] >= *min) goto loop_continue
    sw $t3, 0($a3)      # *min = arr[i]
    
loop_continue:
    # 增加迴圈計數器
    addi $t1, $t1, 1    # i++
    j loop              # 回到迴圈開始
    
empty_array:
    # 如果陣列為空，設置默認值
    li $t0, 0
    sw $t0, 0($a2)      # *max = 0
    sw $t0, 0($a3)      # *min = 0
    
loop_done:
    jr $ra              # 返回調用者

main:
    # 分配最大值和最小值的內存空間
    addi $sp, $sp, -8   # 在堆疊上分配8位元組
    move $s2, $sp       # $s2 = max的地址
    addi $s3, $sp, 4    # $s3 = min的地址
    
    # 打印提示
    li $v0, 4
    la $a0, prompt
    syscall
    
    # 讀取五個整數
    la $s0, array       # $s0 = 陣列地址
    li $s1, 5           # $s1 = 陣列大小
    li $s4, 0           # $s4 = 計數器
    
read_loop:
    # 檢查是否已讀取所有數字
    beq $s4, $s1, read_done
    
    # 讀取整數
    li $v0, 5
    syscall
    
    # 存入陣列
    sll $t0, $s4, 2     # $t0 = 計數器 * 4
    add $t0, $s0, $t0   # $t0 = &array[計數器]
    sw $v0, 0($t0)      # array[計數器] = 輸入值
    
    # 增加計數器
    addi $s4, $s4, 1
    j read_loop
    
read_done:
    # 調用findMaxMin
    move $a0, $s0       # $a0 = 陣列地址
    move $a1, $s1       # $a1 = 大小
    move $a2, $s2       # $a2 = max的地址
    move $a3, $s3       # $a3 = min的地址
    jal findMaxMin
    
    # 打印max
    lw $a0, 0($s2)      # $a0 = max
    li $v0, 1           # 打印整數
    syscall
    
    # 打印空格
    li $v0, 4
    la $a0, space
    syscall
    
    # 打印min
    lw $a0, 0($s3)      # $a0 = min
    li $v0, 1           # 打印整數
    syscall
    
    # 打印換行
    li $v0, 4
    la $a0, newline
    syscall
    
    # 釋放堆疊空間
    addi $sp, $sp, 8
    
    # 退出程式
    li $v0, 10
    syscall
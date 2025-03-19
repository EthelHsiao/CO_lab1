.data
    prompt: .asciiz "Enter five positive integers: "
    space: .asciiz " "
    newline: .asciiz "\n"
    array: .space 20   # 分配 5 個整數空間

.text
.globl main
.globl findMaxMin

# --------------------- findMaxMin 函式 ---------------------
findMaxMin:
    lw $t0, 0($a0)      # $t0 = arr[0]
    sw $t0, 0($a2)      # *max = arr[0]
    sw $t0, 0($a3)      # *min = arr[0]

    li $t1, 1           # i = 1

loop:
    bge $t1, $a1, loop_done   # if (i >= size) break
    sll $t2, $t1, 2
    add $t2, $a0, $t2
    lw $t3, 0($t2)      # arr[i]

    lw $t4, 0($a2)      # max
    lw $t5, 0($a3)      # min

    ble $t3, $t4, check_min
    sw $t3, 0($a2)      # max = arr[i]

check_min:
    bge $t3, $t5, loop_continue
    sw $t3, 0($a3)      # min = arr[i]

loop_continue:
    addi $t1, $t1, 1
    j loop

loop_done:
    jr $ra

# --------------------- main 主函式 ---------------------
main:
    li $v0, 4
    la $a0, prompt
    syscall

    la $s0, array       # 陣列起始地址
    li $s1, 5           # 陣列大小
    li $s2, 0           # 計數器 i = 0

read_loop:
    beq $s2, $s1, read_done  # 讀完 5 個數字則退出
    li $v0, 5
    syscall

    # 確保讀取的是整數，避免 Exception 5
    bltz $v0, error_handler   # 如果是負數，跳到錯誤處理

    sll $t0, $s2, 2
    add $t0, $s0, $t0
    sw $v0, 0($t0)      # 存入陣列

    addi $s2, $s2, 1
    j read_loop

read_done:
    addi $sp, $sp, -8
    move $s2, $sp
    addi $s3, $sp, 4

    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    move $a3, $s3
    jal findMaxMin

    # 輸出 max
    lw $a0, 0($s2)
    li $v0, 1
    syscall

    # 輸出空格
    li $v0, 4
    la $a0, space
    syscall

    # 輸出 min
    lw $a0, 0($s3)
    li $v0, 1
    syscall

    # 換行
    li $v0, 4
    la $a0, newline
    syscall

    # 釋放堆疊
    addi $sp, $sp, 8

    # 結束
    li $v0, 10
    syscall

error_handler:
    li $v0, 4
    la $a0, newline
    syscall
    li $v0, 10
    syscall

# Student ID: [您的學號]

.data
    input_msg:  .asciiz "Enter five positive integers: "
    space:      .asciiz " "
    newline:    .asciiz "\n"

.text
.globl main

#------------------------- main -----------------------------
main:
    # 分配內存給五個整數
    addi $sp, $sp, -20      # 分配五個整數的空間
    move $s0, $sp           # $s0 = 陣列位址
    
    # 打印輸入提示
    li   $v0, 4             # 系統呼叫: 打印字串
    la   $a0, input_msg     # 加載字串位址到 $a0
    syscall                 # 執行系統呼叫
    
    # 讀取五個整數
    li   $t0, 0             # 初始化計數器 i = 0
    
input_loop:
    beq  $t0, 5, end_input  # 如果 i == 5，結束輸入循環
    
    # 讀取一個整數
    li   $v0, 5             # 系統呼叫: 讀取整數
    syscall                 # 執行系統呼叫
    
    # 計算陣列元素的位址並存儲
    sll  $t1, $t0, 2        # $t1 = i * 4 (每個整數4位元組)
    add  $t1, $s0, $t1      # $t1 = &arr[i]
    sw   $v0, 0($t1)        # arr[i] = 讀取的整數
    
    # 增加計數器
    addi $t0, $t0, 1        # i++
    j    input_loop         # 繼續循環
    
end_input:
    # 分配內存給max和min
    addi $sp, $sp, -8       # 為max和min分配空間
    move $s1, $sp           # $s1 = &max
    addi $s2, $sp, 4        # $s2 = &min
    
    # 準備呼叫findMaxMin參數
    move $a0, $s0           # $a0 = 陣列位址
    li   $a1, 5             # $a1 = 陣列大小
    move $a2, $s1           # $a2 = &max
    move $a3, $s2           # $a3 = &min
    
    # 呼叫findMaxMin函數
    jal  findMaxMin         # 呼叫findMaxMin
    
    # 打印結果
    lw   $a0, 0($s1)        # $a0 = max
    li   $v0, 1             # 系統呼叫: 打印整數
    syscall                 # 執行系統呼叫
    
    # 打印空格
    li   $v0, 4             # 系統呼叫: 打印字串
    la   $a0, space         # 加載空格位址
    syscall                 # 執行系統呼叫
    
    # 打印min
    lw   $a0, 0($s2)        # $a0 = min
    li   $v0, 1             # 系統呼叫: 打印整數
    syscall                 # 執行系統呼叫
    
    # 打印換行
    li   $v0, 4             # 系統呼叫: 打印字串
    la   $a0, newline       # 加載換行位址
    syscall                 # 執行系統呼叫
    
    # 釋放分配的內存
    addi $sp, $sp, 28       # 釋放所有分配的內存 (20 + 8)
    
    # 退出程序
    li   $v0, 10            # 系統呼叫: 退出
    syscall                 # 執行系統呼叫

#------------------------- procedure findMaxMin -----------------------------
# 參數: $a0 = 陣列位址, $a1 = 陣列大小, $a2 = &max, $a3 = &min
# 無返回值，直接更新max和min的值
findMaxMin:
    # 將第一個元素設為最大值和最小值
    lw   $t0, 0($a0)        # $t0 = arr[0]
    sw   $t0, 0($a2)        # *max = arr[0]
    sw   $t0, 0($a3)        # *min = arr[0]
    
    # 初始化循環計數器
    li   $t1, 1             # i = 1
    
loop:
    # 檢查是否完成循環
    beq  $t1, $a1, done     # 如果 i == size，結束循環
    
    # 計算當前元素的位址
    sll  $t2, $t1, 2        # $t2 = i * 4
    add  $t2, $a0, $t2      # $t2 = &arr[i]
    lw   $t3, 0($t2)        # $t3 = arr[i]
    
    # 載入當前的max和min
    lw   $t4, 0($a2)        # $t4 = *max
    lw   $t5, 0($a3)        # $t5 = *min
    
    # 比較並更新max
    ble  $t3, $t4, check_min # 如果 arr[i] <= *max，跳到check_min
    sw   $t3, 0($a2)        # 否則，*max = arr[i]
    
check_min:
    # 比較並更新min
    bge  $t3, $t5, continue # 如果 arr[i] >= *min，跳到continue
    sw   $t3, 0($a3)        # 否則，*min = arr[i]
    
continue:
    # 增加計數器，繼續循環
    addi $t1, $t1, 1        # i++
    j    loop               # 繼續循環
    
done:
    # 返回
    jr   $ra                # 返回調用者
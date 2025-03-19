#112550179

.data
input_msg: .asciiz "Enter an integer: "
newline: .asciiz "\n"

.text
.globl main

main:
# print input_msg on the console interface
    li      $v0, 4
    la      $a0, input_msg
    syscall
    
#read int
    li      $v0, 5
    syscall
    move    $s0, $v0      
    
#Call sumOfDigits
    move    $a0, $s0      
    jal     sumOfDigits    
    
#print result
    li      $v0, 1           
    move    $a0, $v0    
    syscall
    
#print newline
    li      $v0, 4
    la      $a0, newline
    syscall
    
#exit program
    li      $v0, 10
    syscall

#-----------implement sum of digits--------------

#sumOfDigits(int n)
sumOfDigits:
    #initilize sum=0
    li      $v0, 0
    
sum_loop:
#check if n <= 0
    ble $a0, $zero, sum_done #a0<=zero, jump to sun_done
    
    li $t0, 10
    div $a0, $t0 #a0/t0
    mfhi    $t1 #mfhi take %   
    add $v0, $v0, $t1
#next one
    div $a0, $t0
    mflo $a0    #mflo take /
# Continue loop
    j sum_loop

sum_done:
    jr $ra


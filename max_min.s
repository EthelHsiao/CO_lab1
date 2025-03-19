# Student ID: [Your Student ID here]

.data
prompt: .asciiz "Enter five positive integers: "
space: .asciiz " "
newline: .asciiz "\n"
array: .space 20        # 5 integers * 4 bytes = 20 bytes

.text
.globl main

# findMaxMin(int arr[], int size, int* max, int* min)
findMaxMin:
    # $a0 = array address
    # $a1 = size
    # $a2 = address of max
    # $a3 = address of min
    
    # Initialize max and min with first element
    lw $t0, 0($a0)      # $t0 = arr[0]
    sw $t0, 0($a2)      # *max = arr[0]
    sw $t0, 0($a3)      # *min = arr[0]
    
    # Initialize loop counter
    li $t1, 1           # i = 1
    
loop:
    # Check loop condition
    bge $t1, $a1, loop_done    # if (i >= size) goto loop_done
    
    # Calculate address of arr[i]
    sll $t2, $t1, 2     # $t2 = i * 4
    add $t2, $a0, $t2   # $t2 = &arr[i]
    lw $t3, 0($t2)      # $t3 = arr[i]
    
    # Load current max and min
    lw $t4, 0($a2)      # $t4 = *max
    lw $t5, 0($a3)      # $t5 = *min
    
    # Check if arr[i] > max
    ble $t3, $t4, check_min    # if (arr[i] <= *max) goto check_min
    sw $t3, 0($a2)      # *max = arr[i]
    
check_min:
    # Check if arr[i] < min
    bge $t3, $t5, loop_continue    # if (arr[i] >= *min) goto loop_continue
    sw $t3, 0($a3)      # *min = arr[i]
    
loop_continue:
    # Increment loop counter
    addi $t1, $t1, 1    # i++
    j loop              # go back to loop
    
loop_done:
    jr $ra              # Return to caller

main:
    # Print prompt
    li $v0, 4
    la $a0, prompt
    syscall
    
    # Read five integers
    la $s0, array       # $s0 = address of array
    li $s1, 5           # $s1 = size of array
    li $s2, 0           # $s2 = counter
    
read_loop:
    # Check if we've read all numbers
    beq $s2, $s1, read_done
    
    # Read integer
    li $v0, 5
    syscall
    
    # Store in array
    sll $t0, $s2, 2     # $t0 = counter * 4
    add $t0, $s0, $t0   # $t0 = &array[counter]
    sw $v0, 0($t0)      # array[counter] = input
    
    # Increment counter
    addi $s2, $s2, 1
    j read_loop
    
read_done:
    # Allocate space for max and min
    addi $sp, $sp, -8   # Allocate 8 bytes on stack
    move $s2, $sp       # $s2 = address of max
    addi $s3, $sp, 4    # $s3 = address of min
    
    # Call findMaxMin
    move $a0, $s0       # $a0 = array address
    move $a1, $s1       # $a1 = size
    move $a2, $s2       # $a2 = address of max
    move $a3, $s3       # $a3 = address of min
    jal findMaxMin
    
    # Print max
    lw $a0, 0($s2)      # $a0 = max
    li $v0, 1           # Print integer
    syscall
    
    # Print space
    li $v0, 4
    la $a0, space
    syscall
    
    # Print min
    lw $a0, 0($s3)      # $a0 = min
    li $v0, 1           # Print integer
    syscall
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Deallocate stack space
    addi $sp, $sp, 8
    
    # Exit program
    li $v0, 10
    syscall
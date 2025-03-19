
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
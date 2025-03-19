# Student ID: [Your Student ID here]

.data
prompt: .asciiz "Enter an integer: "
newline: .asciiz "\n"

.text
.globl main

# sumOfDigits(int n)
sumOfDigits:
    # Initialize sum to 0
    li $v0, 0
    
sum_loop:
    # Check if n <= 0
    ble $a0, $zero, sum_done
    
    # Get last digit: n % 10
    li $t0, 10
    div $a0, $t0
    mfhi $t1            # $t1 = n % 10
    
    # Add digit to sum
    add $v0, $v0, $t1
    
    # Remove last digit: n /= 10
    div $a0, $t0
    mflo $a0            # $a0 = n / 10
    
    # Continue loop
    j sum_loop

sum_done:
    # Return sum
    jr $ra

main:
    # Print prompt
    li $v0, 4
    la $a0, prompt
    syscall
    
    # Read integer
    li $v0, 5
    syscall
    move $s0, $v0       # Store input in $s0
    
    # Call sumOfDigits
    move $a0, $s0       # Set argument
    jal sumOfDigits     # Call function
    
    # Print result
    move $a0, $v0       # Move result to $a0 for printing
    li $v0, 1           # Print integer
    syscall
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Exit program
    li $v0, 10
    syscall
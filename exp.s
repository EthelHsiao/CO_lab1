.data

    input_msg1:	.asciiz "Enter base (positive integers): "
    input_msg2: .asciiz "Enter exponent (positive integers): "
	newline: 	.asciiz "\n"

.text
.globl main
#------------------------- main -----------------------------
main:
# print input_msg on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, input_msg1		# load address of string into $a0
	syscall                 	# run the syscall
 
# read the input integer in $v0
	li      $v0, 5          	# call system call: read integer
	syscall                 	# run the syscall
	move    $t0, $v0      		# store input in $a0 (set arugument of procedure factorial)

# print input_msg on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, input_msg2		# load address of string into $a0
	syscall                 	# run the syscall
 
# read the input integer in $v0
	li      $v0, 5          	# call system call: read integer
	syscall                 	# run the syscall
	move    $t1, $v0      		# store input in $a0 (set arugument of procedure factorial)
# jump to procedure factorial
    move $a0, $t0
    move $a1, $t1
	jal 	power
	move 	$t2, $v0	



# print the result of procedure factorial on the console interface
	li 		$v0, 34				# call system call: print int
	move 	$a0, $t0			# move value of integer into $a0
	syscall 					# run the syscall

# print a newline at the end
	li		$v0, 4				# call system call: print string
	la		$a0, newline		# load address of string into $a0
	syscall						# run the syscall

# exit the program
	li 		$v0, 10				# call system call: exit
	syscall						# run the syscall

#------------------------- procedure factorial -----------------------------
# load argument n in $a0, return value in $v0. 
.text
power:	

	beq 	$a1, $zero, base_case		# if n >= 1 go to L1
	addi 	$sp, $sp, -4		# adiust stack for 2 items
	sw 		$ra, 4($sp)			# save the return address
	sw 		$a1, 0($sp)			# save the argument n

	addi 	$a1, $a1, -1		# return 1
    jal 	power			# call factorial with (n-1)
    		
    lw   $a1, 0($sp)   
    lw   $ra, 4($sp)   
    
	addi 	$sp, $sp, 8		# pop 2 items off stack
    mul 	$v0, $v0, $a0

	jr 		$ra					# return to caller
base_case:		
    li $v0, 1
    jr $ra

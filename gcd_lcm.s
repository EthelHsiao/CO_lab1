.data
	input_msg1:	.asciiz "Please enter the first number: "
    input_msg2: .asciiz "Please enter the second number: "
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
	jal 	gcd
	move 	$t2, $v0			# save return value in t0 (because v0 will be used by system call) 
# calculate lcm
    mul $t3, $t0, $t1
    div $t3, $t2
    mflo $t4
# print gcd
	li 		$v0, 1				# call system call: print int
	move 	$a0, $t2			# move value of integer into $a0
	syscall 					# run the syscall

# print a space
	li		$v0, 11				# call system call: print string
	la		$a0, 32		# load address of string into $a0
	syscall						# run the syscall

# print lcm
	li 		$v0, 1
    move    $a0, $t4				# call system call: exit
	syscall						# run the syscall

# print a newline at the end
	li		$v0, 4				# call system call: print string
	la		$a0, newline		# load address of string into $a0
	syscall						# run the syscall
    
# exit the program
	li 		$v0, 10				# call system call: exit
	syscall						# run the syscall

#------------------------- procedure gcd -----------------------------
# load argument n in $a0, return value in $v0. 
.text
gcd:
loop:
    beq $a1, $zero, end_gcd
    move $t5,$a1 
    div $a0, $a1
    mfhi $a1
    move $a0, $t5
    j loop

end_gcd:
    move $v0, $a0
    jr $ra

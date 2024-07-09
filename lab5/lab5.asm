.data
	input_prompt: .asciiz "\nPlease enter a number in the range 0-24, or Q to quit:\n"
	error_range_msg: .asciiz "\nThis number is outside the allowable range.\n"
	result_string: .asciiz "\nThe Fibonacci number F   is "
	number_input: .space 4
	space: .byte ' '
	
#################################################################
# $s0 -> Result String											#
# $s1 -> User's Input											#
# $s2 -> User's Input in integer form							#
# $s3/$t5 -> Value of number to be processed					#
# $s4 -> Space													#
# $t0 -> Number 10												# 
# $t1 -> Processing byte of input string / Recursion Counter	#
# $t2 -> Processing byte of Result String / F(n-2)				#
# $t3 -> F(n-1)													#
# $t4 -> Result of Fibonacci									#
#################################################################


.text
  main:
	addi	$t0, $zero, 10					# Initialize to $t0 the number 10 
	la		$s0, result_string				# Initialize to $s0 the result string
	addi	$s2, $zero, 0					# Initialize to $s2 the number 0	

	li		$v0, 4
	la		$a0, input_prompt				# Prompting the user to input his choice
	syscall
	
	li		$v0, 8
    la 		$a0, number_input				# Reading the input of the user
    li 		$a1, 4
    syscall
	
	lb		$s4, 0($a0)
	beq		$s4, 'Q', quit					# Checking if the input is 'Q', if so quit the program
		
	addi	$sp, $sp, -8					# Enlarging the stack 
	sw		$a0, 0($sp)						# Storing the input of the user into the stack
	sw		$s0, 4($sp)						# Storing the result_string inside the stack
	jal		final_string					# Finding the final string to be printed
	lw		$s0, 4($sp)						# Loading from the stack the output
								
	jal		string_to_int					# Making the input (Given as string) to integer

	jal		fibonacci						# Getting the fibonacci number
	lw		$t4, 0($sp)						# Loading from the fibonacci number into $t4 to later be printed
	addi	$sp, $sp, 8						# Shortening the stack

	j 		print

# --------------------------- String to Integer Fuction ------------------------------------------ #

string_to_int:
		lw		$s1, 0($sp)				
	lp:
		lbu 	$t1, ($s1)       			# Load unsigned char from array into t1
		beq 	$t1, '\n', eol				# If bytes equals '\n', go back
  		addi 	$t1, $t1, -48   			# Converts t1's ascii value to dec value
  		mul 	$s2, $s2, $t0    			# Sum *= 10		
  		add 	$s2, $s2, $t1    			# Sum += array[s1]-'0'
  		addi 	$s1, $s1, 1    			 	# Increment array address
  		j 		lp

eol:
	bgt		$s2, 25, error
	blt 	$s2, 0, error		
	sw		$s2, 0($sp)						# Store the value of the final_string to the stack
	jr		$ra
	
error:
	li		$v0, 4
	la		$a0, error_range_msg 			# Printing Error
	syscall

	j		main
# --------------------------- Final String Function --------------------------------------------- #
	
final_string:
	
	lw		$s3, 0($sp)						# Loading the input string from the stack
	lw		$s0, 4($sp)						# Loading the result string from the stack

	lb		$t2, ($s3)						# First byte of input string
	sb		$t2, 23($s0)					# Putting byte in the 23rd memory location of the result string
	
	addi	$s3, $s3, 1						# Moving the pointer of the input string to the next byte
	lb		$t2, ($s3)						# Second character of input string
	beq		$t2, '\n', one_number			# Checking if string has ended, if so go to exit
	sb		$t2, 24($s0)					# If not, store the second byte to 24th memory location of the result string

	j		exit							# Jumping to exit				
one_number:
	lb		$s4, space
	sb		$s4, 24($s0)
exit:
	sw		$s0, 4($sp)						# Storing the final_string to the stack		
	jr		$ra

# --------------------------- Fibonacci Function ------------------------------------------------ #

fibonacci:
	lw 		$t5, 0($sp)						# Loading the value of the number

	beq		$t5, 0, print_num				# Checking if number is 0
	beq		$t5, 1, print_num				# Checking if number is 1

	addi	$sp, $sp, 4						# Shortening the stack
	addi	$t5, $t5, -1					# Decrementing the user's input because we want to execute the recursion (n-1) times

	addi	$t1, $zero, 0					# Initializing the value of $t1 to 0 (counter)
	addi	$t2, $zero, 0					# Initializing the value of $t2 to 0 f(0)
	addi	$t3, $zero, 1 					# Initializing the value of $t3 to 1 f(1)
	

recursion:
	addi 	$t1, $t1, 1						# Incrementing counter by one 
	add		$t4, $t3, $t2					# Adding the two registers (F(n) = F(n-1) + F(n-2))
	addi	$t2, $t3, 0						# Storing the value of $t3 to $t2 (F(n-2) -> F(n-1) [next])
	addi	$t3, $t4, 0						# Storing the value of $t4 to $t3 (F(n-1) -> F(n) [next])	

	bne		$t5, $t1, recursion				# Check if counter is equal to the input of the user
	addi	$sp, $sp, -4					# Enlarging the stack
	sw		$t4, 0($sp)						# Storing $t4 to the stack

	jr		$ra
	
# --------------------------- Print ------------------------------------------------------------- #

print:
	li		$v0, 4					
	la		$a0, ($s0)						# Printing the final_string		
	syscall

	li		$v0, 1
	la		$a0, ($t4)						# Printing the fibonacci number 
	syscall
	
	j		main

print_num:
	move	$t4, $t5
	sw		$t4, 0($sp)						# Printing 0 or 1
	jr		$ra

quit:
	li		$v0, 10							# Quiting Program
	syscall
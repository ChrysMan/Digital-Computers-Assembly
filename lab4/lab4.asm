.data	
	prompt: .asciiz "\nPlease determine operation, entry (E), inquiry (I) or quit (Q): \n"
	last_name_prompt: .asciiz "\nPlease enter last name: "
	first_name_prompt: .asciiz "\nPlease enter first name: "
	phone_num_prompt: .asciiz "\nPlease enter phone number: "
	entry_result: .asciiz "\nThank you, the new entry is the following: \n"
	entry_num_prompt: .asciiz "\nPlease enter the entry number you wish to retrieve: \n"
	entry_num_result: .asciiz "\nThe number is: \n"
	error_msg: .asciiz "There is no such entry in the phonebook. \n"
	error_msg_space: .asciiz "Can't make more registrations. \n" 
	space: .byte ' '
	dot: .asciiz ". " 
	.align 2
	array: .space 600
	
#########################################################
#		Save Registers									#
#  $s1 = Array			     							#	
#  $s2 = Number 60										#
#  $s3 = space     		 								#
#	    Temporary Registers							#
#  $t0 = Location of memory we want to print			#
#  $t1 = Registration Counter							#
#  $t2 = Input Check									#		
#  $t3 = Inputted number in Inquiry						#
#  $t4 = $t0	        								#
#  $t5 = byte to be processed							#
#########################################################

.text   
main:
	la 		$s1, array							# Initializes array to save register $s1
	addi	$s2, $zero, 60						# $s2 = 60
	lb		$s3, space							# Loads space in $s3
	addi	$t1, $zero, 0						# Initializes registration counter to 0	

Prompt_User:
	li 		$v0, 4	
	la 		$a0, prompt							# Prompting user to input his choice (E , I , Q)	
	syscall					 		

	li 		$v0, 12								# Reading input of the user 
	syscall

	move 	$t2, $v0 							# Moving input to temporary register $t2

	bne		$t2, 'E', Inquiry					# Check if input is not equal to 'E', then go to Inquiry 
	jal		Get_Entry							# Jump and link to Get_Entry
	j		Prompt_User							# Jumping back to Prompt_User when Get_Entry is done

Inquiry:
	bne		$t2, 'I', Quit						# Check if input is not equal to 'I', then go to Quit

	li 		$v0, 4	
	la 		$a0, entry_num_prompt				# Prompting user to enter number of the registration they want to be printed			
	syscall	

	li		$v0, 5             					# System call code for reading integer = 5 (read integer) 
	syscall 
	
	move	$t3, $v0							# Move the given integer to the temporary register $t3
	bgt		$t3, $t1, Error_entry				# Check if given interger is greather than registration counter
												# If it is go to Error_entry, and inform the user	
	li 		$v0, 4	
	la 		$a0, entry_num_result				# Printing the selected registration
	syscall	
	
	move 	$a0, $t3							# Move the given integer to $a0 to give as an argument to Print_Entry
	jal		Print_Entry							# Jump and link to Print_Entry
	j 		Prompt_User							# When done with Print_Entry jump back to Prompt_User
	

Get_Entry:
	addiu	$sp, $sp, -8						# Enlarge stack by 2 words
	sw		$ra, 0($sp)							# Store the value of $ra to the first space in the stack
	beq		$t1, 10, Error_space				# Check if there is enough space to make new registration
	addi	$t1, $t1, 1							# Increment the registration counter by 1
	sw		$t1, 4($sp)							# Store the value of the registration counter in the stack
	move	$a0, $t1							# Move the value of the registration counter to $a0
	jal		Get_Last_Name						# Jump and link to Get_Last_Name
	move	$a0, $v0							# Move the value of $v0 to $a0
	jal		Get_First_Name						# Jump and link to Get_First_Name
	move	$a0, $v0							# Move the value of $v0 to $a0
	jal		Get_Number							# Jump and link to Get_Number

	li 		$v0, 4					
	la 		$a0, entry_result					# Printing the entry result string
	syscall

	move	$a0, $t1							# Move the value of the registration counter to $a0
	jal 	Print_Entry							# Jump and link to Print_Entry
	
	lw		$ra, 0($sp)							# Giving the value saved in the stack to $ra
	lw		$t1, 4($sp)							# Giving the value saved in the stack to $t1
	addiu	$sp, $sp, 4							# Shorten the stack by 1 word
	
	jr 		$ra					
	
Get_Last_Name:
	addi	$t0, $zero, 0						# Initialing the value of the temporary register $t0 to 0 
	addi 	$a0, $a0, -1						# Decreasing $a0 (Registration Counter) by 1 to store in the correct place
	mult	$a0, $s2							# Multiplying by 60 to get to the correct location of memory
	mflo	$t0 								# Putting the product in the $t0 register
	addu	$t0, $s1, $t0						# Storing into $t0 the address we want to store the string  $t0($s1), $t0 = $t1*60 + 0 

	li 		$v0, 4					
	la 		$a0, last_name_prompt				# Prompting user to enter last name
	syscall

	li 		$v0, 8
	la 		$a0, ($t0)							# Reading last name
	li 		$a1, 20
	syscall

	move	$v0, $t0							# Moving $t0 to return register				
	
	jr		$ra			

Get_First_Name:
	move	$t0, $a0							# Moving the value of the argument to $t0
	addi	$t0, $t0, 20						# Adding 20 to the $t0 register
	
	li 		$v0, 4					
	la 		$a0, first_name_prompt				# Prompting user to enter first name
	syscall

	li 		$v0, 8
	la 		$a0, ($t0)							# Reading first name
	li 		$a1, 20
	syscall

	move	$v0, $t0							# Moving the value of $t0 to $v0 

	jr		$ra

Get_Number:
	move	$t0, $a0							# Moving the value of the argument to $t0
	addi	$t0, $t0, 20						# Adding 20 to the $t0 register
	
	
	li 		$v0, 4					
	la 		$a0, phone_num_prompt				# Prompting user to enter his phone number
	syscall

	li 		$v0, 8
	la 		$a0, ($t0)							# Reading phone number
	li 		$a1, 20
	syscall

	jr		$ra

Print_Entry:
	addiu	$sp, $sp, -4						# Enlarge stack by 1 word
	sw		$ra, 0($sp)							# Store the value of $ra in the stack
	li 		$v0, 1								# Priting the value of the registration counter
	syscall
	
	move	$t4, $a0							# Move the value of the registration counter to $a0

	li 		$v0, 4					
	la 		$a0, dot							# Prints ". "
	syscall
	
	addi	$t0, $zero, 0						# Initialing the value of the temporary register $t0 to 0  
	addiu	$t4, $t4, -1						# Decrementing the registration counter by one
	mult	$t4, $s2							# Multiplying the registration counter with 60 
	mflo	$t0 								# Getting the product of the multiplication
	addu	$t0, $s1, $t0						# Make $t0 point to the correct spot of the array 

					
	la 		$a0, 0($t0)							# Loads last name in $a0
	jal		Print_loop							# Prints last name
					
	la 		$a0, 20($t0)						# Loads first name in $a0
	jal		Print_loop							# Prints first name
				
	la 		$a0, 40($t0)						# Loads phone number in $a0
	jal		Print_loop							# Prints phone number
	
	lw		$ra, 0($sp)							# Getting the value saved in the stack in 0($sp) and giving it to $ra 
	addiu	$sp, $sp, 4							# Shorten the stack by one word

	jr		$ra

Print_loop:
	move	$t1, $a0							# Saving the value of the given string to $t1
	loop:
		lb		$t5, 0($t1) 					# Loading byte from $t1
		beq 	$t5, 10, space_and_exit 		# Checking if loaded byte is equal to "\n"
		
		li 		$v0, 11				
		move	$a0, $t5						# If here print the loaded byte 
		syscall

		addi	$t1, $t1, 1						# Moving the pointer one space to the next byte

		j 		loop
space_and_exit:
	li		$v0, 11
	move	$a0, $s3							# Prints space
	syscall

	jr		$ra

Error_entry:
	li 	$v0, 4
	la 	$a0, error_msg							# Notifying the user that there is no available space
	syscall

	j	Prompt_User	

Error_space:
	li 	$v0, 4
	la 	$a0, error_msg_space					# Notifying the user that there is no available space
	syscall

	j	Prompt_User

Quit:
	bne 	$t2, 'Q', Prompt_User				# Looping back to prompt user if input is invalid

	li	$v0, 10									# Terminating Program
	syscall
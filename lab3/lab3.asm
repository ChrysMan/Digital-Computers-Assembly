.data
	Prompt_mess1: .asciiz "Please Enter your String: "
	Prompt_mess2: .asciiz "The Processed String is: "
	space1: .byte ' '
	.align 2
	InputString: .space 100
	.align 2
	ProcessedString: .space 100


#########################################################
#  $s0 = InputString									#
#  $t0 = InputString for processing						#
#  $s1 = ProcessedString								#
#  $t1 = word in process								#
#  $t2 = character in process							#
#  $t3 = word character counter							#
#  $t4 = storing byte to compare with next byte	        #
#  $t5 = space                                          #
#########################################################
	
.text
   main:

Get_Input:
	li		$v0, 4
	la		$a0, Prompt_mess1				# Prompting the user to input a string to be processed
	syscall

	li		$v0, 8
	la		$a0, InputString				# Reading the inputted string from the user
	li		$a1, 100
	syscall	
							
	move	$s0, $a0          				# Moving the string input into the register $s0
	la		$t0, ($s0)						# Store the string input in $t0
	add		$t3, $t3, 4						# Initializes the word character counter to 4

Process:
	la	$s1, ProcessedString				# Setting to $s1 the string that we will output
    loop:							
		lw		$t1, 0($t0)					# Get word(4 characters)
	loop1: 	
		andi	$t2, $t1, 0xff				# Isolating the first character using the 0x000000FF mask
		beq		$t2, 0xa, Print_Output		# When character=(nl) jump to Print_Output
		blt		$t2, 65, case1				# If character < 'A' in ascii then go to case1
		bgt		$t2, 90, case2				# If character > 'Z' in ascii then go to case2
		addi	$t2, $t2, 32				# Adding 32 to the ascii number to make from uppercase to lowercase
		ble		$t4, 57, checkPrevChar4		# Check if previous character is less or equal to '9'
		sb		$t2, 0($s1)					# Store character in ProcessedString ($s1)
		srl		$t1, $t1, 8					# Shifting 8 bits to the right to get to the next character
		beq		$t3, 0, next4				# Checking if counter is 0, if so go to the next banch of character
		addi	$s1, $s1, 1					# Sets the pointer to the next empty space of $s1 to store the next character
		addi	$t3, $t3, -1				# Decreasing the word character counter by 1
		addi	$t4, $t2, 0					# Saving the current character in $t4
		j	loop1
	next4:  
		addi	$t0, $t0, 4					# Erase the 4 processed bytes so we can process the next 4
		add		$t3, $t3, 4					# Initialize character counter to 4
	        j	loop

	case1:
		beq 	$t2, 32, checkPrevChar1		# If character is space, check if previous character is space
		blt		$t2, 48, checkPrevChar3		# If character isn't alphanumeric, don't store
		bgt		$t2, 57, checkPrevChar3		# If character isn't alphanumeric, don't store
		bge		$t4, 97, space				# Check if previous character is greater than or equal to 'a'
		sb		$t2, 0($s1)                 # Store character in ProcessedString ($s1)
		srl		$t1, $t1, 8					# Shifting 8 bits to the right to get to the next character	
		beq		$t3, 0, next4				# Checking if counter is 0, if so go to the next banch of characters
		addi	$s1, $s1, 1					# Sets the pointer to the next empty space of $s1 to store the next character
		addi	$t3, $t3, -1				# Decreasing the word character counter by 1
		addi	$t4, $t2, 0					# Saving the current character in $t4
		j 	loop1

	case2:
		blt		$t2, 97, checkPrevChar3		# If character isn't alphanumeric, don't store
		bgt		$t2, 122, checkPrevChar3	# If character isn't alphanumeric, don't store
		ble		$t4, 57, checkPrevChar4		# Check if previous character is less or equal to '9'
		sb		$t2, 0($s1)                 # Store character in ProcessedString($s1)
		srl		$t1, $t1, 8					# Shifting 8 bits to the right to get to the next character
		beq		$t3, 0, next4				# Checking if counter is 0, if so go to the next banch of characters
		addi	$s1, $s1, 1					# Sets the pointer to the next empty space of $s1 to store the next character
		addi	$t3, $t3, -1				# Decreasing the word character counter by 1
		addi	$t4, $t2, 0					# Saving the current character in $t4
		j 	loop1
	
	check1:
		srl		$t1, $t1, 8					# Shifting 8 bits to the right to get to the next character
		beq		$t3, 0, next4				# Checking if counter is 0, if so go to the next banch of character
		addi	$t3, $t3, -1				# Decreasing the word character counter by 1
		j 	loop1
        
	checkPrevChar1: 
		beq		$t4, 32, check1				# If previous character is space go to check1 and don't store it
		sb		$t2, 0($s1)                 # Store character in ProcessedString ($s1)
		srl		$t1, $t1, 8					# Shifting 8 bits to the right to get to the next character
		beq		$t3, 0, next4				# Checking if counter is 0, if so go to the next banch of character
		addi	$s1, $s1, 1					# Sets the pointer to the next empty space of $s1 to store the next character
		addi	$t3, $t3, -1				# Decreasing the word character counter by 1
		addi	$t4, $t2, 0					# Saving the current character in $t4
		j 	loop1

	checkPrevChar3:
		beq		$t4, 32, check1				# If previous character is space go to check1 and don't store it
		lb 		$t5, space1					# Set space in $t5
		sb		$t5, 0($s1)                 # Store character in ProcessedString ($s1)
		srl		$t1, $t1, 8					# Shifting 8 bits to the right to get to the next character
		beq		$t3, 0, next4				# Checking if counter is 0, if so go to the next banch of character
		addi	$s1, $s1, 1					# Sets the pointer to the next empty space of $s1 to store the next character
		addi	$t3, $t3, -1				# Decreasing the word character counter by 1
		addi	$t4, $t5, 0					# Saving the current character in $t4
		j 	loop1

	checkPrevChar4:							# Check if previous character is letter 
		bge		$t4, 48, space				# Check if previous character is greater than or equal to '0'
		sb		$t2, 0($s1)					# Store character in ProcessedString ($s1)
		srl		$t1, $t1, 8					# Shifting 8 bits to the right to get to the next character
		beq		$t3, 0, next4				# Checking if counter is 0, if so go to the next banch of character
		addi	$s1, $s1, 1					# Sets the pointer to the next empty space of $s1 to store the next character
		addi	$t3, $t3, -1				# Decreasing the word character counter by 1
		addi	$t4, $t2, 0					# Saving the current character in $t4
		j 	loop1

	space:
		lb 		$t5, space1					# Set space in $t5
		sb		$t5, 0($s1)                 # Store character in ProcessedString ($s1)
		srl		$t1, $t1, 8					# Shifting 8 bits to the right to get to the next character
		addi	$s1, $s1, 1					# Sets the pointer to the next empty space of $s1 to store the next character
		sb		$t2, 0($s1)					# Store number/letter in ProcessedString ($s1)
		addi	$s1, $s1, 1					# Sets the pointer to the next empty space of $s1 to store the next character
		beq		$t3, 0, next4				# Checking if counter is 0, if so go to the next banch of character
		addi	$t3, $t3, -1				# Decreasing the word character counter by 1
		addi	$t4, $t2, 0					# Saving the current character in $t4
		j 	loop1	

Print_Output:
	li		$v0, 4					
	la		$a0, Prompt_mess2				# Print Prompt_mess2
	syscall

	li		$v0, 4
	la		$a0, ProcessedString			# Print Processed string
	syscall

	li		$v0, 10							# Terminating program
	syscall						 
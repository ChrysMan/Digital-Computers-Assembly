.data
	prompt: .asciiz "Enter an integer: "
	message: .asciiz "Hello World! "
	
.text
     main:
	#Prompt the user
	li $v0, 4
	la $a0, prompt
	syscall

	#Get the integer
	li $v0, 5
	syscall
	
	#Multiply Integer by 2
	sll $t0, $v0, 1
	
	# Display message
	li $v0, 4
	la $a0, message
	syscall
	
	# Display final number
	li $v0, 1
	move $a0, $t0
	syscall
	
li $v0, 10 # terminate program
syscall
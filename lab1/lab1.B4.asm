.data
	prompt: .asciiz "Give a character: "
	message: .asciiz "\nHello World! "
	char: .byte ' '
.text
     main:
	li $v0, 4
	la $a0, prompt		# Display prompt to ther user
	syscall

	li $v0, 12		
	syscall
				# Read Character
	la $s0, char
	sb $v0, char

	li $v0, 4
	la $a0, message		# Display 'Hello World' message
	syscall
	
	lb $a0, char
	li $v0, 11		# Display given character after message
	syscall

li $v0, 10 			# Terminate program
syscall
.data
	message: .asciiz "Enter a string: "
        user_input: .space 15
	string1: .asciiz "Hello "
	string2: .asciiz " World!"

.text
   main:
	li $v0, 4
	la $a0, message #Enter a string
	syscall

	li $v0, 8
	la $a0, user_input #Read String
	li $a1, 15
	syscall

	li $v0, 4
	la $a0, string1 #Hello
	syscall
	
	li $v0, 4
	la $a0, user_input #User input
	syscall

	li $v0, 4
	la $a0, string2 #World
	syscall

li $v0, 10 # terminate program
syscall


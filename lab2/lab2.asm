.data
        mes1: .asciiz "Please enter the 1st Number:\n"
        mes2: .asciiz "Please enter the operation:\n"
        mes3: .asciiz "\nPlease enter the 2nd Number:\n"
        mes4: .asciiz "\nThe result is: " 
        error: .asciiz "\nError: Try again\n"

.text
     main:
        # Print first message
        li $v0, 4
        la $a0, mes1
        syscall

        # Read the first integer
        li $v0, 5
        syscall
	move $t0, $v0

        # Print second message
        li $v0, 4
        la $a0, mes2
        syscall

        # Read operation
        li $v0, 12
        syscall
        move $t1, $v0
 	
	# Print third message
        li $v0, 4
        la $a0, mes3
        syscall

        # Read the second integer
        li $v0, 5
        syscall
	move $t2, $v0
        
        bne $t1, 43, subtraction
        add $t7, $t0, $t2 	# Addition 
        j exit
subtraction: 
	bne $t1, 45, multiplication
        sub $t7, $t0, $t2 	# Subtraction
        j exit
multiplication:
	bne $t1, 42, division
        mult $t0, $t2           # Multiplication
        mflo $t7
        j exit
division: 
	bne $t1, 47, else
        div $t7, $t0, $t2       # Division
        j exit
  else: 
	li $v0, 4
        la $a0, error
        syscall
	j main
  exit: 
	li $v0, 4               # Print result
        la $a0, mes4
        syscall
     
        li $v0, 1    
        move $a0, $t7
        syscall
        
        li $v0, 10              # Terminate program
        syscall







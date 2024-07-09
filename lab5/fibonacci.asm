.data
	prompt_int: .asciiz "Enter a positive integer: "
	result_string: .asciiz "\nThe Fibonacci number is: "
	space: .asciiz "\n"
	space1: .asciiz "  t1="
.text
main: 
## Print prompt user for the number
	li $v0, 4             	# system call code for printing string = 4 
        la $a0, prompt_int 	# load address of string to be printed into $a0 
        syscall               	# call operating system to perform operation # specified in $v0 
## Read the number into $t0
	li $v0, 5             	# system call code for reading integer = 5 (read integer) 
        syscall               	# call operating system to perform operation # specified in $v0 
        addi $t0, $v0, 0      	# move first operand from $v0 to $t0 

## Copy "num" into the stack, to be used as the "n" from sum() 
	addi $sp, $sp, -8	# enlarge the stack, to make room for "num". "res" will also be found here.
	sw $t0, 0($sp)		# add "num" to top of stack
	jal fibo		# call sum()
	lw $t1, 4($sp)		# take the result "res" from top of stack, stored there by sum()
	addi $sp, $sp, 8	# restore stack pointer

## Print the result string 
        li $v0, 4             	# system call code for printing string = 4 
        la $a0, result_string 	# load address of string to be printed into $a0 
        syscall               	# call operating system to perform operation # specified in $v0 

## Print the result number 
        li $v0, 1            	# system call code for printing integer = 1
        addi $a0, $t1, 0    	# move result from $t1 into $a0 
        syscall              	# call operating system to perform operation # specified in $v0 

# terminate program ... 
 	li $v0, 10             # calling "exit" syscall 
        syscall

fibo:
	lw $t0, 0($sp)
	lw $t1, 4($sp)

	li $v0, 1            	# system call code for printing integer = 1
    addi $a0, $t0, 0    	# move result from $t0 into $a0 
    syscall  
	
	li $v0, 4            	# system call code for printing integer = 1
    la $a0, space1    		# move result from $t1 into $a0 
    syscall 
	
	li $v0, 1            	# system call code for printing integer = 1
    addi $a0, $t1, 0    	# move result from $t0 into $a0 
    syscall  

	li $v0, 4            	# system call code for printing integer = 1
    la $a0, space    		# move result from $t1 into $a0 
    syscall 

	
	addi $sp, $sp, -8
	sw	$s1, 8($sp)	#(n-1)
	sw 	$ra, 12($sp)

	slti 	$t7, $t0, 2
    beq 	$t7, $zero, else 
	bne		$t0, $zero, else2
	j exit

else:
	addi	$s1, $t0, 0
	addi	$t0, $t0, -1
	sw	$t0, 0($sp)
	slti 	$t7, $t0, 2
	bne 	$t7, $zero, else2 
	jal fibo
	lw	$t1, 4($sp)
	move	$s3, $t1	

	addi	$t0, $s1, -2
	sw	$t0, 0($sp)
	slti 	$t7, $t0, 1
	bne 	$t7, $zero, else3
	jal fibo
	lw	$t1, 4($sp)

	add	$t1, $s3, $t1
	j	exit
else2:
	addi	$s3, $t1, 1
	j	exit
else3:
	addi	$t1, $zero, 1
	add	$t1, $s3, $t1
	j 	exit
exit:
	lw	$s1, 8($sp)	#(n-1)
	lw 	$ra, 12($sp)
	addi	$sp, $sp, 8

	sw	$t1, 4($sp)
	sw	$t0, 0($sp)
	
	jr	$ra

	




















	
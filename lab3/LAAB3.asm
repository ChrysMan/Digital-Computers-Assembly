.data
	inputMsg: .asciiz "Please Enter your String: "
	outputMsg: .asciiz "The Processed String is: "
	again: .asciiz " "
	.align 2
	userString: .space 100
	.align 2
	processedString: .space 100
	
.text
main:
		j Get_Input
		j Print_Output

Get_Input:	la $a0, inputMsg
		li $v0, 4
		syscall
		
		li $v0, 8      
   		la $a0, userString 
    		li $a1, 100
    		
    		move $s0, $a0
    		la $t5, ($s0)
    		syscall
		
    		j Process
Process:
    		la $s1, processedString
		j case1

	loop: 	andi $t3, $t0, 0x000000ff
		beq $t3, 0x0000000a, Print_Output
		blt $t3, 'A', case3
		bgt $t3, 'Z', case4
		addi $t3, $t3, 32
		sb $t3, 0($s1)
		srl $t0,$t0, 8
		beq $t2, 4, case2 
    		addi $t2, $t2, 1
    		addi $s1, $s1, 1
		addi $t6, $t3, 0
    		j loop

	case1:  lw $t0, 0($t5)
		j loop
		
	case2:  addi $t5, $t5, 4
		li $t2, 0
    		j case1
		
	case3:	beq $t3, ' ', case3.2
		blt $t3, '0', case3.1
    		bgt $t3, '9', case3.1
		sb $t3, 0($s1)
		srl $t0,$t0, 8
		beq $t2, 4, case2
    		addi $t2, $t2, 1
    		addi $s1, $s1, 1
		addi $t6, $t3, 0
    		j loop
		
	case3.1:beq $t6, 32, case5
		addi $t3, $t4, 32	
		sb $t3, 0($s1)
		srl $t0,$t0, 8
		beq $t2, 4, case2
    		addi $t2, $t2, 1  
    		addi $s1, $s1, 1
		addi $t6, $t3, 0
    		j loop
		
	case3.2:beq $t6, 32, case5
		sb $t3, 0($s1)
		srl $t0,$t0, 8
		beq $t2, 4, case2
    		addi $t2, $t2, 1
    		addi $s1, $s1, 1
		addi $t6, $t3, 0
    		j loop
		
	case4:  blt $t3,'a', case4.1
    		bgt $t3,'z', case4.1
		sb $t3, 0($s1)
		srl $t0, $t0, 8	
     		beq $t2, 4, case2
    		addi $t2, $t2, 1
    		addi $s1, $s1, 1
		addi $t6, $t3, 0
		j loop
		
	case4.1:beq $t6, 32, case5
		addi $t3, $t4, 32	
		sb $t3, 0($s1)
		srl $t0, $t0, 8
		beq $t2, 4, case2
    		addi $t2, $t2, 1
    		addi $s1, $s1, 1
		addi $t6, $t3, 0
    		j loop
	
	case5:  srl $t0,$t0, 8 
    		beq $t2, 4, case2 
    		addi $t2, $t2, 1
    		j loop

Print_Output:	la $a0, outputMsg
		li $v0, 4
		syscall
		
		la $a0, processedString
		li $v0, 4
		syscall
		j Exit
		
Exit:		li $v0, 10
		syscall













































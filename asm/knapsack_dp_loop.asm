main:    
    lw $a2 0($0)   # knapsack_capacity = in_buffer[0];
    lw $a0 4($0)   # item_num = in_buffer[1];
    addi $a1 $0 8
    jal knapsack_dp_loop

    move $a0 $v0
    j show_bcd

knapsack_dp_loop:
    addi $s0 $0 256 # cache_ptr
    addi $t0 $0 0
    add $t1 $a1 $0
loop1:
    bge $t0, $a0, then1	# if i < item_num then loop
    lw $t2 0($t1)   # int weight = item_list[i].weight
    addi $t1 $t1 4  
    lw $t3 0($t1)   # int val = item_list[i].value
    addi $t1 $t1 4
    
    move $t4 $a2 # j = knapsack_capacity
loop2:
    bltz $t4 then2
    blt $t4, $t2, else	# if j < weight then else
    sll	$t5, $t4, 2			# $t5 = $t4 << 2
    add $t5 $t5 $s0        # $t5 = &cache_ptr[j]
    lw $t6 0($t5)   # $t6 = cache_ptr[j]
    sub	$t8, $t4, $t2		# $t0 = $t4 - $t2(j - weight)
    sll $t8 $t8 2
    add $t8 $t8 $s0        # $t8 = &cache_ptr[j - weight]
    lw $t7 0($t8)           # $t7 = cache_ptr[j - weight]
    add $t7 $t7 $t3         # $t7 = cache_ptr[j - weight] + val
    bgt $t6 $t7 else
    sw $t7 0($t5)

else:
    addi $t4 $t4 -1
    j loop2

then2:  
    addi $t0 $t0 1
    j loop1              # jump to loop
    
then1:
    sll $t0 $a2 2
    add $t0 $s0 $t0
    lw $v0 0($t0)
    jr $ra					# jump to $ra

show_bcd:
    lui $a0 0x4000
    addi $a0 $a0 0x0010

show0:
    andi $a1 $v0 0x0f
    jal show_digits 
    addi $a2 $a2 0x100
    sw $a2 0($a0)

show1:
    sra $a1 $v0 4
    andi $a1 $a1 0x0f
    jal show_digits
    addi $a2 $a2 0x200
    sw $a2 0($a0)

show2:
    sra $a1 $v0 8
    andi $a1 $a1 0x0f
    jal show_digits
    addi $a2 $a2 0x400
    sw $a2 0($a0)

show3:
    sra $a1 $v0 12
    andi $a1 $a1 0x0f
    jal show_digits
    addi $a2 $a2 0x800
    sw $a2 0($a0)
    j show0

show_digits:
    bne $a1 $0 digit1
    addi $a2 $0 0x3f
    jr $ra

digit1:
    subi $a2 $a1 1
    bne $a2 $0 digit2
    addi $a2 $0 0x06
    jr $ra

digit2:
    subi $a2 $a1 2
    bne $a2 $0 digit3
    addi $a2 $0 0x5b
    jr $ra

digit3:
    subi $a2 $a1 3
    bne $a2 $0 digit4
    addi $a2 $0 0x4f
    jr $ra

digit4:
    subi $a2 $a1 4
    bne $a2 $0 digit5
    addi $a2 $0 0x66
    jr $ra

digit5:
    subi $a2 $a1 5
    bne $a2 $0 digit6
    addi $a2 $0 0x6d
    jr $ra

digit6:
    subi $a2 $a1 6
    bne $a2 $0 digit7
    addi $a2 $0 0x7d
    jr $ra

digit7:
    subi $a2 $a1 7
    bne $a2 $0 digit8
    addi $a2 $0 0x07
    jr $ra

digit8:
    subi $a2 $a1 8
    bne $a2 $0 digit9
    addi $a2 $0 0x7f
    jr $ra

digit9:
    subi $a2 $a1 9
    bne $a2 $0 digit10
    addi $a2 $0 0x6f
    jr $ra

digit10:
    subi $a2 $a1 0x0a
    bne $a2 $0 digit11
    addi $a2 $0 0x77
    jr $ra

digit11:
    subi $a2 $a1 0x0b
    bne $a2 $0 digit12
    addi $a2 $0 0x7c
    jr $ra

digit12:
    subi $a2 $a1 0x0c
    bne $a2 $0 digit13
    addi $a2 $0 0x39
    jr $ra

digit13:
    subi $a2 $a1 0x0d
    bne $a2 $0 digit14
    addi $a2 $0 0x5e
    jr $ra

digit14:
    subi $a2 $a1 0x0e
    bne $a2 $0 digit15
    addi $a2 $0 0x79
    jr $ra

digit15:
    addi $a2 $0 0x71
    jr $ra

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:

.globl create_network
create_network:
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	
	move $s0, $a0
	move $s1, $a1
	
	bltz $a0, neg_input
	bltz $a1, neg_input
	
	add $a0, $a0, $a1 # Number of Nodes and Edges
	li $t0, 4
	mul $a0, $a0, $t0 # 4 * (Nodes + Edges)
	addi $a0, $a0, 16
	li $v0, 9
	syscall
	
	sw $s0, 0($v0)
	sw $s1, 4($v0)
	addi $t0, $v0, 8
	li $t1, 0
	move $t2, $a0 # $t2 holds the total bytes allocated to the heap
	alloc_network:
		sub $t3, $t0, $v0
		beq $t3, $t2, end_network
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		j alloc_network
	
	neg_input:
		li $v0, -1
	end_network:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		addi $sp, $sp, 8
		jr $ra

.globl add_person
add_person:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	move $s0, $a0
	move $s1, $a1
	
	lbu $t0, 0($a1)
	beqz $t0, add_person_error # If $a1 is an empty string
	lw $t0, 0($a0)
	lw $t1, 8($a0)
	beq $t0, $t1, add_person_error # If the number of nodes is maxed
	
	jal get_person
	bgtz $v1, add_person_error # If the person was found
	
	li $t0, 1 # Length counter
	move $t1, $a1 # Char pointer towards the string
	str_len:
		lbu $t2, 0($t1)
		beqz $t2, end_str_len
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		j str_len
		
	end_str_len:
	
	li $a0, 4 # Allocates space for int K
	div $t0, $a0
	mfhi $t1
 	sub $t1, $a0, $t1 # 4 - (Length % 4)
	div $t1, $a0
	mfhi $t1 # (4 - (Length % 4)) % 4
	
	add $a0, $a0, $t0 # Allocates space for the input string
	add $a0, $a0, $t1 # Add to reach a multiple of 4 for word alignment
	li $v0, 9
	syscall
	addi $t0, $t0, -1
	sw $t0, 0($v0) # Stores K in the Node
	
	move $t0, $v0
	move $t1, $a1
	copy_str:
		lbu $t2, 0($t1)
		sb $t2, 4($t0)
		addi $t1, $t1, 1 # Increments the string pointer
		addi $t0, $t0, 1 # Increments the pointer in Node
		bnez $t2, copy_str # Continues copying if NULL is not detected
		
	li $t3, 4
	lw $t4, 8($s0)
	mul $t5, $t4, $t3
	add $t5, $t5, $s0
	sw $v0, 16($t5)
		
	addi $t4, $t4, 1
	sw $t4, 8($s0)
	
	move $v0, $s0
	li $v1, 1
	j end_add_person
	
	add_person_error:
		li $v0, -1
		li $v1, -1
	end_add_person:
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		addi $sp, $sp, 12
		jr $ra

.globl get_person
get_person:
	lw $t0, 8($a0)
	li $t1, 0
	addi $t2, $a0, 12
	
	search_person_loop:
		addi $t2, $t2, 4
		beq $t0, $t1 no_person_found
		addi $t1, $t1, 1
		lw $t3, 0($t2) # Temp address for the Nodes
		addi $t4, $t3, 4 # Address of the string in the Node
		move $t5, $a1 # Address of the given string input
		cmp_str_loop:
			lbu $t6, 0($t4)
			lbu $t7, 0($t5)
			bne $t6, $t7, search_person_loop
			addi $t4, $t4, 1
			addi $t5, $t5, 1
			bnez $t6, cmp_str_loop # $t6 = $t7, but NULL has not been reached yet
		move $v0, $t3 # Stores address of the Node containing the string
		li $v1, 1
		j end_get_person
	
	no_person_found:	
		li $v0, -1
		li $v1, -1
	end_get_person:
		jr $ra

.globl add_relation
add_relation:
	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	jal get_person
	bltz $v1, add_relation_error # If name1 does not exist
	move $s4, $v0
	
	move $a0, $s0
	move $a1, $s2
	jal get_person
	bltz $v1, add_relation_error2 # If name2 does not exist
	move $s5, $v0
	
	lw $t0, 4($a0)
	lw $t1, 12($a0)
	beq $t0, $t1, add_relation_error3 # If the number of edges is maxed
	
	bltz $s3, add_relation_error4 # If relation is less than 0
	
	li $t0, 3
	bgt $s3, $t0, add_relation_error5 # If relation is greater than 3
	
	move $t0, $s1 # Address of the string in the Node
	move $t1, $s2 # Address of the given string input
	identical_str:
		lbu $t2, 0($t0)
		lbu $t3, 0($t1)
		bne $t2, $t3, not_identical
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		beqz $t2, add_relation_error # $t2 = $t3 for all instances including the NULL terminator
		j identical_str
	
	not_identical:
	
	move $a0, $s0
	move $a1, $s4
	move $a2, $s5
	jal get_edge
	bgtz $v1, add_relation_error6 # If an Edge is discovered with name1 and name2 Nodes
	
	li $a0, 12
	li $v0, 9
	syscall
	
	li $t0, 4
	lw $t1, 0($s0)
	mul $t2, $t0, $t1 # 4 * Nodes
	
	li $t0, 4
	lw $t1, 12($s0)
	mul $t3, $t0, $t1 # 4 * Edges
	
	add $t4, $t2, $t3
	add $t4, $t4, $s0
	sw $v0, 16($t4) # Stores reference in next available position
	
	sw $s4, 0($v0)
	sw $s5, 4($v0)
	sw $s3, 8($v0)
	
	lw $t0, 12($s0)
	addi $t0, $t0, 1
	sw $t0, 12($s0) # Increments current number of edges
	
	move $v0, $s0
	li $v1, 1
	j end_add_relation
	
	add_relation_error:
		li $v0, -1
		li $v1, -1
		j end_add_relation
	
	add_relation_error2:
		li $v0, -2
		li $v1, -2
		j end_add_relation
	
	add_relation_error3:
		li $v0, -3
		li $v1, -3
		j end_add_relation
	
	add_relation_error4:
		li $v0, -4
		li $v1, -4
		j end_add_relation
	
	add_relation_error5:
		li $v0, -5
		li $v1, -5
		j end_add_relation
	
	add_relation_error6:
		li $v0, -6
		li $v1, -6
		j end_add_relation
	
	end_add_relation:
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		addi $sp, $sp, 28
		jr $ra

.globl get_distant_friends
get_distant_friends:
	addi $sp, $sp, -36
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	
	move $s0, $a0
	move $s1, $a1
	
	jal get_person
	bltz $v1, name_not_found
	move $s5, $v0
	
	lw $t0, 8($s0)
	li $a0, 12
	mul $a0, $a0, $t0 # 12 * # of Nodes
	li $v0, 9
	syscall
	move $s2, $v0
	
	# Set it the form {Node Address, 0(isVisited), 0 (isDistantFriend)}
	li $t0, 0
	move $t1, $v0
	fill_nodes_arr:
		beq $t0, $a0, end_fill_nodes_arr
		li $t2, 3
		div $t0, $t2
		mflo $t2
		add $t2, $t2, $s0
		lw $t3, 16($t2) # Node Address of the current pointer
		sw $t3, 0($t1)
		
		li $t4, 0
		sw $t4, 4($t1)
		sw $t4, 8($t1) # Initializes isVisited and isDistantFriend as 0
		
		addi $t0, $t0, 12
		addi $t1, $t1, 12
		j fill_nodes_arr
	end_fill_nodes_arr:
	
	move $a0, $s0
	move $a1, $s5
	move $a2, $s2
	li $a3, 0
	jal dfs
	
	li $s6, -1
	
	move $s3, $s2 # Starting address of the array
	lw $t1, 8($s0)
	li $t2, 12
	mul $t1, $t1, $t2 # 12 * # of Nodes
	add $s4, $t1, $s2 # Ending address of the array
	check_arr_loop:
		beq $s3, $s4, end_check_arr
		lw $t0, 8($s3)
		li $t1, 1
		bne $t0, $t1, fail_dist_check
		
		move $a0, $s0
		move $a1, $s5
		lw $a2, 0($s3)
		jal get_edge
		bltz $v1, skip_imm_check # If an edge does not exist, then they are not immediate friends
		
		lw $t0, 8($v0)
		li $t1, 1
		beq $t0, $t1, fail_dist_check # If immediate friends
		
		skip_imm_check:
			li $t0, 1 # Length counter
			lw $t1, 0($s3)
			addi $t1, $t1, 4 # Char pointer towards the string
			count_str:
				lbu $t2, 0($t1)
				beqz $t2, end_count_str
				addi $t0, $t0, 1
				addi $t1, $t1, 1
				j count_str
		
			end_count_str:
			
			li $a0, 4
			div $t0, $a0
			mfhi $t1
 			sub $t1, $a0, $t1 # 4 - (Length % 4)
 			div $t1, $a0
 			mfhi $t1
 			
			add $a0, $a0, $t0 # Allocates space for the input string
			add $a0, $a0, $t1 # Add to reach a multiple of 4 for word alignment
			li $v0, 9
			syscall
			
			move $t0, $v0
			lw $t1, 0($s3)
			addi $t1, $t1, 4
			wrt_str:
				lbu $t2, 0($t1)
				sb $t2, 0($t0)
				addi $t1, $t1, 1 # Increments the string pointer
				addi $t0, $t0, 1 # Increments the pointer in Node
				bnez $t2, wrt_str # Continues copying if NULL is not detected
			
			li $t2, -1
			bne $s6, $t2, skip_head_link # Skip if $s6 already holds an address
			
			move $s6, $v0 # If $s6 = -1, set $s6 to the starting address
			add $s7, $s6, $a0
			addi $s7, $s7, -4 # Set $s7 to the link reference
			li $t0, 0
			sw $t0, 0($s7) # Initializes reference to 0 if tail
			j fin_head_link
			
			skip_head_link:
				addi $t3, $s7, 4
				sw $t3, 0($s7)
				
				add $s7, $s7, $a0
				li $t0, 0
				sw $t0, 0($s7) # Initializes reference to 0 if tail
				
			fin_head_link:
		fail_dist_check:
		
		addi $s3, $s3, 12
		j check_arr_loop
		
		
	end_check_arr:
		move $v0, $s6
		j end_get_distant_friends
	
	name_not_found:
		li $v0, -2
	
	end_get_distant_friends:
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		addi $sp, $sp, 36
		jr $ra
	
.globl get_edge
get_edge:
	# $a0 = Network
	# $a1 = Address of 1st Node
	# $a2 = Address of 2nd Node
	# $v0 = Address of Edge if found, -1 otherwise
	# $v1 = 1 if found and -1 otherwise

	li $t3, 4
	lw $t4, 0($a0)
	mul $t3, $t3, $t4 # 4 * Nodes
	
	lw $t0, 12($a0)
	li $t1, 0
	addi $t2, $a0, 16
	add $t2, $t2, $t3 # Pointer to the array with Edge references
	search_edge_loop:
		beq $t0, $t1 no_edge_found
		lw $t3, 0($t2)
		lw $t4, 0($t3) # Node 1
		lw $t5, 4($t3) # Node 2
		
		beq $t4, $a1, node1_present
		beq $t4, $a2, node2_present
		j nodes_not_present
		
		node1_present:
			beq $t5, $a2, found_edge
		node2_present:
			beq $t5, $a1, found_edge
		nodes_not_present:
		
		addi $t1, $t1, 1
		addi $t2, $t2, 4
		j search_edge_loop
		
	found_edge:
		move $v0, $t3 # Stores address of the found Edge
		li $v1, 1
		j end_get_edge
	
	no_edge_found:
		li $v0, -1
		li $v1, -1
	
	end_get_edge:
		jr $ra

.globl dfs
dfs:
	# $a0 = Network
	# $a1 = Node Address
	# $a2 = Nodes Array - {Node, Boolean (Visited), Boolean (isDistantFriend)}
	# $a3 = Path Length
	
	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	move $a0, $a2
	jal find_node_index
	lw $t0, 4($v0) # Visited value of the Node
	bnez $t0, end_dfs # If visited, END
	
	li $t0, 1
	sw $t0, 4($v0) # Set as visited
	
	ble $s3, $t0, not_distant
	sw $t0, 8($v0) # If path > 1, then set isDistantFriend value to 1
	not_distant:
	
	lw $t0, 8($s0)
	li $t1, 12
	mul $s4, $t0, $t1 # 12 * Number of Nodes
	li $s5, 0 # Loop Counter
	adj_friend_loop:
		beq $s4, $s5, end_adj_friend
		add $t0, $s5, $s2
		lw $t1, 0($t0)
		beq $t1, $s1, skip_dfs_recurs # Prevents nodes from calling DFS on itself
		
		move $a0, $s0
		move $a1, $s1
		move $a2, $t1
		jal get_edge
		bltz $v1, skip_dfs_recurs # If the nodes are not adjacent
		
		lw $t0, 8($v0)
		li $t1, 1
		bne $t0, $t1, skip_dfs_recurs # If the edge between the nodes is not a friend edge
		
		move $a0, $s0
		add $t0, $s5, $s2
		lw $a1, 0($t0)
		move $a2, $s2
		addi $a3, $s3, 1
		jal dfs 
		
		skip_dfs_recurs:
		
		addi $s5, $s5, 12
		j adj_friend_loop
		
	end_adj_friend:
	
	move $a0, $s2
	move $a1, $s1
	jal find_node_index
	li $t0, 0
	sw $t0, 4($v0) # Set as not visited
	
	end_dfs:
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		addi $sp, $sp, 28
		jr $ra
	
.globl find_node_index
find_node_index:
	# $a0 = Starting Address
	# $a1 = Node Address
	# $v0 = Address of Position in $a0
	# Constraint - Used only when $a1 is known to be present in $a0

	search_node:
		lw $t0, 0($a0)
		addi $a0, $a0, 12
		bne $t0, $a1, search_node
		
	addi $v0, $a0, -12
	jr $ra

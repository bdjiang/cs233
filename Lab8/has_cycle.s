.data

.text
## struct Node {
##     int node_id;            // Unique node ID
##     struct Node **children; // pointer to null terminated array of children node pointers
## };
##
## int
## has_cycle(Node *root, int num_nodes) {
##     if (!root)
##         return 0;
##
##     Node *stack[num_nodes];
##     stack[0] = root;
##     int stack_size = 1;
##
##     int discovered[num_nodes];
##     for (int i = 0; i < num_nodes; i++) {
##         discovered[i] = 0;
##     }
##
##     while (stack_size > 0) {
##         Node *node_ptr = stack[--stack_size];
##
##         if (discovered[node_ptr->node_id]) {
##             return 1;
##         }
##         discovered[node_ptr->node_id] = 1;
##
##         for (Node **edge_ptr = node_ptr->children; *edge_ptr; edge_ptr++) {
##             stack[stack_size++] = *edge_ptr;
##         }
##     }
##
##     return 0;
## }

.globl has_cycle
has_cycle:

	beq $a0, $0, return

	mul $t0, $a1, 8					# amount of stack space to be allocated
	sub $sp, $sp, $t0
	move $s0, $t0						# $s0 contains amount allocated

	add $t6, $0, 1					# $t0 is stack_size
	move $s1, $sp						# $s1 contains stack for stack array

	mul $t1, $a1, 4					# for discovered array
	sub $sp, $sp, $t1				# $sp points to discovered array

	add $s0, $s0, $t1


	sw $a0, 0($s1)
	add $t0, $a0, 4
	sw $t0, 4($s1)


	move $t1, $0						# $t1 is i (for loop only)
for:
	beq $t1, $a1, while
	mul $t2, $t1, 4					# makeshift offset
	add $t2, $sp, $t2				# addr of discovered[i]
	sw $0, 0($t2)
	add $t1, $t1, 1
	j for

	##     while (stack_size > 0) {
	##         Node *node_ptr = stack[--stack_size];
	##
	##         if (discovered[node_ptr->node_id]) {
	##             return 1;
	##         }
	##         discovered[node_ptr->node_id] = 1;
	##
	##         for (Node **edge_ptr = node_ptr->children; *edge_ptr; edge_ptr++) {
	##             stack[stack_size++] = *edge_ptr;
	##         }
	##     }

while:
	blez $t0, return
	sub $t6, $t6, 1					# stack_size - 1
	mul $t1, $t6, 8					# get offset of stack[stack_size]
	add $t1, $t1, $s1				# $t1 contains addr of stack[stack_size]
	move $t5, $t1

	lw $t1, 0($t1)					# and now $t1 contains node_ptr->node_id
	mul $t1, $t1, 4					# offset for discovered array
	add $t1, $t1, $sp				# addr of discovered[node_ptr->node_id]
	lw $t2, 0($t1)					# actual value
	lw $t2, 0($t2)

	bne $t2, $0, special_return
	add $t3, $0, 1
	sw $t3, 0($t1)					# discovered[node_ptr->node_id] = 1;

	add $t5, $t5, 4
	lw $t5, 0($t5) 					# node_ptr->children
while_for:
	beq $t5, $0, end_for
	lw $t5, 0($t5)
	sw $t5, 0($t4)
	add $t6, $t6, 1

	j while_for

end_for:
	j while

special_return:
	move $v0, $0
	add $v0, $v0, 1
	add $sp, $sp, $s0
	jr $ra

return:
	add $sp, $sp, $s0
	move $v0, $0
	jr $ra

.data

.text

## struct Node {
##     int node_id;            // Unique node ID
##     struct Node **children; // pointer to null terminated array of children node pointers
## };
##
## int
## max_depth(Node *current) {
##     if (current == NULL)
##         return 0;
##
##     int cur_child = 0;
##     Node *child = current->children[cur_child];
##     int max = 0;
##     while (child != NULL) {
##         int depth = max_depth(child);
##         if (depth > max)
##             max = depth;
##         cur_child++;
##         child = current->children[cur_child];
##     }
##     return 1 + max;
## }

.globl max_depth
max_depth:
	beq $a0, $0, null

	move $t0, $0			# $t0 = cur_child
	move $t1, $0			# $t1 = max
	sub $sp, $sp, 80
	sw $ra, 64($sp)

	add $t2, $a0, 4
	lw $t2, 0($t2)
	add $t2, $t2, $t0	# $t2 = *child

while:
	beq $t2, $0, return
	move $a0, $t2
	move $s0, $t0
	move $s1, $t1
	jal max_depth
	move $t0, $s0
	move $t1, $s1
	move $t5, $v0
	slt $t7, $t1, $t5
	bne $t7, $0, if
continue:
	add $t0, $t0, 1

	add $t2, $a0, 4
	lw $t2, 0($t2)
	add $t2, $t2, $t0	# $t2 = *child
	j while

if:
	move $t1, $t5
	j continue


null:
	move $v0, $0
	lw $ra, 64($sp)
	add $sp, $sp, 80
	jr $ra

return:
	lw $ra, 64($sp)
	add $sp, $sp, 80
	move $v0, $0
	add $v0, $t1, 1
	jr $ra

# before running your code for the first time, run:
#     module load QtSpim
# run with:
#     QtSpim -file main.s question_5.s

# 
# void selection_sort(char **array, int length) {
#     for (int i = 0; i < length; i++) {
#        int current_best = i;
# 
#        for (int j = i + 1; j < length; j++) {
#           if (strcmp(array[j], array[current_best]) < 0) {  // do not inline, call with "jal strcmp"
#              current_best = j;
#           }
#        }
# 
#        char *temp = array[i];
#        array[i] = array[current_best];
#        array[current_best] = temp;
#     }
# }
.globl selection_sort
selection_sort:
	li $t0, 0			#i = $t0
first_for:
	beq $t0, $a1, return
	move $t1, $t0		#current_best = $t1

	add $t2, $t0, 1			#j = $t2
second_for:
	beq $t2, $a1, end_for
	
	la $t5, 0($a0)
	add $t4, $t5, $t2		#$t4 is array[j]
	la $t4, 0($t4)
	add $t5, $t5, $t1		#t5 is array[current_best]
	la $t5, 0($t5)

	sub $sp, $sp, 16
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $ra, 12($sp)

	move $a0, $t4
	move $a1, $t5
	jal strcmp

	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $ra, 12($sp)
	add $sp, $sp, 12
	
	bge $v0, $0, second_for_setup

	move $t1, $t2
	add $t2, $t2, 1
	j second_for

second_for_setup:
	add $t2, $t2, 1
	j second_for

end_for:
	la $t5, 0($a0)
	add $t5, $t5, $t0	
	move $t7, $t5		#t7 is addr of array[i]	
	la $t6, 0($t5)		# t6 is array[i] or temp
	
	la $t5, 0($a0)
	add $t5, $t5, $t1	# addr of curr best array is $t8
	move $t8, $t5
	la $t5, 0($t5)
	
	sw $t5, 0($t7)
	sw $t6, 0($t8)
	add $t0, $t0, 1
	j first_for

return:
	jr $ra

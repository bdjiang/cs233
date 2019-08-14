# before running your code for the first time, run:
#     module load QtSpim
# run with:
#     QtSpim -file main.s question_4.s

# char *longer_string(char *str1, char *str2) {
#     int i = 0;
#     while (1) {
#         if (str1[i] == 0) {
#             return str1;
#         }
#         if (str2[i] == 0) {
#             return str2;
#         }
#         i++;
#     }
#     return NULL;  // Should never reach
# }
.globl longer_string
longer_string:
	move $t0, $0 #t0 = i

while:
	add $t1, $a0, $t0	#t1 = addr str1[i]
	add $t2, $a1, $t0	#t2 = addr str2[i]
	lb $t1, 0($t1)		#t1 = value of str1[i]
	lb $t2, 0($t2)		#t2 = value of str2[i]

	beq $t1, $0, return_s1
	beq $t2, $0, return_s2

	add $t0, $t0, 1
	j while

return_s1:
	move $v0, $a0
	jr $ra

return_s2:
	move $v0, $a1
	jr $ra

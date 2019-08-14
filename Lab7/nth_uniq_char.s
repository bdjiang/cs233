.data
uniq_chars: .space 256

.text

## int
## nth_uniq_char(char *in_str, int n) {
##     if (!in_str || !n)
##         return -1;
##
##     uniq_chars[0] = *in_str;
##     int uniq_so_far = 1;
##     int position = 0;
##     in_str++;
##     while (uniq_so_far < n && *in_str) {
##         char is_uniq = 1;
##         for (int j = 0; j < uniq_so_far; j++) {
##             if (uniq_chars[j] == *in_str) {
##                 is_uniq = 0;
##                 break;
##             }
##         }
##         if (is_uniq) {
##             uniq_chars[uniq_so_far] = *in_str;
##             uniq_so_far++;
##         }
##         position++;
##         in_str++;
##     }
##
##     if (uniq_so_far < n) {
##         position++;
##     }
##     return position;
## }

.globl nth_uniq_char
nth_uniq_char:

	lbu $t9, 0($a0)
	beq $t9, $0, null
	beq $a0, $0, null

	la $t9, uniq_chars # $t9 = uniq_chars[0] address
	move $t8, $a0 			 # $t8 = instr[0] address

	lbu $t7, 0($t8)    # $t7 = instr[0] value

	sb $t7, 0($t9)     # uniq_chars[0] = *in_str;

	add $t0, $0, 0		 # $t0 = position = 0
	add $t1, $0, 1		 # $t1 = uniq_so_far = 0
	add $t8, $t8, 1    # in_str++

while:
	slt $t3, $t1, $a1  # $t3 is uniq_so_far < n

	beq $t3, $0, endif    # if uniq_so_far < n is FALSE
	beq $t8, $0, endif    # if *in_str is FALSE
	add $t3, $0, 1     # char is_unique = 1 = $t3


	move $t4, $0 			 # j = 0 = $t4
for:
	beq $t4, $t1, whileif
	add $t5, $t9, $t4  # $t5 is uniq_chars[j] address
	lbu $t2, 0($t5)    # $t2 is uniq_chars[j] value
	lbu $t5, 0($t8)    # $t5 is in_str value
	beq $t2, $t5, loopdone
	add $t4, $t4, 1 #j++
	j for


loopdone:
	move $t3, $0


whileif:
	beq $t3, $0, whileiterators
	add $t4, $t9, $t1  # $t4 is uniq_chars[uniq_so_far] address
	lbu $t7, 0($t8)    # $t7 = instr[current] value
	sb $t7, 0($t4)
	add $t1, $t1, 1    # uniq_so_far++


whileiterators:
	add $t0, $t0, 1 # position++
	add $t8, $t8, 1 # in_str++
	j while;



endif:
	slt $t6, $t1, $a1  # $t6 is true(1) if uniq_so_far < n
	beq $t6, $0, end	 # go to end if conditional is false
	add $t0, $t0, 1    # position++
	move $v0, $t0
	jr $ra


null:
	sub $v0, $0, 1
	jr $ra
end:
	move $v0, $t0
	jr $ra

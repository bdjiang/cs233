.text

## void
## max_unique_n_substr(char *in_str, char *out_str, int n) {
##     if (!in_str || !out_str || !n)
##         return;
##
##     char *max_marker = in_str;
##     unsigned int len_max = 0;
##     unsigned int len_in_str = my_strlen(in_str);
##     for (unsigned int cur_pos = 0; cur_pos < len_in_str; cur_pos++) {
##         char *i = in_str + cur_pos;
##         int len_cur = nth_uniq_char(i, n + 1);
##         if (len_cur > len_max) {
##             len_max = len_cur;
##             max_marker = i;
##         }
##     }
##
##     my_strncpy(out_str, max_marker, len_max);
## }

.globl max_unique_n_substr
max_unique_n_substr:



	move $s0, $a0
	move $s1, $a1
	move $s2, $a2


	move $s3, $0			# len_max = 0 = $s3
	jal my_strlen
	move $s4, $v0		  # len_in_str = $s4

	move $s5, $0      # cur_pos = 0 = $s5
for:
	beq $s5, $s4, end
	add $s6, $a0, $s5 # char *i = $s6
	move $a0, $s6
	add $a1, $a3, 1   #n+1
	jal nth_uniq_char

	move $s7, $v0    # len_cur = $s7

	slt $t4, $s3, $s7
	bne $t4, $0, if

	add $s5, $s5, 1  # cur_pos++
	j for

if:
	move $s3, $s7
	move $s0, $s6
	j for

end:
	move $a0, $s1
	move $a1, $s0
	move $a2, $s3

	jal my_strncpy

return:
	jr	$ra

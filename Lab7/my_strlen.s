.text

## unsigned int
## my_strlen(char *in) {
##     if (!in)
##         return 0;
##
##     unsigned int count = 0;
##     while (*in) {
##         count++;
##         in++;
##     }
##
##     return count;
## }

.globl my_strlen
my_strlen:
	move	$v0, $0			# $v0 = unsigned int count = 0
	bne	$a0, $0, ms_while	# if (in != NULL), skip
	jr	$ra			# return 0

ms_while:
	lb	$t0, 0($a0)		# $t0 = *in
	beq	$t0, $0, ms_done	# if (in == 0), done

	add	$v0, $v0, 1		# count++
	add	$a0, $a0, 1		# in++
	j	ms_while

ms_done:
	jr	$ra			# return count

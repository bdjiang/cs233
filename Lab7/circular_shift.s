.text

## unsigned int
## circular_shift(unsigned int in, unsigned char s) {
##     return (in >> 8 * s) | (in << (32 - 8 * s));
## }

.globl circular_shift
circular_shift:
	mul	$t0, $a1, 8 	# $t0 = 8 * s
	li	$t1, 32
	sub	$t1, $t1, $t0	# t1 = 32 - 8 * s

	srl	$t2, $a0, $t0	# $t2 = in >> 8 * s
	sll	$t3, $a0, $t1	# $t3 = in << (32 - 8 * s)

	or	$v0, $t2, $t3	# (in >> 8 * s) | (in << (32 - 8 * s))
	jr	$ra

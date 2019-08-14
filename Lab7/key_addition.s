.text

## void
## key_addition(unsigned char *in_one, unsigned char *in_two, unsigned char *out) {
##     for (unsigned int i = 0; i < 16; i++) {
##         out[i] = in_one[i] ^ in_two[i];
##     }
## }

.globl key_addition
key_addition:
	move	$t0, $0			# $t0 = unsigned int i = 0
ka_for:
	bge	$t0, 16, ka_done 	# if (i >= 16), done

	add	$t1, $a0, $t0		# &in_one[i]
	lbu	$t1, 0($t1)		# in_one[i]

	add	$t2, $a1, $t0		# &in_two[i]
	lbu	$t2, 0($t2)		# in_two[i]

	xor	$t3, $t1, $t2		# in_one[i] ^ in_two[i]

	add	$t4, $a2, $t0		# &out[i]
	sb	$t3, 0($t4)		# out[i] = in_one[i] ^ in_two[i]

	add	$t0, $t0, 1		# i++
	j	ka_for

ka_done:
	jr	$ra

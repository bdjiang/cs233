.data

.text

## void
## decrypt(unsigned char *ciphertext, unsigned char *plaintext, unsigned char *key,
##         unsigned char rounds) {
##     unsigned char A[16], B[16], C[16], D[16];
##     key_addition(ciphertext, &key[16 * rounds], C);
##     inv_shift_rows(C, (unsigned int *) B);
##     inv_byte_substitution(B, A);
##     for (unsigned int k = rounds - 1; k > 0; k--) {
##         key_addition(A, &key[16 * k], D);
##         inv_mix_column(D, C);
##         inv_shift_rows(C, (unsigned int *) B);
##         inv_byte_substitution(B, A);
##     }
##     key_addition(A, key, plaintext);
##     return;
## }

.globl decrypt
decrypt:
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3

	sub $sp, $sp, 80  #for A B C D

	sw	$ra, 64($sp)

	move $s4, $sp

	la $t1, 0($a2)  #addr of key[0]
	mul $t2, $a3, 16 #rounds*16 value
	add $t1, $t1, $t2 #addr of key[16*rounds]

	move $a1, $t1
	la $t0, 32($s4)
	move $a2, $t0

	jal key_addition

	move $a0, $a2
	la $t0, 16($s4)
	move $a1, $t0

	jal inv_shift_rows

	move $a0, $a1
	la $t0, 0($s4)
	move $a1, $t0

	jal inv_byte_substitution


	sub $a3, $a3, 1   # rounds - 1 = k
for:
	blez $a3, end

	## key_addition(A, &key[16 * k], D);
	move $a0, $s4
	mul $t0, $a3, 16 # 16*k
	add $a1, $t0, $s2
	la $t0, 48($s4)
	move $a2, $t0
	jal key_addition

	## inv_mix_column(D, C);
	move $a0, $a2
	la $t0, 32($s4)
	move $a1, $t0
	jal inv_mix_column

	## inv_shift_rows(C, (unsigned int *) B);
	move $a0, $a1
	la $t0, 16($s4)
	move $a1, $t0
	jal inv_shift_rows

	## inv_byte_substitution(B, A);
	move $a0, $a1
	la $t0, 0($s4)
	move $a1, $t0
	jal inv_byte_substitution


	sub $a3, $a3, 1
	j for

end:
	move $a0, $s4
	move $a1, $s2
	move $a2, $s1
	jal key_addition

	lw	$ra, 64($sp)
	add $sp, $sp, 80
	jr $ra

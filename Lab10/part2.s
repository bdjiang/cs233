# syscall constants
PRINT_STRING	= 4
PRINT_CHAR	= 11
PRINT_INT	= 1

# memory-mapped I/O
VELOCITY	= 0xffff0010
ANGLE		= 0xffff0014
ANGLE_CONTROL	= 0xffff0018

BOT_X		= 0xffff0020
BOT_Y		= 0xffff0024

TIMER		= 0xffff001c

REQUEST_JETSTREAM	= 0xffff00dc
REQUEST_STARCOIN	= 0xffff00e0

PRINT_INT_ADDR		= 0xffff0080
PRINT_FLOAT_ADDR	= 0xffff0084
PRINT_HEX_ADDR		= 0xffff0088

# interrupt constants
BONK_MASK	= 0x1000
BONK_ACK	= 0xffff0060

TIMER_MASK	= 0x8000
TIMER_ACK	= 0xffff006c

REQUEST_STARCOIN_INT_MASK	= 0x4000
REQUEST_STARCOIN_ACK		= 0xffff00e4

.data
# put your data things here
.align 2
map: .space 90000		#allocate space for 300x300 char array
starcoin: .space 8

.text
main:
	# put your code here :)
setup:
	la $t0, map		#load address of static memory into register $t0
	sw $t0, REQUEST_JETSTREAM	#store address into REQUEST_JETSTREAM I/O

	la $t0, 0($t0) #store base address of map into $t0

	li $t6, 10
	sw $t6, VELOCITY

	lw $t1, BOT_X
	lw $t2, BOT_Y

	move $t3, $t1		#X (colIndex)
	move $t4, $t2		#Y (rowIndex)

	# addr = baseAddress + (rowIndex*colSize + colIndex)
	mul $t5, $t4, 300		#rowIndex*colSize
	add $t5, $t5, $t3		#+colIndex
	add $t5, $t5, $t0		#+baseAddress

	lb $t5, 0($t5)			#get value of map at index


	li	$t7, TIMER_MASK		# timer interrupt enable bit
	or	$t7, $t7, REQUEST_STARCOIN_INT_MASK	# request starcoin interrupt bit
	or	$t7, $t7, 1		# global interrupt enable
	mtc0	$t7, $12		# set interrupt mask (Status register)

	la $t8, starcoin
	sw	$t8, REQUEST_STARCOIN
	la $t8, 0($t8)

	lw	$t9, TIMER		# read current time
	add	$t9, $t0, 50		# add 50 to current time
	sw	$t9, TIMER		# request timer interrupt in 50 cycles

	beq $t5, 2, jetstream


jetstream:
	lw $t1, BOT_X
	lw $t2, BOT_Y

	blt $t2, 150, top

bot:
	blt $t1, 150, bot_left

bot_right:
	li $t3, 135
	sw $t3, ANGLE
	li $t3, 1
	sw $t3, ANGLE_CONTROL

	lw $t1, BOT_X
	lw $t2, BOT_Y

	move $t3, $t1		#X (colIndex)
	move $t4, $t2		#Y (rowIndex)

	# addr = baseAddress + (rowIndex*colSize + colIndex)
	mul $t5, $t4, 300		#rowIndex*colSize
	add $t5, $t5, $t3		#+colIndex
	add $t5, $t5, $t0		#+baseAddress

	lb $t5, 0($t5)			#get value of map at index

	beq $t5, 1, turn_right
	j bot_right


bot_left:
	li $t3, 225
	sw $t3, ANGLE
	li $t3, 1
	sw $t3, ANGLE_CONTROL

	lw $t1, BOT_X
	lw $t2, BOT_Y

	move $t3, $t1		#X (colIndex)
	move $t4, $t2		#Y (rowIndex)

	# addr = baseAddress + (rowIndex*colSize + colIndex)
	mul $t5, $t4, 300		#rowIndex*colSize
	add $t5, $t5, $t3		#+colIndex
	add $t5, $t5, $t0		#+baseAddress

	lb $t5, 0($t5)			#get value of map at index

	beq $t5, 1, turn_right
	j bot_left



top:
	blt $t1, 150, top_left

top_right:
	li $t3, 45
	sw $t3, ANGLE
	li $t3, 1
	sw $t3, ANGLE_CONTROL

	lw $t1, BOT_X
	lw $t2, BOT_Y

	move $t3, $t1		#X (colIndex)
	move $t4, $t2		#Y (rowIndex)

	# addr = baseAddress + (rowIndex*colSize + colIndex)
	mul $t5, $t4, 300		#rowIndex*colSize
	add $t5, $t5, $t3		#+colIndex
	add $t5, $t5, $t0		#+baseAddress

	lb $t5, 0($t5)			#get value of map at index

	beq $t5, 1, turn_right
	j top_right



top_left:
	li $t3, 315
	sw $t3, ANGLE
	li $t3, 1
	sw $t3, ANGLE_CONTROL

	lw $t1, BOT_X
	lw $t2, BOT_Y

	move $t3, $t1		#X (colIndex)
	move $t4, $t2		#Y (rowIndex)

	# addr = baseAddress + (rowIndex*colSize + colIndex)
	mul $t5, $t4, 300		#rowIndex*colSize
	add $t5, $t5, $t3		#+colIndex
	add $t5, $t5, $t0		#+baseAddress

	lb $t5, 0($t5)			#get value of map at index

	beq $t5, 1, turn_right
	j top_left

turn_right:
	li $t3, 5
	sw $t3, ANGLE
	li $t3, 0
	sw $t3, ANGLE_CONTROL


keep_going:
	lw $t1, BOT_X
	lw $t2, BOT_Y

	move $t3, $t1		#X (colIndex)
	move $t4, $t2		#Y (rowIndex)

	# addr = baseAddress + (rowIndex*colSize + colIndex)
	mul $t5, $t4, 300		#rowIndex*colSize
	add $t5, $t5, $t3		#+colIndex
	add $t5, $t5, $t0		#+baseAddress

	lb $t5, 0($t5)			#get value of map at index

	beq $t5, 1, jetstream
	j keep_going



	# note that we infinite loop to avoid stopping the simulation early
	j	main


.kdata				# interrupt handler data (separated just for readability)
chunkIH:	.space 8	# space for two registers
non_intrpt_str:	.asciiz "Non-interrupt exception\n"
unhandled_str:	.asciiz "Unhandled interrupt type\n"

.ktext 0x80000180
interrupt_handler:
.set noat
	move	$k1, $at		# Save $at
.set at
	la	$k0, chunkIH
	sw	$a0, 0($k0)		# Get some free registers
	sw	$a1, 4($k0)		# by storing them to a global variable

	mfc0	$k0, $13		# Get Cause register
	srl	$a0, $k0, 2
	and	$a0, $a0, 0xf		# ExcCode field
	bne	$a0, 0, non_intrpt

interrupt_dispatch:			# Interrupt:
	mfc0	$k0, $13		# Get Cause register, again
	beq	$k0, 0, done		# handled all outstanding interrupts

	and $a0, $k0, REQUEST_STARCOIN_INT_MASK
	bne $a0, 0, starcoin_interrupt

	li	$v0, PRINT_STRING	# Unhandled interrupt types
	la	$a0, unhandled_str
	syscall
	j	done


starcoin_interrupt:
	sw $a1, REQUEST_STARCOIN_ACK
	j interrupt_dispatch

non_intrpt:				# was some non-interrupt
	li	$v0, PRINT_STRING
	la	$a0, non_intrpt_str
	syscall				# print out an error message
	# fall through to done

done:
	la	$k0, chunkIH
	lw	$a0, 0($k0)		# Restore saved registers
	lw	$a1, 4($k0)
.set noat
	move	$at, $k1		# Restore $at
.set at
	eret

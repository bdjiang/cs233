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

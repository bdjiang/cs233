// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// lui          (output) - the instruction is a lui
// slt          (output) - the instruction is an slt
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, lui, slt, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, lui, slt, addm;
    input  [5:0] opcode, funct;
    input        zero;

	  wire allZeroes, addFinal, subFinal, andFinal, orFinal, norFinal, xorFinal, jrFinal, sltFinal, legitFunction;
    wire notAddi, notAndi, notOri, notXori, notAdd, notSub, notAnd, notOr, notNor, notXor;
    wire beqFinal, bneFinal, addmFinal, notZero;
	  wire notBeq, notBne, notJ, notJr, notLui, notSlt, notLw, notLbu, notSw, notSb, notAddm;
    wire [21:1] row;

    assign addmFinal = 0;

	//updated with new functions
    wire addiFinal = opcode == `OP_ADDI;
    wire andiFinal = opcode == `OP_ANDI;
    wire oriFinal = opcode == `OP_ORI;
    wire xoriFinal = opcode == `OP_XORI;
	  wire jFinal = opcode == `OP_J;
	  wire luiFinal = opcode == `OP_LUI;
	  wire lwFinal = opcode == `OP_LW;
	  wire lbuFinal = opcode == `OP_LBU;
	  wire swFinal = opcode == `OP_SW;
	  wire sbFinal = opcode == `OP_SB;

    nor opcodeZeroesTest(allZeroes, opcode[0], opcode[1], opcode[2], opcode[3], opcode[4], opcode[5]);

	//updated with new functions
    wire addTest = funct == `OP0_ADD;
    wire subTest = funct == `OP0_SUB;
    wire andTest = funct == `OP0_AND;
    wire orTest = funct == `OP0_OR;
    wire norTest = funct == `OP0_NOR;
    wire xorTest = funct == `OP0_XOR;
	  wire beqTest = opcode == `OP_BEQ;
	  wire bneTest = opcode == `OP_BNE;

	  wire jrTest = funct == `OP0_JR;
	  wire sltTest = funct == `OP0_SLT;

    wire addmTest = funct == `OP0_ADDM;

    not zeroOpposite(notZero, zero);

	//updated with new functions
    and addCheck(addFinal, addTest, allZeroes);
    and subCheck(subFinal, subTest, allZeroes);
    and andCheck(andFinal, andTest, allZeroes);
    and orCheck(orFinal, orTest, allZeroes);
    and norCheck(norFinal, norTest, allZeroes);
    and xorCheck(xorFinal, xorTest, allZeroes);
	  and jrCheck(jrFinal, jrTest, allZeroes);
	  and sltCheck(sltFinal, sltTest, allZeroes);

    and beqCheck(beqFinal, beqTest, notZero);
    and bneCheck(bneFinal, bneTest, notZero);

    and addmCheck(addmFinal, addmTest, allZeroes);


	//updated with new functions
    or legitFunctionCheck(legitFunction, addiFinal, andiFinal, oriFinal, xoriFinal, addFinal, subFinal, andFinal, orFinal, norFinal, xorFinal, jrFinal, sltFinal, beqFinal, bneFinal, jFinal, luiFinal, lwFinal, lbuFinal, swFinal, sbFinal, addmFinal);

	//still good
    not exceptCheck(except, legitFunction);

    not addiNot(notAddi, addiFinal);
    not andiNot(notAndi, andiFinal);
    not oriNot(notOri, oriFinal);
    not xoriNot(notXori, xoriFinal);
    not addNot(notAdd, addFinal);
    not subNot(notSub, subFinal);
    not andNot(notAnd, andFinal);
    not orNot(notOr, orFinal);
    not norNot(notNor, norFinal);
    not xorNot(notXor, xorFinal);

	//updated with new functions
    not beqNot(notBeq, beqFinal);
    not bneNot(notBne, bneFinal);
	  not jNot(notJ, jFinal);
	  not jrNot(notJr, jrFinal);
	  not luiNot(notLui, luiFinal);
	  not sltNot(notSlt, sltFinal);
	  not lwNot(notLw, lwFinal);
	  not lbuNot(notLbu, lbuFinal);
	  not swNot(notSw, swFinal);
	  not sbNot(notSb, sbFinal);
    not addmNot(notAddm, addmFinal);

    and row1(row[1], addFinal, notSub, notAnd, notOr, notNor, notXor, notAddi, notAndi, notOri, notXori, notBeq, notBne, notJ, notJr, notLui, notSlt, notLw, notLbu, notSw, notSb, notAddm);
    and row2(row[2], notAdd, subFinal, notAnd, notOr, notNor, notXor, notAddi, notAndi, notOri, notXori, notBeq, notBne, notJ, notJr, notLui, notSlt, notLw, notLbu, notSw, notSb, notAddm);
    and row3(row[3], notAdd, notSub, andFinal, notOr, notNor, notXor, notAddi, notAndi, notOri, notXori, notBeq, notBne, notJ, notJr, notLui, notSlt, notLw, notLbu, notSw, notSb, notAddm);
    and row4(row[4], notAdd, notSub, notAnd, orFinal, notNor, notXor, notAddi, notAndi, notOri, notXori, notBeq, notBne, notJ, notJr, notLui, notSlt, notLw, notLbu, notSw, notSb, notAddm);
    and row5(row[5], notAdd, notSub, notAnd, notOr, norFinal, notXor, notAddi, notAndi, notOri, notXori, notBeq, notBne, notJ, notJr, notLui, notSlt, notLw, notLbu, notSw, notSb, notAddm);
    and row6(row[6], notAdd, notSub, notAnd, notOr, notNor, xorFinal, notAddi, notAndi, notOri, notXori, notBeq, notBne, notJ, notJr, notLui, notSlt, notLw, notLbu, notSw, notSb, notAddm);
    and row7(row[7], notAdd, notSub, notAnd, notOr, notNor, notXor, addiFinal, notAndi, notOri, notXori, notBeq, notBne, notJ, notJr, notLui, notSlt, notLw, notLbu, notSw, notSb, notAddm);
    and row8(row[8], notAdd, notSub, notAnd, notOr, notNor, notXor, notAddi, andiFinal, notOri, notXori, notBeq, notBne, notJ, notJr, notLui, notSlt, notLw, notLbu, notSw, notSb, notAddm);
    and row9(row[9], notAdd, notSub, notAnd, notOr, notNor, notXor, notAddi, notAndi, oriFinal, notXori, notBeq, notBne, notJ, notJr, notLui, notSlt, notLw, notLbu, notSw, notSb, notAddm);
    and row10(row[10], notAdd, notSub, notAnd, notOr, notNor, notXor, notAddi, notAndi, notOri, xoriFinal, notBeq, notBne, notJ, notJr, notLui, notSlt, notLw, notLbu, notSw, notSb, notAddm);
    and row11(row[11], notAdd, notSub, notAnd, notOr, notNor, notXor, notAddi, notAndi, notOri, notXori, beqFinal, notBne, notJ, notJr, notLui, notSlt, notLw, notLbu, notSw, notSb, notAddm);
    and row12(row[12], notAdd, notSub, notAnd, notOr, notNor, notXor, notAddi, notAndi, notOri, notXori, notBeq, bneFinal, notJ, notJr, notLui, notSlt, notLw, notLbu, notSw, notSb, notAddm);
    and row13(row[13], notAdd, notSub, notAnd, notOr, notNor, notXor, notAddi, notAndi, notOri, notXori, notBeq, notBne, jFinal, notJr, notLui, notSlt, notLw, notLbu, notSw, notSb, notAddm);
    and row14(row[14], notAdd, notSub, notAnd, notOr, notNor, notXor, notAddi, notAndi, notOri, notXori, notBeq, notBne, notJ, jrFinal, notLui, notSlt, notLw, notLbu, notSw, notSb, notAddm);
    and row15(row[15], notAdd, notSub, notAnd, notOr, notNor, notXor, notAddi, notAndi, notOri, notXori, notBeq, notBne, notJ, notJr, luiFinal, notSlt, notLw, notLbu, notSw, notSb, notAddm);
    and row16(row[16], notAdd, notSub, notAnd, notOr, notNor, notXor, notAddi, notAndi, notOri, notXori, notBeq, notBne, notJ, notJr, notLui, sltFinal, notLw, notLbu, notSw, notSb, notAddm);
    and row17(row[17], notAdd, notSub, notAnd, notOr, notNor, notXor, notAddi, notAndi, notOri, notXori, notBeq, notBne, notJ, notJr, notLui, notSlt, lwFinal, notLbu, notSw, notSb, notAddm);
    and row18(row[18], notAdd, notSub, notAnd, notOr, notNor, notXor, notAddi, notAndi, notOri, notXori, notBeq, notBne, notJ, notJr, notLui, notSlt, notLw, lbuFinal, notSw, notSb, notAddm);
    and row19(row[19], notAdd, notSub, notAnd, notOr, notNor, notXor, notAddi, notAndi, notOri, notXori, notBeq, notBne, notJ, notJr, notLui, notSlt, notLw, notLbu, swFinal, notSb, notAddm);
    and row20(row[20], notAdd, notSub, notAnd, notOr, notNor, notXor, notAddi, notAndi, notOri, notXori, notBeq, notBne, notJ, notJr, notLui, notSlt, notLw, notLbu, notSw, sbFinal, notAddm);
    and row21(row[21], notAdd, notSub, notAnd, notOr, notNor, notXor, notAddi, notAndi, notOri, notXori, notBeq, notBne, notJ, notJr, notLui, notSlt, notLw, notLbu, notSw, notSb, addmFinal);


    or bigBit(alu_op[2], row[3], row[4], row[5], row[6], row[8], row[9], row[10]);
    or middleBit(alu_op[1], row[1], row[2], row[5], row[6], row[7], row[10], row[11], row[12], row[16], row[17], row[18], row[19], row[20], row[21]);
    or smallBit(alu_op[0], row[2], row[4], row[6], row[9], row[10], row[11], row[12], row[16]);

    or rdSRC(rd_src, addiFinal, andiFinal, oriFinal, xoriFinal, luiFinal, lwFinal, lbuFinal);
    nor writeEnableCheck(writeenable, jFinal, jrFinal, swFinal, sbFinal, addmFinal);
    or aluSRC2(alu_src2, addiFinal, andiFinal, oriFinal, xoriFinal, lwFinal, lbuFinal, swFinal, sbFinal);

    or bigBitControl(control_type[1], row[13], row[14]);
    or smallBitControl(control_type[0], row[11], row[12], row[14]);

    or mem_rdTest(mem_read, lwFinal, lbuFinal, addmFinal);
    assign word_we = swFinal;
    assign byte_we = sbFinal;
    assign byte_load = lbuFinal;
    assign lui = luiFinal;
	  assign slt = sltFinal;
    assign addm = addmFinal;

endmodule // mips_decode

// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// writeenable (output) - should a new value be captured by the register file
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// alu_src2    (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, opcode, funct);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    input  [5:0] opcode, funct;
    wire allZeroes, addFinal, subFinal, andFinal, orFinal, norFinal, xorFinal, legitFunction;
    wire notAddi, notAndi, notOri, notXori, notAdd, notSub, notAnd, notOr, notNor, notXor;
    wire [10:1] row;

    wire addiFinal = opcode == `OP_ADDI;
    wire andiFinal = opcode == `OP_ANDI;
    wire oriFinal = opcode == `OP_ORI;
    wire xoriFinal = opcode == `OP_XORI;

    nor opcodeZeroesTest(allZeroes, opcode[0], opcode[1], opcode[2], opcode[3], opcode[4], opcode[5]);

    wire addTest = funct == `OP0_ADD;
    wire subTest = funct == `OP0_SUB;
    wire andTest = funct == `OP0_AND;
    wire orTest = funct == `OP0_OR;
    wire norTest = funct == `OP0_NOR;
    wire xorTest = funct == `OP0_XOR;

    and addCheck(addFinal, addTest, allZeroes);
    and subCheck(subFinal, subTest, allZeroes);
    and andCheck(andFinal, andTest, allZeroes);
    and orCheck(orFinal, orTest, allZeroes);
    and norCheck(norFinal, norTest, allZeroes);
    and xorCheck(xorFinal, xorTest, allZeroes);

    or legitFunctionCheck(legitFunction, addiFinal, andiFinal, oriFinal, xoriFinal, addFinal, subFinal, andFinal, orFinal, norFinal, xorFinal);

    or rdSRC(rd_src, addiFinal, andiFinal, oriFinal, xoriFinal);
    or aluSRC2(alu_src2, addiFinal, andiFinal, oriFinal, xoriFinal);

    assign writeenable = legitFunction;
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

    and row1(row[1], addFinal, notSub, notAnd, notOr, notNor, notXor, notAddi, notAndi, notOri, notXori);
    and row2(row[2], notAdd, subFinal, notAnd, notOr, notNor, notXor, notAddi, notAndi, notOri, notXori);
    and row3(row[3], notAdd, notSub, andFinal, notOr, notNor, notXor, notAddi, notAndi, notOri, notXori);
    and row4(row[4], notAdd, notSub, notAnd, orFinal, notNor, notXor, notAddi, notAndi, notOri, notXori);
    and row5(row[5], notAdd, notSub, notAnd, notOr, norFinal, notXor, notAddi, notAndi, notOri, notXori);
    and row6(row[6], notAdd, notSub, notAnd, notOr, notNor, xorFinal, notAddi, notAndi, notOri, notXori);
    and row7(row[7], notAdd, notSub, notAnd, notOr, notNor, notXor, addiFinal, notAndi, notOri, notXori);
    and row8(row[8], notAdd, notSub, notAnd, notOr, notNor, notXor, notAddi, andiFinal, notOri, notXori);
    and row9(row[9], notAdd, notSub, notAnd, notOr, notNor, notXor, notAddi, notAndi, oriFinal, notXori);
    and row10(row[10], notAdd, notSub, notAnd, notOr, notNor, notXor, notAddi, notAndi, notOri, xoriFinal);

    or bigBit(alu_op[2], row[3], row[4], row[5], row[6], row[8], row[9], row[10]);
    or middleBit(alu_op[1], row[1], row[2], row[5], row[6], row[7], row[10]);
    or smallBit(alu_op[0], row[2], row[4], row[6], row[9], row[10]);

endmodule // mips_decode

// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;
    wire [31:0] PC;
    wire [31:0] nextPC;
    wire [31:0] out;
    wire [31:0] imm32;
    wire [31:0] B;
    wire [31:0] inALUBottom;
    wire [31:0] rtData;
    wire [31:0] rsData;
    wire [4:0] rDest;
    wire [2:0] inALUControl;
    wire [2:0] alu_op;
    wire wr_enable, rd_src, alu_src2, enable;

    assign enable = 1;

    register #(32) PC_reg(PC, nextPC, clock, enable, reset);

    instruction_memory im(inst, PC[31:2]);

    mux2v rdNum(rDest, inst[15:11], inst[20:16], rd_src);

    regfile rf (rsData, rtData, inst[25:21], inst[20:16], rDest, out, wr_enable, clock, reset);

    alu32 outALU(out, , , , rsData, B, alu_op);

    mips_decode decoder(alu_op, wr_enable, rd_src, alu_src2, except, inst[31:26], inst[5:0]);

    signextender signextender(imm32, inst[15:0]);

    mux2v rtDataCheck(B, rtData, imm32, alu_src2);

    assign inALUBottom[31] = 0;
    assign inALUBottom[30] = 0;
    assign inALUBottom[29] = 0;
    assign inALUBottom[28] = 0;
    assign inALUBottom[27] = 0;
    assign inALUBottom[26] = 0;
    assign inALUBottom[25] = 0;
    assign inALUBottom[24] = 0;
    assign inALUBottom[23] = 0;
    assign inALUBottom[22] = 0;
    assign inALUBottom[21] = 0;
    assign inALUBottom[20] = 0;
    assign inALUBottom[19] = 0;
    assign inALUBottom[18] = 0;
    assign inALUBottom[17] = 0;
    assign inALUBottom[16] = 0;
    assign inALUBottom[15] = 0;
    assign inALUBottom[14] = 0;
    assign inALUBottom[13] = 0;
    assign inALUBottom[12] = 0;
    assign inALUBottom[11] = 0;
    assign inALUBottom[10] = 0;
    assign inALUBottom[9] = 0;
    assign inALUBottom[8] = 0;
    assign inALUBottom[7] = 0;
    assign inALUBottom[6] = 0;
    assign inALUBottom[5] = 0;
    assign inALUBottom[4] = 0;
    assign inALUBottom[3] = 0;
    assign inALUBottom[2] = 1;
    assign inALUBottom[1] = 0;
    assign inALUBottom[0] = 0;

    assign inALUControl[2] = 0;
    assign inALUControl[1] = 1;
    assign inALUControl[0] = 0;

    alu32 inALU(nextPC, , , , PC, inALUBottom, inALUControl);

endmodule // arith_machine

module signextender(out, in);
    output [31:0] out;
    input  [15:0] in;

    assign out[31:16] = {16{in[15]}};
    assign out[15:0] = in;

endmodule // signextender

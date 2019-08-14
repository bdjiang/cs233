// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;
    wire [31:0] PC;
    wire [31:0] nextPC;
    wire [31:0] out;
    wire [31:0] imm32;
    wire [31:0] B;
    wire [31:0] numberFour;
    wire [31:0] nextInstructionNoOffset;
    wire [31:0] rtData;
    wire [31:0] rsData;
    wire [31:0] rdData;
    wire [31:0] control2;
    wire [31:0] branchOffset;
    wire [31:0] sltNegative;
    wire [31:0] memReadChoice0;
    wire [31:0] memReadChoice1;
    wire [31:0] byteLoadOut;
    wire [31:0] addmCheck;
    wire [7:0] byteNotExtended;
    wire [31:0] byteExtended;
    wire [31:0] luiChoice0;
    wire [31:0] luiChoice1;
    wire [31:0] dataMemAddr;
    wire [31:0] nextInstructionOffset;
    wire [31:0] data_out;
    wire [4:0] rDest;
    wire [2:0] addCommand;
    wire [2:0] alu_op;
    wire [1:0] control_type;
    wire wr_enable, rd_src, alu_src2, enable, zero, negative, lui, slt, word_we, byte_we, addm, byte_load, mem_read;

    assign enable = 1;

    register #(32) PC_reg(PC, nextPC, clock, enable, reset);

    alu32 nextInstructionALU(nextInstructionNoOffset, , , , PC, numberFour, addCommand);

    alu32 offsetALU(nextInstructionOffset, , , , nextInstructionNoOffset, branchOffset, addCommand);

    assign control2[31:28] = PC[31:28];
    assign control2[27:2] = inst[25:0];
    assign control2[1:0] = 2'b00;

    mux4v controlMux(nextPC, nextInstructionNoOffset, nextInstructionOffset , control2, rsData, control_type);

    instruction_memory im(inst, PC[31:2]);

    mux2v rdNum(rDest, inst[15:11], inst[20:16], rd_src);

    regfile rf (rsData, rtData, inst[25:21], inst[20:16], rDest, rdData, wr_enable, clock, reset);

    signextender signextender(imm32, inst[15:0]);

    shiftleft2 shiftleft2(branchOffset, imm32[29:0]);

    mux2v aluSRC2(B, rtData, imm32, alu_src2);

    alu32 mainALU(out, , zero, negative, rsData, B, alu_op);

    assign sltNegative[30:0] = 31'b0;
    assign sltNegative[31] = negative;

    mux2v sltMux(memReadChoice0, out, sltNegative, slt);

    data_mem dataMemory(data_out, dataMemAddr, rtData, word_we, byte_we, clock, reset);

    mux2v addmMux2(dataMemAddr, out, rsData, addm);

    mux4v dataMemMux(byteNotExtended, data_out[7:0], data_out[15:8], data_out[23:16], data_out[31:24], out[1:0]);

    assign byteExtended[31:24] = byteNotExtended;
    assign byteExtended[23:0] = 24'b0;

    mux2v byteLoadMux(byteLoadOut, data_out, byteExtended, byte_load);

    alu32 addmALU(addmCheck, , , , byteLoadOut, B, addCommand);

    mux2v addmMux(memReadChoice1, byteLoadOut, addmCheck, addm);

    mux2v memReadMux(luiChoice0, memReadChoice0, memReadChoice1, mem_read);

    mux2v luiMux(rdData, luiChoice1, luiChoice0, lui);

    assign luiChoice1[31:16] = inst[15:0];
    assign luiChoice1[15:0] = 16'b0;

    mips_decode decoder(alu_op, wr_enable, rd_src, alu_src2, except, control_type,
                       mem_read, word_we, byte_we, byte_load, lui, slt, addm,
                       inst[31:26], inst[5:0], zero);


    assign numberFour[31:0] = 32'b00000000000000000000000000000100;

    assign addCommand[2] = 0;
    assign addCommand[1] = 1;
    assign addCommand[0] = 0;


endmodule // full_machine

module signextender(out, in);
    output [31:0] out;
    input  [15:0] in;

    assign out[31:16] = {16{in[15]}};
    assign out[15:0] = in;

endmodule // signextender

module shiftleft2(out, in);
  output [31:0] out;
  input [29:0] in;

  assign out[31:2] = in[29:0];
  assign out[1:0] = 2'b00;

endmodule // shiftleft2

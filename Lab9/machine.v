module machine(clk, reset);
   input        clk, reset;

   wire [31:0]  PC;
   wire [31:2]  next_PC, PC_plus4, PC_target;
   wire [31:0]  inst;

   wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
   wire [4:0]   rs = inst[25:21];
   wire [4:0]   rt = inst[20:16];
   wire [4:0]   rd = inst[15:11];

   wire [4:0]   wr_regnum;
   wire [2:0]   ALUOp;

   wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, MFC0, MTC0, ERET;
   wire         PCSrc, zero, negative;
   wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;

   wire [31:0] topLeftMux1Out, realNextPC, wr_dataReal, c0read_data;
   wire [31:0] interruptHandlerAddress;
   wire [29:0] EPC;
   wire TakenInterrupt;

   wire TimerInterrupt, TimerAddress, notIO;
   wire [31:0] cycle;
   wire realMemRead, realMemWrite;

   register #(30, 30'h100000) PC_reg(PC[31:2], realNextPC[31:2], clk, /* enable */1'b1, reset);
   assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
   adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
   adder30 target_PC_adder(PC_target, PC_plus4, imm[29:0]);
   mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
   assign PCSrc = BEQ & zero;

   instruction_memory imem (inst, PC[31:2]);

   mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, MFC0, MTC0, ERET,
                      inst);

   regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum, wr_dataReal,
               RegWrite, clk, reset);

   mux2v #(32) imm_mux(B_data, rd2_data, imm, ALUSrc);
   alu32 alu(alu_out_data, zero, negative, ALUOp, rd1_data, B_data);

   data_mem data_memory(load_data, alu_out_data, rd2_data, realMemRead, realMemWrite, clk, reset);

   mux2v #(32) wb_mux(wr_data, alu_out_data, load_data, MemToReg);
   mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);

   mux2v topLeft1(topLeftMux1Out, next_PC, EPC, ERET);
   assign interruptHandlerAddress = 32'b10000000000000000000000110000000;
   mux2v topLeft2(realNextPC, topLeftMux1Out, interruptHandlerAddress, TakenInterrupt);

   cp0 coproc0(c0read_data, EPC, TakenInterrupt, wr_regnum, rd2_data, next_PC, TimerInterrupt, MTC0, ERET, clk, reset);
   timer tim(TimerInterrupt, TimerAddress, cycle, alu_out_data, rd2_data, MemRead, MemWrite, clk, reset);

   mux2v mfc0Mux(wr_dataReal, wr_data, c0read_data, MFC0);

   not ioDo(notIO, TimerAddress);

   and memReadCheck(realMemRead, MemRead, notIO);
   and memWriteCheck(realMemWrite, MemWrite, notIO);

endmodule // machine

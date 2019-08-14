module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4, PC_target;
    wire [31:0]  inst;

    wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
    wire [4:0]   rs = inst[25:21];
    wire [4:0]   rt = inst[20:16];
    wire [4:0]   rd = inst[15:11];
    wire [5:0]   opcode = inst[31:26];
    wire [5:0]   funct = inst[5:0];

    wire [4:0]   wr_regnum;
    wire [2:0]   ALUOp;

    wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
    wire         PCSrc, zero;
    wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;

    wire [31:2] PC_plus4_pipeline;
    wire [31:0] imm_pipeline, rd1_data_pipeline, rd2_data_pipeline, wr_data_forward, data1, data2;
    wire [5:0]  opcode_pipeline, funct_pipeline;
    wire [4:0]  rs_pipeline, rt_pipeline, rd_pipeline, wr_regnum_forward;
    wire        RegWrite_forward, A_forward, B_forward, flush;


    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, /* enable */1'b1, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00

    register #(5) rtPipeline(rt_pipeline, rt, clk, 1, flush);
    register #(5) rdPipeline(rd_pipeline, rd, clk, 1, flush);
    register #(5) rsPipeline(rs_pipeline, rs, clk, 1, flush);

    adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
    adder30 target_PC_adder(PC_target, PC_plus4_pipeline, imm_pipeline[29:0]);
    mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    register #(30) PCPipeline(PC_plus4_pipeline, PC_plus4, clk, 1, flush);

    instruction_memory imem(inst, PC[31:2]);

    register #(6) opcodePipeline(opcode_pipeline, opcode, clk, 1, flush);
    register #(6) functPipeline(funct_pipeline, funct, clk, 1, flush);

    mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst,
                      opcode_pipeline, funct_pipeline);

    regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum, wr_data,
               RegWrite, clk, reset);

    mux2v #(32) imm_mux(B_data, data2, imm_pipeline, ALUSrc);
    alu32 alu(alu_out_data, zero, ALUOp, data1, B_data);

    data_mem data_memory(load_data, alu_out_data, data2, MemRead, MemWrite, clk, reset);

    register #(32) rdData1Pipeline(rd1_data_pipeline, rd1_data, clk, 1, flush);
    register #(32) rdData2Pipeline(rd2_data_pipeline, rd2_data, clk, 1, flush);
    register #(32) immPipeline(imm_pipeline, imm, clk, 1, flush);

    mux2v #(32) wb_mux(wr_data, alu_out_data, load_data, MemToReg);
    mux2v #(5) rd_mux(wr_regnum, rt_pipeline, rd, RegDst);

    assign flush = PCSrc || reset;

    register #(32) wr_dataForward(wr_data_forward, wr_data, clk, 1, reset);
    register #(5) wr_regnumForward(wr_regnum_forward, wr_regnum, clk, 1, reset);
    register #(1) RegWriteForward(RegWrite_forward, RegWrite, clk, 1, reset);

    mux2v #(32) AForward(data1, rd1_data_pipeline, wr_data_forward, A_forward);
    mux2v #(32) BForward(data2, rd2_data_pipeline, wr_data_forward, B_forward);

    wire part1 = rs_pipeline == wr_regnum_forward;
    wire part2 = rt_pipeline == wr_regnum_forward;

    assign A_forward = part1 && RegWrite_forward;
    assign B_forward = part2 && RegWrite_forward;

endmodule // pipelined_machine

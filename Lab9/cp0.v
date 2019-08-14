`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           regnum, wr_data, next_pc, TimerInterrupt,
           MTC0, ERET, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input   [4:0] regnum;
    input  [31:0] wr_data;
    input  [29:0] next_pc;
    input         TimerInterrupt, MTC0, ERET, clock, reset;

    wire [31:0] user_status, decoder_out, cause_register, status_register;
    wire [29:0] epc_register_in, epc_register_out;
    wire exception_level, exception_level_reset, epc_register_enable, TakenInterruptWire;

    wire [31:0] epc_register_out_rdData;
    wire cause_and_status, not_status_one, status_status;

    register userStatus(user_status, wr_data, clock, decoder_out[12], reset);
    register exceptionLevel(exception_level, 1, clock, TakenInterruptWire, exception_level_reset);
    register epcRegister(epc_register_out, epc_register_in, clock, epc_register_enable, reset);

    decoder32 mtc0Decoder(decoder_out, regnum, MTC0);
    or exceptionLevelReset(exception_level_reset, reset, ERET);

    mux2v epcRegIn(epc_register_in, wr_data[31:2], next_pc, TakenInterruptWire);
    or epcRegEnable(epc_register_enable, decoder_out[14], TakenInterruptWire);

    assign TakenInterrupt = TakenInterruptWire;

    assign cause_register[31:16] = 16'b0;
    assign cause_register[15] = TimerInterrupt;
    assign cause_register[14:0] = 15'b0;

    assign status_register[31:16] = 16'b0;
    assign status_register[15:8] = user_status[15:8];
    assign status_register[7:2] = 6'b0;
    assign status_register[1] = exception_level;
    assign status_register[0] = user_status[0];



    and causeAndStatus(cause_and_status, cause_register[15], status_register[15]);
    not notStatusOne(not_status_one, status_register[1]);
    and andStatusStatus(status_status, not_status_one, status_register[0]);
    and takenInter(TakenInterrupt, cause_and_status, status_status);

    mux32v rdData(rd_data,,,,,,,,,,,,status_register, cause_register, epc_register_out_rdData,,,,,,,,,,,,,,,,,,, regnum);

    assign epc_register_out_rdData[31:2] = epc_register_out;
    assign epc_register_out_rdData[1:0] = 2'b0;

    assign EPC = epc_register_out;
endmodule

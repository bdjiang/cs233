module timer(TimerInterrupt, TimerAddress, cycle,
             address, data, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt, TimerAddress;
    output [31:0] cycle;
    input  [31:0] address, data;
    input         MemRead, MemWrite, clock, reset;

	wire timerWrite, timerRead, Acknowledge;
	wire [31:0] equalCheck1, equalCheck2;

	wire [31:0] cycleCounterOut, interruptCycleOut, aluOut;
	wire interruptLineReset;
	wire [2:0] add;

  wire cycles = equalCheck1 == address;
	wire acknowledgeWire = equalCheck2 == address;

  	wire interruptLineEnable = cycleCounterOut == interruptCycleOut;

    // complete the timer circuit here

    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle

	and timerWriteCheck(timerWrite, MemWrite, cycles);
	and timerReadCheck(timerRead, MemRead, cycles);

	assign equalCheck1 = 32'hffff001c;
	assign equalCheck2 = 32'hffff006c;



	and acknowledgeCheck(Acknowledge, acknowledgeWire, MemWrite);
	or timerAddressCheck(TimerAddress, cycles, acknowledgeWire);


	register cycleCounter(cycleCounterOut, aluOut, clock, 1, reset);
	register interruptCycle(interruptCycleOut, data, clock, timerWrite, reset);
	register interruptLine(TimerInterrupt, 1, clock, interruptLineEnable, interruptLineReset);


	or interruptLineResetCheck(interruptLineReset, Acknowledge, reset);

	assign add = 3'h0;

	alu32 cycleCounterALU(aluOut,,, add, cycleCounterOut, 1);

	tristate cycleOut(cycle, cycleCounterOut, timerRead);

endmodule

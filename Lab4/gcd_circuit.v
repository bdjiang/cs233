// GCD datapath
module gcd_circuit(out, x_lt_y, x_ne_y, X, Y, x_sel, y_sel, x_en, y_en, output_en, clock, reset);
	output  [31:0] out;
	output  x_lt_y, x_ne_y;
	input	[31:0]	X, Y;
	input   x_sel, y_sel, x_en, y_en, output_en, clock, reset;
	wire 	[31:0] xMuxtoReg, yMuxtoReg, xRegOut, yRegOut, subLoop1, subLoop2;

    mux2v xMux(xMuxtoReg, X, subLoop1, x_sel);
	mux2v yMux(yMuxtoReg, Y, subLoop2, x_sel);

	register tmpX(xRegOut, xMuxtoReg, clock, x_en, reset);
	register tmpY(yRegOut, yMuxtoReg, clock, y_en, reset);

	subtractor sub1(subLoop1, xRegOut, yRegOut);
	subtractor sub2(subLoop2, yRegOut, xRegOut);

	comparator comp(x_lt_y, x_ne_y, xRegOut, yRegOut);

	register outReg(out, xRegOut, clock, output_en, reset);

endmodule // gcd_circuit

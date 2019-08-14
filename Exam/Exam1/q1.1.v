// A decoder is a device which does the reverse operation of an encoder,
// converting an n-bit encoded signal into a 2^n-bit one-hot encoded
// signal.  One-hot encoding is where only a single bit in a bus is set
// to 1.

// Specifically, bit m of the output should be set to 1 if the input
// bits encode the binary representation of the number m.

// if the enable input is 0, then all outputs should be zero.

module decoder4e(out, in, enable);
    output [3:0] out;
    input  [1:0] in;
    input        enable;
	wire 		 out0Wire, out1Wire, out2Wire, out3Wire, w1, w2, wi, wii;

	nor o1(out0Wire, in[0], in[1]);
	and a3(out3Wire, in[0], in[1]);

	xor x1(w1, in[0], in[1]);
	xor x2(w2, in[0], in[1]);

	assign out1Wire = !w1 & 0010;
	assign out2Wire = !w2 & 0100;


	and test0(out[0], enable, out0Wire);
	and test1(out[1], enable, out1Wire);
	and test2(out[2], enable, out2Wire);
	and test3(out[3], enable, out3Wire);
   
endmodule // decoder4e


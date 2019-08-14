module alu32(out, overflow, zero, negative, A, B, control);
    output [31:0] out;
    output        overflow, zero, negative;
    input  [31:0] A, B;
    input   [2:0] control;
	wire 		  carry0, carry1, carry2, carry3, carry4, carry5, carry6, carry7, carry8, carry9, carry10, carry11, carry12, carry13, carry14, carry15, carry16, carry17, carry18, carry19, carry20, carry21, carry22, carry23, carry24, carry25, carry26, carry27, carry28, carry29, carry30;

	alu1 alu0(out[0], carry0, A[0], B[0], control[0], control[2:0]);
	alu1 alu1(out[1], carry1, A[1], B[1], carry0, control[2:0]);
    alu1 alu2(out[2], carry2, A[2], B[2], carry1, control[2:0]);
    alu1 alu3(out[3], carry3, A[3], B[3], carry2, control[2:0]);
    alu1 alu4(out[4], carry4, A[4], B[4], carry3, control[2:0]);
    alu1 alu5(out[5], carry5, A[5], B[5], carry4, control[2:0]);
    alu1 alu6(out[6], carry6, A[6], B[6], carry5, control[2:0]);
    alu1 alu7(out[7], carry7, A[7], B[7], carry6, control[2:0]);
    alu1 alu8(out[8], carry8, A[8], B[8], carry7, control[2:0]);
    alu1 alu9(out[9], carry9, A[9], B[9], carry8, control[2:0]);
    alu1 alu10(out[10], carry10, A[10], B[10], carry9, control[2:0]);
    alu1 alu11(out[11], carry11, A[11], B[11], carry10, control[2:0]);
    alu1 alu12(out[12], carry12, A[12], B[12], carry11, control[2:0]);
    alu1 alu13(out[13], carry13, A[13], B[13], carry12, control[2:0]);
    alu1 alu14(out[14], carry14, A[14], B[14], carry13, control[2:0]);
    alu1 alu15(out[15], carry15, A[15], B[15], carry14, control[2:0]);
    alu1 alu16(out[16], carry16, A[16], B[16], carry15, control[2:0]);
    alu1 alu17(out[17], carry17, A[17], B[17], carry16, control[2:0]);
    alu1 alu18(out[18], carry18, A[18], B[18], carry17, control[2:0]);
    alu1 alu19(out[19], carry19, A[19], B[19], carry18, control[2:0]);
    alu1 alu20(out[20], carry20, A[20], B[20], carry19, control[2:0]);
    alu1 alu21(out[21], carry21, A[21], B[21], carry20, control[2:0]);
    alu1 alu22(out[22], carry22, A[22], B[22], carry21, control[2:0]);
    alu1 alu23(out[23], carry23, A[23], B[23], carry22, control[2:0]);
    alu1 alu24(out[24], carry24, A[24], B[24], carry23, control[2:0]);
    alu1 alu25(out[25], carry25, A[25], B[25], carry24, control[2:0]);
    alu1 alu26(out[26], carry26, A[26], B[26], carry25, control[2:0]);
    alu1 alu27(out[27], carry27, A[27], B[27], carry26, control[2:0]);
    alu1 alu28(out[28], carry28, A[28], B[28], carry27, control[2:0]);
    alu1 alu29(out[29], carry29, A[29], B[29], carry28, control[2:0]);
    alu1 alu30(out[30], carry30, A[30], B[30], carry29, control[2:0]);
	alu1 alu31(out[31], carryOut, A[31], B[31], carry30, control[2:0]);

	assign negative = out[31];
	nor zeroCheck(zero, out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7], out[8], out[9], out[10], out[11], out[12], out[13], out[14], out[15], out[16], out[17], out[18], out[19], out[20], out[21], out[22], out[23], out[24], out[25], out[26], out[27], out[28], out[29], out[30], out[31]);
	xor overflowCheck(overflow, carry30, carryOut);

endmodule // alu32

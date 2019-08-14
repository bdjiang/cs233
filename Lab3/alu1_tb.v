module alu1_test;
    reg A, B, carryin;
     
    reg [2:0] control;

    initial begin

        $dumpfile("alu1.vcd");
        $dumpvars(0, alu1_test);

		control[1] = 1;
		control[2] = 0;
		carryin = 0;

		control[0] = 0;
        //tests for addition
        A = 0; B = 0; #10;
		A = 1; B = 0; #10;
		A = 0; B = 1; #10;
		A = 1; B = 1; #10;

		control[0] = 1;
		//tests for subtraction
		A = 0; B = 0; #10;
		A = 1; B = 0; #10;
		A = 0; B = 1; #10;
		A = 1; B = 1; #10;

		control [2] = 1; control [0] = 0; control[1] = 0;
		//tests for and
		A = 0; B = 0; #10;
		A = 1; B = 0; #10;
		A = 0; B = 1; #10;
		A = 1; B = 1; #10;

		control[0] = 1;
		//tests for or
		A = 0; B = 0; #10;
		A = 1; B = 0; #10;
		A = 0; B = 1; #10;
		A = 1; B = 1; #10;

		control[0] = 0; control [1] = 1;
		//tests for nor
		A = 0; B = 0; #10;
		A = 1; B = 0; #10;
		A = 0; B = 1; #10;
		A = 1; B = 1; #10;

		control [0] = 1;
		//test for xor
		A = 0; B = 0; #10;
		A = 1; B = 0; #10;
		A = 0; B = 1; #10;
		A = 1; B = 1; #10;

		$finish;
    end

	wire out, carryout;

	alu1 alu(out, carryout, A, B, carryin, control);

	initial begin
        $display("A B c o cout cin");
        $monitor("%d %d %d %d %d    %d   (at time %t)", A, B, control, out, carryout, carryin, $time);
    end

endmodule

module logicunit_test;

    reg A, B;
     
    reg [1:0] control;

    initial begin

        $dumpfile("logicunit.vcd");
        $dumpvars(0, logicunit_test);

		//tests in order of AND, NOR, OR, XOR
        //tests for A and B = 0
        A = 0; B = 0; control[0] = 0; control[1] = 0; #10;
		A = 0; B = 0; control[0] = 0; control[1] = 1; #10;
		A = 0; B = 0; control[0] = 1; control[1] = 0; #10;
		A = 0; B = 0; control[0] = 1; control[1] = 1; #10;
		//tests for A and B = 1
		A = 1; B = 1; control[0] = 0; control[1] = 0; #10;
		A = 1; B = 1; control[0] = 0; control[1] = 1; #10;
		A = 1; B = 1; control[0] = 1; control[1] = 0; #10;
		A = 1; B = 1; control[0] = 1; control[1] = 1; #10;
		//tests for A = 1, B = 0
		A = 1; B = 0; control[0] = 0; control[1] = 0; #10;
		A = 1; B = 0; control[0] = 0; control[1] = 1; #10;
		A = 1; B = 0; control[0] = 1; control[1] = 0; #10;
		A = 1; B = 0; control[0] = 1; control[1] = 1; #10;
		//tests for A = 0, B = 1
		A = 0; B = 1; control[0] = 0; control[1] = 0; #10;
		A = 0; B = 1; control[0] = 0; control[1] = 1; #10;
		A = 0; B = 1; control[0] = 1; control[1] = 0; #10;
		A = 0; B = 1; control[0] = 1; control[1] = 1; #10;

		$finish;
    end

	wire out;
	
	logicunit lu(out, A, B, control);

	initial begin
        $display("A B c o");
        $monitor("%d %d %d %d (at time %t)", A, B, control, out, $time);
    end
	

    
endmodule // logicunit_test

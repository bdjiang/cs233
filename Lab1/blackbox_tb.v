module blackbox_test;

	reg f, x, e;
	
	wire n;

	blackbox bb (n, f, x ,e);

	initial begin

		$dumpfile("blackbox.vcd");
		$dumpvars(0, blackbox_test);

		f = 0; x = 0; e = 0; #10;
		f = 0; x = 0; e = 1; #10;
		f = 0; x = 1; e = 1; #10;
		f = 1; x = 1; e = 1; #10;
		f = 1; x = 1; e = 0; #10;
		f = 1; x = 0; e = 0; #10;
		f = 1; x = 0; e = 1; #10;
		f = 0; x = 1; e = 0; #10;

		$finish;
	end

	initial
		$monitor("At time %2t, f = %d x = %d e = %d n = %d"
, $time, f, x, e, n);
endmodule // blackbox_test

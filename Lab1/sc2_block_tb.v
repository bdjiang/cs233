module sc2_test;

	reg a, b, cin;
	
	wire s, cout;

	sc2_block sc2 (s, cout, a, b, cin);

	initial begin

		$dumpfile("sc.vcd");
		$dumpvars(0, sc2_test);

		a = 0; b = 0; cin = 0; #10;
		a = 0; b = 0; cin = 1; #10;
		a = 0; b = 1; cin = 1; #10;
		a = 1; b = 1; cin = 1; #10;
		a = 1; b = 1; cin = 0; #10;
		a = 1; b = 0; cin = 0; #10;
		a = 1; b = 0; cin = 1; #10;
		a = 0; b = 1; cin = 0; #10;

		$finish;
	end
	
	initial
		$monitor("At time %2t, a = %d b = %d cin = %d s = %d cout = %d"
, $time, a, b, cin, s, cout);

endmodule // sc2_test

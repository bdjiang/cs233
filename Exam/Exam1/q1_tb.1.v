module test;

   // these are inputs to "circuit under test"
   reg [1:0] in;
   reg       enable;
  // wires for the outputs of "circuit under test"
   wire [3:0] out;
  // the circuit under test
   decoder4e d(out, in, enable);  
    
   initial begin               // initial = run at beginning of simulation
                               // begin/end = associate block with initial
      
      $dumpfile("test.vcd");  // name of dump file to create
      $dumpvars(0, test);     // record all signals of module "test" and sub-modules
                              // remember to change "test" to the correct
                              // module name when writing your own test benches
        
      // test all input combinations
      in = 0; enable = 0; #10;
      in = 0; enable = 1; #10;
      in = 1; enable = 0; #10;
      in = 1; enable = 1; #10;
      in = 2; enable = 0; #10;
      in = 2; enable = 1; #10;
      in = 3; enable = 0; #10;
      in = 3; enable = 1; #10;
      
      $finish;        // end the simulation
   end                      
   
   initial begin
     $display("inputs = in, enable  outputs = out");
     $monitor("inputs = %b  %b  outputs = %b   time = %2t",
              in, enable, out, $time);
   end
endmodule // test

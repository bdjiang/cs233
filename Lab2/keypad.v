module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output [3:0] number;
   input 	a, b, c, d, e, f, g;
   wire   w1, w2, w3, w4, w5, w6, w7, w8, w9, w10;
   
   
   //stuff for determining valid
   or masterValidOr(valid, b, d, e, f, w1, w2);
   and gAndA(w1, a, g);
   and gAndC(w2, c, g);


   //stuff for determining number
   
   
   or bOrC(w3, b, c);
   and number3(number[3], w3, f);

   and aAndF(w4, a, f);
   or number2(number[2], w4, e);

   and cAndD(w5, c, d);
   and cAndE(w6, c, e);
   and bAndD(w7, b, d);
   or number1(number[1], w4, w5, w6, w7);

   and aAndD(w8, a, d);
   and bAndE(w9, b, e);
   and cAndF(w10, c, f);
   or number0(number[0], w4, w5, w8, w9, w10);


endmodule // keypad

## struct Shifter {
##     unsigned int value;
##     unsigned int *to_rotate[4];
## };
## 
## 
## void
## shift_many(Shifter *s, int offset) {
##     for (int i = 0; i < 4; i++) {
##         unsigned int *ptr = s->to_rotate[i];
## 
##         if (ptr == NULL) {
##             continue;
##         }
## 
##         unsigned char x = (i + offset) & 3;
##         *ptr = circular_shift(s->value, x);
##     }
## }

shift_many:
	# Your code goes here :)
	jr $ra

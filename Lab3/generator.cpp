// a code generator for the ALU chain in the 32-bit ALU
// see example_generator.cpp for inspiration

// make generator
// ./generator

#include <cstdio>
using std::printf;

int main() {
	int width = 31;
	for (int i = 0; i < width; i++) {
		printf("carry%d, ", i);
	}	
	
	for (int i = 1; i < width; i++) {
		printf("    alu1 alu%d(out[%d], carry%d, A[%d], B[%d], carry%d, control[2:0]);\n", i, i, i, i, i, i - 1);
	}
	
	for (int i = 0; i <= width; i++) {
		printf("out[%d], ", i);
	}
	
}

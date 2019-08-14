/**
 * @file
 * Contains the implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
   // length must be a multiple of 8
   assert((length % 8) == 0);

   // allocate an array for the output
   char *message_out = new char[length];
   
   	int blocks = length/8;
	int currentBlock;
	
	for (currentBlock = 0; currentBlock < blocks; currentBlock++) {
		
		int characterIndex = currentBlock * 8;
		for (int bitIndex = 0; bitIndex < 8; bitIndex++) {
		unsigned byte = 00000000;
			int charCounter;
			for (charCounter = 0; charCounter < 8; charCounter++) {
				char currentChar = *(message_in + characterIndex + charCounter);
				unsigned currentBit = (currentChar >> bitIndex) & 1;
				unsigned currentBitFix = currentBit << charCounter;
				byte += currentBitFix;
			}
			
			*(message_out + characterIndex + bitIndex) = byte;
		
		}
	}
	


	return message_out;
}

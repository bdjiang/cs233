/**
 * @file
 * Contains the implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	unsigned rightCounters = input & 0x55555555;
	unsigned leftCounters = input & 0xAAAAAAAA;
	
	unsigned algStepOne = (leftCounters >> 1) + rightCounters;
	
	
	unsigned newRightCounters = algStepOne & 0x33333333;
	unsigned newLeftCounters = algStepOne & 0xCCCCCCCC;
	
	unsigned algStepTwo = (newLeftCounters >> 2) + newRightCounters;
	
	
	unsigned lastRightCounters = algStepTwo & 0x0F0F0F0F;
	unsigned lastLeftCounters = algStepTwo & 0xF0F0F0F0;
	
	unsigned algStepThree = (lastLeftCounters >> 4) + lastRightCounters;
	
	input = algStepThree;

	

	return input;
}

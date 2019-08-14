#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  int offsetBits = cache_config.get_num_block_offset_bits();
  int indexBits = cache_config.get_num_index_bits();
  int tagBits = cache_config.get_num_tag_bits();

  if(tagBits >= 32) {
    return address;
  }
  
  return (address >> (offsetBits + indexBits));
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  unsigned mask = 0xffffffff;
	int tagBits = cache_config.get_num_tag_bits();
	int offsetBits = cache_config.get_num_block_offset_bits();

	mask = (((mask << (tagBits - 1)) << 1) >> (tagBits - 1)) >> 1;

	return (address & ((mask >> offsetBits) << offsetBits)) >> offsetBits;
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  int mask = 0x80000000;
  int offsetBits = cache_config.get_num_block_offset_bits();

	int shiftValue = 32 - offsetBits - 1;

	mask = ~(mask >> shiftValue);
	return address & mask;
}

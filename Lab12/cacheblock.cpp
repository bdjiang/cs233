#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {

  int offsetBits = _cache_config.get_num_block_offset_bits();
  int indexBits = _cache_config.get_num_index_bits();

  uint32_t tag = get_tag();

  return ((tag << indexBits) + _index) << offsetBits;
}

#include "cachesimulator.h"

Cache::Block* CacheSimulator::find_block(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    possibly have `address` cached.
   * 2. Loop through all these blocks to see if any one of them actually has
   *    `address` cached (i.e. the block is valid and the tags match).
   * 3. If you find the block, increment `_hits` and return a pointer to the
   *    block. Otherwise, return NULL.
   */
  vector<Cache::Block*> blocksInSet = _cache->get_blocks_in_set(extract_index(address, _cache -> get_config()));
  for (int i = 0; i < blocksInSet.size(); i++) {
		if (blocksInSet[i] -> is_valid()) {
      if (blocksInSet[i] -> get_tag() == extract_tag(address, _cache -> get_config())) {
  			_hits++;
  			return blocksInSet[i];
      }
		}
	}
  return NULL;
}

Cache::Block* CacheSimulator::bring_block_into_cache(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    cache `address`.
   * 2. Loop through all these blocks to find an invalid `block`. If found,
   *    skip to step 4.
   * 3. Loop through all these blocks to find the least recently used `block`.
   *    If the block is dirty, write it back to memory.
   * 4. Update the `block`'s tag. Read data into it from memory. Mark it as
   *    valid. Mark it as clean. Return a pointer to the `block`.
   */
  vector<Cache::Block*> blocksInSet = _cache -> get_blocks_in_set(extract_index(address, _cache -> get_config()));
  uint32_t tag = extract_tag(address, _cache -> get_config());
  for (int i = 0; i < blocksInSet.size(); i++) {
    if (!blocksInSet[i] -> is_valid()) {
      blocksInSet[i] -> set_tag(tag);
      blocksInSet[i] -> read_data_from_memory(_memory);
      blocksInSet[i] -> mark_as_valid();
      blocksInSet[i] -> mark_as_clean();
      return blocksInSet[i];
    }
  }

  Cache::Block* LRU = blocksInSet[0];
  for (int i = 1; i < blocksInSet.size(); i++) {
    if (blocksInSet[i] -> get_last_used_time() < LRU -> get_last_used_time()) {
			LRU = blocksInSet[i];
    }
  }
  LRU -> set_tag(tag);
  LRU -> read_data_from_memory(_memory);
  LRU -> mark_as_valid();
  LRU -> mark_as_clean();
  return LRU;
}

uint32_t CacheSimulator::read_access(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found, use `bring_block_into_cache` cache `address` in `block`.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `read_word_at_offset` to return the data at `address`.
   */
  Cache::Block* block = find_block(address);
 	if (block == NULL) {
 		block = bring_block_into_cache(address);
 	} else {
    block -> set_last_used_time(_use_clock.get_count());
  }
  _use_clock++;
 	return block -> read_word_at_offset(extract_block_offset(address, _cache -> get_config()));
}

void CacheSimulator::write_access(uint32_t address, uint32_t word) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found
   *    a. If the policy is write allocate, use `bring_block_into_cache`.
   *    a. Otherwise, directly write the `word` to `address` in the memory
   *       using `_memory->write_word` and return.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `write_word_at_offset` to to write `word` to `address`.
   * 5. a. If the policy is write back, mark `block` as dirty.
   *    b. Otherwise, write `word` to `address` in memory.
   */
  _use_clock++;
  Cache::Block* block = find_block(address);
  if (block == NULL) {
    if (_policy.is_write_allocate()) {
      block = bring_block_into_cache(address);
    } else {
      _memory -> write_word(address, word);
      return;
    }
  }

  block -> set_last_used_time(_use_clock.get_count());
  block -> write_word_at_offset(word, extract_block_offset(address, _cache -> get_config()));

  if (_policy.is_write_back()) {
		block -> mark_as_dirty();
	} else {
		_memory -> write_word(address, word);
	}
}

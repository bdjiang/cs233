#include "simplecache.h"

int SimpleCache::find(int index, int tag, int block_offset) {
  std::vector< SimpleCacheBlock > thisCache = _cache[index];
  for (int i = 0; i < thisCache.size(); i++) {
    if (thisCache[i].valid()) {
      if (thisCache[i].tag() == tag) {
        return thisCache[i].get_byte(block_offset);
      }
    }
  }
  return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  std::vector< SimpleCacheBlock > &thisCache = _cache[index];
  for (int i = 0; i < thisCache.size(); i++) {
    if (!thisCache[i].valid()) {
      thisCache[i].replace(tag, data);
      return;
    }
  }
  thisCache[0].replace(tag, data);
}

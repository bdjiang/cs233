#include <stdio.h>
#include <stdlib.h>
#include "filter.h"

// modify this code by fusing loops together
void
filter_fusion(pixel_t **image1, pixel_t **image2) {

    for (int i = 0; i < SIZE; i++) {
      if (i > 0 && i < SIZE - 1) {
        filter1(image1, image2, i);
      }
      if (i > 1 && i < SIZE - 2) {
        filter2(image1, image2, i);
      }
      if (i > 5 && i < SIZE) {
        filter3(image2, i - 5);
      }
    }
}

// modify this code by adding software prefetching
void
filter_prefetch(pixel_t **image1, pixel_t **image2) {
    // int amount = 20;
    // for (int i = 1; i < SIZE - 1; i ++) {
    //     if (i >= 10) {
    //       __builtin_prefetch(image1[i+amount], 0);
    //       __builtin_prefetch(image2[i+amount], 1);
    //     }
    //
    //     filter1(image1, image2, i);
    //
    // }
    //
    // for (int i = 2; i < SIZE - 2; i ++) {
    //     if (i >= 10) {
    //       __builtin_prefetch(image1[i+amount], 0);
    //       __builtin_prefetch(image2[i+amount], 1);
    //     }
    //     filter2(image1, image2, i);
    // }
    //
    // for (int i = 1; i < SIZE - 5; i ++) {
    //     if (i >= 10) {
    //       __builtin_prefetch(image2[i+amount], 1);
    //     }
    //
    //     filter3(image2, i);
    // }

    int checker = 0;
    for (int i = 1 ; i < SIZE - 1; i++) {
      if(checker < i + 5) {
        checker = i;
        __builtin_prefetch ((image1[i + 10]), 0);
        __builtin_prefetch ((image2[i + 10]), 1);
      }
      filter1(image1, image2, i);

    }

    checker = 0;
    for (int i = 2; i < SIZE - 2; i++) {
      if(checker < i + 5) {
        checker = i;
        __builtin_prefetch(image1[i + 10], 0);
        __builtin_prefetch(image2[i + 10], 1);
      }
      filter2(image1, image2, i);

    }

    checker = 0;
    for (int i = 1; i < SIZE - 5; i++) {
      if(checker < i + 5){
        checker = i;
        __builtin_prefetch(image2[i + 10]);
      }
      filter3(image2, i);
    }

}

// modify this code by adding software prefetching and fusing loops together
void
filter_all(pixel_t **image1, pixel_t **image2) {
  for (int i = 0; i < SIZE; i++) {
    if (i > 0 && i < SIZE - 1) {
      __builtin_prefetch ((image1[i + 10]), 0);
      __builtin_prefetch ((image2[i + 10]), 1);
      filter1(image1, image2, i);
    }
    if (i > 1 && i < SIZE - 2) {
      __builtin_prefetch ((image1[i + 10]), 0);
      __builtin_prefetch ((image2[i + 10]), 1);
      filter2(image1, image2, i);
    }
    if (i > 5 && i < SIZE) {
      __builtin_prefetch(image2[i + 10]);
      filter3(image2, i - 5);
    }
  }
}

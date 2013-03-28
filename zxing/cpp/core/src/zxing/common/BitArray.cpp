// -*- mode:c++; tab-width:2; indent-tabs-mode:nil; c-basic-offset:2 -*-
/*
 *  Copyright 2010 ZXing authors. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <zxing/common/BitArray.h>

using namespace std;

namespace zxing {


size_t BitArray::wordsForBits(size_t bits) {
  int arraySize = (bits + bitsPerWord_ - 1) >> logBits_;
  return arraySize;
}

BitArray::BitArray(size_t size) :
    size_(size), bits_(wordsForBits(size), (const unsigned int)0) {
}

BitArray::~BitArray() {
}

size_t BitArray::getSize() {
  return size_;
}

void BitArray::setBulk(size_t i, unsigned int newBits) {
  bits_[i >> logBits_] = newBits;
}

void BitArray::setRange(int start, int end) {
  if (end < start) {
    throw IllegalArgumentException("invalid call to BitArray::setRange");
  }
  if (end == start) {
    return;
  }
  end--; // will be easier to treat this as the last actually set bit -- inclusive
  int firstInt = start >> 5;
  int lastInt = end >> 5;
  for (int i = firstInt; i <= lastInt; i++) {
    int firstBit = i > firstInt ? 0 : start & 0x1F;
    int lastBit = i < lastInt ? 31 : end & 0x1F;
    int mask;
    if (firstBit == 0 && lastBit == 31) {
      mask = -1;
    } else {
      mask = 0;
      for (int j = firstBit; j <= lastBit; j++) {
        mask |= 1 << j;
      }
    }
    bits_[i] |= mask;
  }
}

void BitArray::clear() {
  size_t max = bits_.size();
  for (size_t i = 0; i < max; i++) {
    bits_[i] = 0;
  }
}

bool BitArray::isRange(size_t start, size_t end, bool value) {
  if (end < start) {
    throw IllegalArgumentException("end must be after start");
  }
  if (end == start) {
    return true;
  }
  // treat the 'end' as inclusive, rather than exclusive
  end--;
  size_t firstWord = start >> logBits_;
  size_t lastWord = end >> logBits_;
  for (size_t i = firstWord; i <= lastWord; i++) {
    size_t firstBit = i > firstWord ? 0 : start & bitsMask_;
    size_t lastBit = i < lastWord ? bitsPerWord_ - 1: end & bitsMask_;
    unsigned int mask;
    if (firstBit == 0 && lastBit == bitsPerWord_ - 1) {
      mask = numeric_limits<unsigned int>::max();
    } else {
      mask = 0;
      for (size_t j = firstBit; j <= lastBit; j++) {
        mask |= 1 << j;
      }
    }
    if (value) {
      if ((bits_[i] & mask) != mask) {
        return false;
      }
    } else {
      if ((bits_[i] & mask) != 0) {
        return false;
      }
    }
  }
  return true;
}

vector<unsigned int>& BitArray::getBitArray() {
  return bits_;
}

void BitArray::reverse() {
  std::vector<unsigned int> newBits(bits_.size(),(const unsigned int) 0);
  for (size_t i = 0; i < size_; i++) {
    if (get(size_ - i - 1)) {
      newBits[i >> logBits_] |= 1<< (i & bitsMask_);
    }
  }
  bits_ = newBits;
}
}

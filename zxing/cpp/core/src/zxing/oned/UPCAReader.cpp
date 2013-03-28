/*
 *  UPCAReader.cpp
 *  ZXing
 *
 *  Copyright 2010 ZXing authors All rights reserved.
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

#include "UPCAReader.h"
#include <zxing/ReaderException.h>

namespace zxing {
  namespace oned {
    UPCAReader::UPCAReader() : ean13Reader() {
    }

    Ref<Result> UPCAReader::decodeRow(int rowNumber, Ref<BitArray> row) {
      return maybeReturnResult(ean13Reader.decodeRow(rowNumber, row));
    }

    Ref<Result> UPCAReader::decodeRow(int rowNumber, Ref<BitArray> row, int startGuardBegin,
        int startGuardEnd) {
      return maybeReturnResult(ean13Reader.decodeRow(rowNumber, row, startGuardBegin,
          startGuardEnd));
    }

    Ref<Result> UPCAReader::decode(Ref<BinaryBitmap> image, DecodeHints hints) {
      return maybeReturnResult(ean13Reader.decode(image, hints));
    }

    int UPCAReader::decodeMiddle(Ref<BitArray> row, int startGuardBegin, int startGuardEnd,
        std::string& resultString) {
      return ean13Reader.decodeMiddle(row, startGuardBegin, startGuardEnd, resultString);
    }

    Ref<Result> UPCAReader::maybeReturnResult(Ref<Result> result) {
      if (result.empty()) {
        return result;
      }
      const std::string& text = (result->getText())->getText();
      if (text[0] == '0') {
        Ref<String> resultString(new String(text.substr(1)));
        Ref<Result> res(new Result(resultString, result->getRawBytes(), result->getResultPoints(),
            BarcodeFormat_UPC_A));
        return res;
      }
      return Ref<Result>();
    }

    BarcodeFormat UPCAReader::getBarcodeFormat(){
      return BarcodeFormat_UPC_A;
    }
  }
}

import '../helpers/cut_string.dart';
import '../constants/emv.dart';
import '../constants/error_codes.dart';
import '../models/response.dart';
import '../models/decoded_qr_data.dart';

class DecodeKHQR {
  static DecodedQrData decode(String khqrString) {
    final Map<String, dynamic> tags = {};
    String remainingString = khqrString;
    String lastTag = '';
    String? merchantType;
    bool isMerchantTag = false;

    while (remainingString.isNotEmpty) {
      final result = cutString(remainingString);
      String tag = result.tag;
      final value = result.value;
      final slicedString = result.slicedString;

      if (tag == lastTag) break;

      final isMerchant = tag == '30';
      if (isMerchant) {
        merchantType = '30';
        tag = '29';
        isMerchantTag = true;
      } else if (tag == '29') {
        merchantType = '29';
      }

      tags[tag] = value;
      remainingString = slicedString;
      lastTag = tag;
    }

    Map<String, dynamic> decodeValue = {
      'merchantType': merchantType,
    };

    // Process tags
    for (final entry in tags.entries) {
      final tag = entry.key;
      final value = entry.value;

      switch (tag) {
        case '00':
          decodeValue['payloadFormatIndicator'] = value;
          break;
        case '01':
          decodeValue['pointOfInitiationMethod'] = value;
          break;
        case '29':
          decodeValue.addAll(_processGlobalUniqueIdentifier(value, isMerchantTag));
          break;
        case '52':
          decodeValue['merchantCategoryCode'] = value;
          break;
        case '53':
          decodeValue['transactionCurrency'] = value;
          break;
        case '54':
          decodeValue['transactionAmount'] = value;
          break;
        case '58':
          decodeValue['countryCode'] = value;
          break;
        case '59':
          decodeValue['merchantName'] = value;
          break;
        case '60':
          decodeValue['merchantCity'] = value;
          break;
        case '62':
          decodeValue.addAll(_processAdditionalData(value));
          break;
        case '63':
          decodeValue['crc'] = value;
          break;
        case '15':
          decodeValue['unionPayMerchant'] = value;
          break;
        case '64':
          decodeValue.addAll(_processLanguageTemplate(value));
          break;
        case '99':
          decodeValue.addAll(_processTimestamp(value));
          break;
        default:
          decodeValue[tag] = value;
      }
    }

    return DecodedQrData.fromJson(decodeValue);
  }

  static Map<String, dynamic> decodeNonKhqr(String qrString) {
    final Map<String, dynamic> firstLevelData = {};
    final Map<String, dynamic> finalData = {};
    String remainingQR = qrString;

    // First-level parsing
    while (remainingQR.isNotEmpty) {
      if (remainingQR.length < 4) break;
      
      final tag = remainingQR.substring(0, 2);
      final lengthStr = remainingQR.substring(2, 4);
      final length = int.tryParse(lengthStr);
      
      if (length == null || !_isNumeric(tag)) break;
      
      if (remainingQR.length < 4 + length) break;
      
      final value = remainingQR.substring(4, 4 + length);
      final remainString = remainingQR.substring(4 + length);

      if (!_isValid(tag, length, value)) break;
      
      firstLevelData[tag] = value;
      remainingQR = remainString;
    }

    // Second-level parsing
    for (final entry in firstLevelData.entries) {
      final tag = entry.key;
      String remainingValue = entry.value;
      finalData[tag] = remainingValue;

      final tagInt = int.tryParse(tag);
      if (tagInt == null) continue;

      // Check range 26-51, 80-99 and 64, 62
      if (!((tagInt >= 26 && tagInt <= 51) || 
            (tagInt >= 80 && tagInt <= 99) || 
            tag == '64' || 
            tag == '62')) {
        continue;
      }

      if (remainingValue.length < 6) continue;

      final Map<String, dynamic> secondLevelData = {};
      
      while (remainingValue.isNotEmpty) {
        if (remainingValue.length < 4) break;
        
        final subTag = remainingValue.substring(0, 2);
        final subLengthStr = remainingValue.substring(2, 4);
        final subLength = int.tryParse(subLengthStr);
        
        if (subLength == null || !_isNumeric(subTag)) break;
        
        if (remainingValue.length < 4 + subLength) break;
        
        final subValue = remainingValue.substring(4, 4 + subLength);
        final remainString = remainingValue.substring(4 + subLength);

        if (!_isValid(subTag, subLength, subValue)) break;
        
        remainingValue = remainString;

        // Check for third-level (main tag is 62 and subtags range from 50-99)
        final subTagInt = int.tryParse(subTag);
        if (tag == '62' && subTagInt != null && subTagInt >= 50 && subTagInt <= 99) {
          final Map<String, dynamic> thirdLevelData = {};
          String remainingValueL3 = subValue;
          
          while (remainingValueL3.isNotEmpty) {
            if (remainingValueL3.length < 4) break;
            
            final subTagL3 = remainingValueL3.substring(0, 2);
            final lengthL3Str = remainingValueL3.substring(2, 4);
            final lengthL3 = int.tryParse(lengthL3Str);
            
            if (lengthL3 == null || !_isNumeric(subTagL3)) break;
            
            if (remainingValueL3.length < 4 + lengthL3) break;
            
            final valueL3 = remainingValueL3.substring(4, 4 + lengthL3);
            final remainStringL3 = remainingValueL3.substring(4 + lengthL3);

            if (!_isValid(subTagL3, lengthL3, valueL3)) break;
            
            thirdLevelData[subTagL3] = valueL3;
            remainingValueL3 = remainStringL3;
          }
          
          if (thirdLevelData.isNotEmpty) {
            secondLevelData[subTag] = thirdLevelData;
          } else {
            secondLevelData[subTag] = subValue;
          }
        } else {
          secondLevelData[subTag] = subValue;
        }
      }

      if (secondLevelData.isNotEmpty) {
        finalData[tag] = secondLevelData;
      }
    }

    return finalData;
  }

  static void decodeValidation(String khqrString) {
    // This would contain validation logic similar to the original
    // For now, we'll do basic validation
    if (khqrString.length < EMV.invalidLength['khqr']!) {
      throw KHQRResponse.error(ErrorCode.khqrInvalid);
    }
    
    // Additional validation logic would go here
    // This is a simplified version
  }

  static Map<String, dynamic> _processGlobalUniqueIdentifier(String value, bool isMerchantTag) {
    final Map<String, dynamic> result = {};
    String remainingValue = value;

    while (remainingValue.isNotEmpty) {
      final subResult = cutString(remainingValue);
      final subTag = subResult.tag;
      final subValue = subResult.value;
      
      switch (subTag) {
        case '00':
          result['bakongAccountID'] = subValue;
          break;
        case '01':
          if (isMerchantTag) {
            result['merchantID'] = subValue;
          } else {
            result['accountInformation'] = subValue;
          }
          break;
        case '02':
          result['acquiringBank'] = subValue;
          break;
      }
      
      remainingValue = subResult.slicedString;
    }

    return result;
  }

  static Map<String, dynamic> _processAdditionalData(String value) {
    final Map<String, dynamic> result = {};
    String remainingValue = value;

    while (remainingValue.isNotEmpty) {
      final subResult = cutString(remainingValue);
      final subTag = subResult.tag;
      final subValue = subResult.value;
      
      switch (subTag) {
        case '01':
          result['billNumber'] = subValue;
          break;
        case '02':
          result['mobileNumber'] = subValue;
          break;
        case '03':
          result['storeLabel'] = subValue;
          break;
        case '07':
          result['terminalLabel'] = subValue;
          break;
        case '08':
          result['purposeOfTransaction'] = subValue;
          break;
      }
      
      remainingValue = subResult.slicedString;
    }

    return result;
  }

  static Map<String, dynamic> _processTimestamp(String value) {
    final Map<String, dynamic> result = {};
    String remainingValue = value;

    while (remainingValue.isNotEmpty) {
      final subResult = cutString(remainingValue);
      final subTag = subResult.tag;
      final subValue = subResult.value;
      
      switch (subTag) {
        case '00':
          result['creationTimestamp'] = subValue;
          break;
        case '01':
          result['expirationTimestamp'] = subValue;
          break;
      }
      
      remainingValue = subResult.slicedString;
    }

    return result;
  }


    static Map<String, dynamic> _processLanguageTemplate(String value) {
    final Map<String, dynamic> result = {};
    String remainingValue = value;

    while (remainingValue.isNotEmpty) {
      final subResult = cutString(remainingValue);
      final subTag = subResult.tag;
      final subValue = subResult.value;
      
      switch (subTag) {
        case '00':
          result['languagePreference'] = subValue;
          break;
        case '01':
          result['merchantNameAlternateLanguage'] = subValue;
          break;
        case '02':
          result['merchantCityAlternateLanguage'] = subValue;
          break;
      }
      
      remainingValue = subResult.slicedString;
    }

    return result;
  }

  static bool _isNumeric(String value) {
    return RegExp(r'^\d+').hasMatch(value);
  }

  static bool _isValid(String tag, int length, String value) {
    return _isNumeric(tag) && length == value.length;
  }
}
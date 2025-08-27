import '../models/tag_length_string.dart';
import '../constants/error_codes.dart';
import '../constants/emv.dart';
import '../models/response.dart';

class MerchantCategoryCode extends TagLengthString {
  MerchantCategoryCode(String tag, String value) : super(tag, value) {
    if (value.isEmpty) {
      throw KHQRResponse.error(ErrorCode.merchantCategoryTagRequired);
    }
    if (value.length > EMV.invalidLength['merchantCategoryCode']!) {
      throw KHQRResponse.error(ErrorCode.merchantCodeLengthInvalid);
    }
    
    final numericRegex = RegExp(r'^\d+$');
    if (!numericRegex.hasMatch(value)) {
      throw KHQRResponse.error(ErrorCode.invalidMerchantCategoryCode);
    }
    
    final mcc = int.tryParse(value);
    if (mcc == null || mcc < 0 || mcc > 9999) {
      throw KHQRResponse.error(ErrorCode.invalidMerchantCategoryCode);
    }
  }
}
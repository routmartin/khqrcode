import '../models/tag_length_string.dart';
import '../constants/error_codes.dart';
import '../constants/emv.dart';
import '../models/response.dart';

class MerchantName extends TagLengthString {
  MerchantName(String tag, String value) : super(tag, value) {
    if (value.isEmpty) {
      throw KHQRResponse.error(ErrorCode.merchantNameRequired);
    }
    if (value.length > EMV.invalidLength['merchantName']!) {
      throw KHQRResponse.error(ErrorCode.merchantNameLengthInvalid);
    }
  }
}
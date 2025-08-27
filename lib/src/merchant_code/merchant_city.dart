import '../models/tag_length_string.dart';
import '../constants/error_codes.dart';
import '../constants/emv.dart';
import '../models/response.dart';

class MerchantCity extends TagLengthString {
  MerchantCity(String tag, String value) : super(tag, value) {
    if (value.isEmpty) {
      throw KHQRResponse.error(ErrorCode.merchantCityTagRequired);
    }
    if (value.length > EMV.invalidLength['merchantCity']!) {
      throw KHQRResponse.error(ErrorCode.merchantCityLengthInvalid);
    }
  }
}
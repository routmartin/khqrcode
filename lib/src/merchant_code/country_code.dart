import '../models/tag_length_string.dart';
import '../constants/error_codes.dart';
import '../constants/emv.dart';
import '../models/response.dart';

class CountryCode extends TagLengthString {
  CountryCode(String tag, String value) : super(tag, value) {
    if (value.isEmpty) {
      throw KHQRResponse.error(ErrorCode.countryCodeTagRequired);
    }
    if (value.length > EMV.invalidLength['countryCode']!) {
      throw KHQRResponse.error(ErrorCode.countryCodeLengthInvalid);
    }
  }
}
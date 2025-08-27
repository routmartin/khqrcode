import '../models/tag_length_string.dart';
import '../constants/error_codes.dart';
import '../models/response.dart';

class PayloadFormatIndicator extends TagLengthString {
  PayloadFormatIndicator(String tag, String value) : super(tag, value) {
    if (value.isEmpty) {
      throw KHQRResponse.error(ErrorCode.payloadFormatIndicatorTagRequired);
    }
    if (value.length > 2) {
      throw KHQRResponse.error(ErrorCode.payloadFormatIndicatorLengthInvalid);
    }
  }
}
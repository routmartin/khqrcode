import '../models/tag_length_string.dart';
import '../constants/error_codes.dart';
import '../models/response.dart';

class CRC extends TagLengthString {
  CRC(String tag, String value) : super(tag, value) {
    if (value.isEmpty) {
      throw KHQRResponse.error(ErrorCode.crcTagRequired);
    }
    if (value.length > 4) {
      throw KHQRResponse.error(ErrorCode.crcLengthInvalid);
    }
  }
}
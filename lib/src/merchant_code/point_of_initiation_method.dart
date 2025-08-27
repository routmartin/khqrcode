import '../models/tag_length_string.dart';
import '../constants/error_codes.dart';
import '../constants/emv.dart';
import '../models/response.dart';

class PointOfInitiationMethod extends TagLengthString {
  PointOfInitiationMethod(String tag, String value) : super(tag, value) {
    if (value.length > 2) {
      throw KHQRResponse.error(ErrorCode.pointInitiationLengthInvalid);
    }
    if (value != EMV.staticQR && value != EMV.dynamicQR) {
      throw KHQRResponse.error(ErrorCode.pointOfInitiationMethodInvalid);
    }
  }
}
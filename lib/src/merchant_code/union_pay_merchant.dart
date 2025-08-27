import '../models/tag_length_string.dart';
import '../constants/error_codes.dart';
import '../constants/emv.dart';
import '../models/response.dart';

class UnionPayMerchant extends TagLengthString {
  UnionPayMerchant(String tag, String value) : super(tag, value) {
    if (value.length > EMV.invalidLength['upiMerchant']!) {
      throw KHQRResponse.error(ErrorCode.upiAccountInformationLengthInvalid);
    }
  }
}
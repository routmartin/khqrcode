import '../models/tag_length_string.dart';
import '../constants/error_codes.dart';
import '../constants/emv.dart';
import '../models/response.dart';

class TransactionAmount extends TagLengthString {
  TransactionAmount(String tag, String value) : super(tag, value) {
    if (value.isEmpty ||
        value.length > EMV.invalidLength['amount']! ||
        value.contains('-')) {
      throw KHQRResponse.error(ErrorCode.transactionAmountInvalid);
    }
  }
}
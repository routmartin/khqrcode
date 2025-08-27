import '../models/tag_length_string.dart';
import '../constants/error_codes.dart';
import '../constants/khqr_data.dart';
import '../models/response.dart';

class TransactionCurrency extends TagLengthString {
  TransactionCurrency(String tag, String value) : super(tag, value) {
    if (value.isEmpty) {
      throw KHQRResponse.error(ErrorCode.currencyTypeRequired);
    }
    if (value.length > 3) {
      throw KHQRResponse.error(ErrorCode.transactionCurrencyLengthInvalid);
    }
    
    final currencyCode = int.tryParse(value);
    if (currencyCode == null || 
        ![KHQRDataConst.currency['khr'], KHQRDataConst.currency['usd']].contains(currencyCode)) {
      throw KHQRResponse.error(ErrorCode.unsupportedCurrency);
    }
  }
}
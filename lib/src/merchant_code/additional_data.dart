import '../models/tag_length_string.dart';
import '../constants/error_codes.dart';
import '../constants/emv.dart';
import '../models/response.dart';

class BillNumber extends TagLengthString {
  BillNumber(String tag, String value) : super(tag, value) {
    if (value.length > EMV.invalidLength['billNumber']! || value.isEmpty) {
      throw KHQRResponse.error(ErrorCode.billNumberLengthInvalid);
    }
  }
}

class StoreLabel extends TagLengthString {
  StoreLabel(String tag, String value) : super(tag, value) {
    if (value.length > EMV.invalidLength['storeLabel']! || value.isEmpty) {
      throw KHQRResponse.error(ErrorCode.storeLabelLengthInvalid);
    }
  }
}

class TerminalLabel extends TagLengthString {
  TerminalLabel(String tag, String value) : super(tag, value) {
    if (value.length > EMV.invalidLength['terminalLabel']! || value.isEmpty) {
      throw KHQRResponse.error(ErrorCode.terminalLabelLengthInvalid);
    }
  }
}

class MobileNumber extends TagLengthString {
  MobileNumber(String tag, String value) : super(tag, value) {
    if (value.length > EMV.invalidLength['mobileNumber']! || value.isEmpty) {
      throw KHQRResponse.error(ErrorCode.mobileNumberLengthInvalid);
    }
  }
}

class PurposeOfTransaction extends TagLengthString {
  PurposeOfTransaction(String tag, String value) : super(tag, value) {
    if (value.length > EMV.invalidLength['purposeOfTransaction']! || value.isEmpty) {
      throw KHQRResponse.error(ErrorCode.purposeOfTransactionLengthInvalid);
    }
  }
}

class AdditionalData extends TagLengthString {
  final BillNumber? billNumber;
  final MobileNumber? mobileNumber;
  final StoreLabel? storeLabel;
  final TerminalLabel? terminalLabel;
  final PurposeOfTransaction? purposeOfTransaction;
  final Map<String, dynamic> data;

  AdditionalData(String tag, Map<String, dynamic>? additionalData)
      : billNumber = additionalData?['billNumber'] != null
            ? BillNumber(EMV.billNumberTag, additionalData!['billNumber'])
            : null,
        mobileNumber = additionalData?['mobileNumber'] != null
            ? MobileNumber(EMV.additionalDataFieldMobileNumber, additionalData!['mobileNumber'])
            : null,
        storeLabel = additionalData?['storeLabel'] != null
            ? StoreLabel(EMV.storeLabelTag, additionalData!['storeLabel'])
            : null,
        terminalLabel = additionalData?['terminalLabel'] != null
            ? TerminalLabel(EMV.terminalTag, additionalData!['terminalLabel'])
            : null,
        purposeOfTransaction = additionalData?['purposeOfTransaction'] != null
            ? PurposeOfTransaction(EMV.purposeOfTransaction, additionalData!['purposeOfTransaction'])
            : null,
        data = additionalData ?? {},
        super(tag, _buildAdditionalDataString(additionalData));

  static String _buildAdditionalDataString(Map<String, dynamic>? additionalData) {
    if (additionalData == null) return '';
    
    String additionalDataString = '';
    
    if (additionalData['billNumber'] != null) {
      final billNumber = BillNumber(EMV.billNumberTag, additionalData['billNumber']);
      additionalDataString += billNumber.toString();
    }
    
    if (additionalData['mobileNumber'] != null) {
      final mobileNumber = MobileNumber(EMV.additionalDataFieldMobileNumber, additionalData['mobileNumber']);
      additionalDataString += mobileNumber.toString();
    }
    
    if (additionalData['storeLabel'] != null) {
      final storeLabel = StoreLabel(EMV.storeLabelTag, additionalData['storeLabel']);
      additionalDataString += storeLabel.toString();
    }
    
    if (additionalData['terminalLabel'] != null) {
      final terminalLabel = TerminalLabel(EMV.terminalTag, additionalData['terminalLabel']);
      additionalDataString += terminalLabel.toString();
    }
    
    if (additionalData['purposeOfTransaction'] != null) {
      final purpose = PurposeOfTransaction(EMV.purposeOfTransaction, additionalData['purposeOfTransaction']);
      additionalDataString += purpose.toString();
    }
    
    return additionalDataString;
  }
}
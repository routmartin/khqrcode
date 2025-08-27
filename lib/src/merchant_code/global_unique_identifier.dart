import '../models/tag_length_string.dart';
import '../constants/error_codes.dart';
import '../constants/emv.dart';
import '../models/response.dart';

class BakongAccountId extends TagLengthString {
  BakongAccountId(String tag, String bakongAccountId) : super(tag, bakongAccountId) {
    if (bakongAccountId.isEmpty) {
      throw KHQRResponse.error(ErrorCode.bakongAccountIdRequired);
    }
    
    if (bakongAccountId.length > EMV.invalidLength['bakongAccount']!) {
      throw KHQRResponse.error(ErrorCode.bakongAccountIdLengthInvalid);
    }
    
    final bakongAccountDivide = bakongAccountId.split('@');
    if (bakongAccountDivide.length < 2) {
      throw KHQRResponse.error(ErrorCode.bakongAccountIdInvalid);
    }
  }
}

class AccountInformation extends TagLengthString {
  AccountInformation(String tag, String value) : super(tag, value) {
    if (value.length > EMV.invalidLength['accountInformation']!) {
      throw KHQRResponse.error(ErrorCode.accountInformationLengthInvalid);
    }
  }
}

class MerchantId extends TagLengthString {
  MerchantId(String tag, String value) : super(tag, value) {
    if (value.isEmpty) {
      throw KHQRResponse.error(ErrorCode.merchantIdRequired);
    }
    if (value.length > EMV.invalidLength['merchantId']!) {
      throw KHQRResponse.error(ErrorCode.merchantIdLengthInvalid);
    }
  }
}

class AcquiringBank extends TagLengthString {
  AcquiringBank(String tag, String value) : super(tag, value) {
    if (value.isEmpty) {
      throw KHQRResponse.error(ErrorCode.acquiringBankRequired);
    }
    if (value.length > EMV.invalidLength['acquiringBank']!) {
      throw KHQRResponse.error(ErrorCode.acquiringBankLengthInvalid);
    }
  }
}

class GlobalUniqueIdentifier extends TagLengthString {
  final BakongAccountId bakongAccountId;
  final MerchantId? merchantId;
  final AcquiringBank? acquiringBank;
  final AccountInformation? accountInformation;
  final Map<String, dynamic> data;

  GlobalUniqueIdentifier(String tag, Map<String, dynamic> valueObject) 
      : bakongAccountId = BakongAccountId(
          EMV.bakongAccountIdentifier,
          valueObject['bakongAccountID'] ?? '',
        ),
        merchantId = valueObject['merchantID'] != null 
            ? MerchantId(EMV.merchantAccountInformationMerchantId, valueObject['merchantID'])
            : null,
        acquiringBank = valueObject['acquiringBank'] != null
            ? AcquiringBank(EMV.merchantAccountInformationAcquiringBank, valueObject['acquiringBank'])
            : null,
        accountInformation = valueObject['accountInformation'] != null
            ? AccountInformation(EMV.individualAccountInformation, valueObject['accountInformation'])
            : null,
        data = valueObject,
        super(tag, _buildGlobalUniqueIdentifierString(valueObject)) {
    
    if (valueObject['bakongAccountID'] == null) {
      throw KHQRResponse.error(ErrorCode.merchantTypeRequired);
    }
  }

  static String _buildGlobalUniqueIdentifierString(Map<String, dynamic> valueObject) {
    final bakongAccountId = BakongAccountId(
      EMV.bakongAccountIdentifier,
      valueObject['bakongAccountID'] ?? '',
    );
    
    String globalUniqueIdentifier = bakongAccountId.toString();
    
    final isMerchant = valueObject['isMerchant'] == true;
    
    if (isMerchant) {
      if (valueObject['merchantID'] != null) {
        final merchantId = MerchantId(
          EMV.merchantAccountInformationMerchantId,
          valueObject['merchantID'],
        );
        globalUniqueIdentifier += merchantId.toString();
      }
      
      if (valueObject['acquiringBank'] != null) {
        final acquiringBankName = AcquiringBank(
          EMV.merchantAccountInformationAcquiringBank,
          valueObject['acquiringBank'],
        );
        globalUniqueIdentifier += acquiringBankName.toString();
      }
    } else {
      if (valueObject['accountInformation'] != null) {
        final accInformation = AccountInformation(
          EMV.individualAccountInformation,
          valueObject['accountInformation'],
        );
        globalUniqueIdentifier += accInformation.toString();
      }
      
      if (valueObject['acquiringBank'] != null) {
        final acquiringBankName = AcquiringBank(
          EMV.merchantAccountInformationAcquiringBank,
          valueObject['acquiringBank'],
        );
        globalUniqueIdentifier += acquiringBankName.toString();
      }
    }
    
    return globalUniqueIdentifier;
  }
}
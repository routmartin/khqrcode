Map<String, dynamic> _removeEmptyElements(Map<String, dynamic> map) {
  return Map.fromEntries(
    map.entries.where((entry) => entry.value != null && entry.value != '' && entry.value.toString().isNotEmpty),
  );
}

class IndividualInfo {
  final String bakongAccountId;
  final String? accountInformation;
  final String? acquiringBank;
  final int currency;
  final double? amount;
  final String merchantName;
  final String merchantCity;
  final String? billNumber;
  final String? storeLabel;
  final String? terminalLabel;
  final String? mobileNumber;
  final String? purposeOfTransaction;
  final String? languagePreference;
  final String? merchantNameAlternateLanguage;
  final String? merchantCityAlternateLanguage;
  final String? upiMerchantAccount;
  final int? expirationTimestamp;
  final String? merchantCategoryCode;

  IndividualInfo({
    required this.bakongAccountId,
    required this.merchantName,
    required this.merchantCity,
    this.accountInformation,
    this.acquiringBank,
    this.currency = 116, // Default to KHR
    this.amount,
    this.billNumber,
    this.storeLabel,
    this.terminalLabel,
    this.mobileNumber,
    this.purposeOfTransaction,
    this.languagePreference,
    this.merchantNameAlternateLanguage,
    this.merchantCityAlternateLanguage,
    this.upiMerchantAccount,
    this.expirationTimestamp,
    this.merchantCategoryCode,
  }) {
    if (bakongAccountId.isEmpty || merchantName.isEmpty || merchantCity.isEmpty) {
      throw ArgumentError('bakongAccountId, merchantName, and merchantCity cannot be empty');
    }
  }

  Map<String, dynamic> toMap() {
    return _removeEmptyElements({
      'bakongAccountId': bakongAccountId,
      'accountInformation': accountInformation,
      'acquiringBank': acquiringBank,
      'currency': currency,
      'amount': amount,
      'merchantName': merchantName,
      'merchantCity': merchantCity,
      'billNumber': billNumber,
      'storeLabel': storeLabel,
      'terminalLabel': terminalLabel,
      'mobileNumber': mobileNumber,
      'purposeOfTransaction': purposeOfTransaction,
      'languagePreference': languagePreference,
      'merchantNameAlternateLanguage': merchantNameAlternateLanguage,
      'merchantCityAlternateLanguage': merchantCityAlternateLanguage,
      'upiMerchantAccount': upiMerchantAccount,
      'expirationTimestamp': expirationTimestamp,
      'merchantCategoryCode': merchantCategoryCode,
    });
  }
}

class MerchantInfo extends IndividualInfo {
  final String merchantId;
  final String acquiringBankName;

  MerchantInfo({
    required String bakongAccountId,
    required String merchantName,
    required String merchantCity,
    required this.merchantId,
    required this.acquiringBankName,
    String? accountInformation,
    int currency = 116,
    double? amount,
    String? billNumber,
    String? storeLabel,
    String? terminalLabel,
    String? mobileNumber,
    String? purposeOfTransaction,
    String? languagePreference,
    String? merchantNameAlternateLanguage,
    String? merchantCityAlternateLanguage,
    String? upiMerchantAccount,
    int? expirationTimestamp,
    String? merchantCategoryCode,
  }) : super(
         bakongAccountId: bakongAccountId,
         merchantName: merchantName,
         merchantCity: merchantCity,
         accountInformation: accountInformation,
         acquiringBank: acquiringBankName,
         currency: currency,
         amount: amount,
         billNumber: billNumber,
         storeLabel: storeLabel,
         terminalLabel: terminalLabel,
         mobileNumber: mobileNumber,
         purposeOfTransaction: purposeOfTransaction,
         languagePreference: languagePreference,
         merchantNameAlternateLanguage: merchantNameAlternateLanguage,
         merchantCityAlternateLanguage: merchantCityAlternateLanguage,
         upiMerchantAccount: upiMerchantAccount,
         expirationTimestamp: expirationTimestamp,
         merchantCategoryCode: merchantCategoryCode,
       ) {
    if (merchantId.isEmpty || acquiringBankName.isEmpty) {
      throw ArgumentError('merchantId and acquiringBankName cannot be empty');
    }
  }

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['merchantId'] = merchantId;
    map['acquiringBank'] = acquiringBankName;
    return map;
  }
}

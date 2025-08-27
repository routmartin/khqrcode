class DecodedQrData {
  final String? merchantType;
  final String? bakongAccountID;
  final String? accountInformation;
  final String? merchantID;
  final String? acquiringBank;
  final String? billNumber;
  final String? mobileNumber;
  final String? storeLabel;
  final String? terminalLabel;
  final String? purposeOfTransaction;
  final String? languagePreference;
  final String? merchantNameAlternateLanguage;
  final String? merchantCityAlternateLanguage;
  final String? creationTimestamp;
  final String? expirationTimestamp;
  final String? payloadFormatIndicator;
  final String? pointofInitiationMethod;
  final String? unionPayMerchant;
  final String? merchantCategoryCode;
  final String? transactionCurrency;
  final String? transactionAmount;
  final String? countryCode;
  final String? merchantName;
  final String? merchantCity;
  final String? crc;

  DecodedQrData({
    this.merchantType,
    this.bakongAccountID,
    this.accountInformation,
    this.merchantID,
    this.acquiringBank,
    this.billNumber,
    this.mobileNumber,
    this.storeLabel,
    this.terminalLabel,
    this.purposeOfTransaction,
    this.languagePreference,
    this.merchantNameAlternateLanguage,
    this.merchantCityAlternateLanguage,
    this.creationTimestamp,
    this.expirationTimestamp,
    this.payloadFormatIndicator,
    this.pointofInitiationMethod,
    this.unionPayMerchant,
    this.merchantCategoryCode,
    this.transactionCurrency,
    this.transactionAmount,
    this.countryCode,
    this.merchantName,
    this.merchantCity,
    this.crc,
  });

  factory DecodedQrData.fromJson(Map<String, dynamic> json) {
    return DecodedQrData(
      merchantType: json['merchantType'],
      bakongAccountID: json['bakongAccountID'],
      accountInformation: json['accountInformation'],
      merchantID: json['merchantID'],
      acquiringBank: json['acquiringBank'],
      billNumber: json['billNumber'],
      mobileNumber: json['mobileNumber'],
      storeLabel: json['storeLabel'],
      terminalLabel: json['terminalLabel'],
      purposeOfTransaction: json['purposeOfTransaction'],
      languagePreference: json['languagePreference'],
      merchantNameAlternateLanguage: json['merchantNameAlternateLanguage'],
      merchantCityAlternateLanguage: json['merchantCityAlternateLanguage'],
      creationTimestamp: json['creationTimestamp'],
      expirationTimestamp: json['expirationTimestamp'],
      payloadFormatIndicator: json['payloadFormatIndicator'],
      pointofInitiationMethod: json['pointofInitiationMethod'],
      unionPayMerchant: json['unionPayMerchant'],
      merchantCategoryCode: json['merchantCategoryCode'],
      transactionCurrency: json['transactionCurrency'],
      transactionAmount: json['transactionAmount'],
      countryCode: json['countryCode'],
      merchantName: json['merchantName'],
      merchantCity: json['merchantCity'],
      crc: json['crc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merchantType': merchantType,
      'bakongAccountID': bakongAccountID,
      'accountInformation': accountInformation,
      'merchantID': merchantID,
      'acquiringBank': acquiringBank,
      'billNumber': billNumber,
      'mobileNumber': mobileNumber,
      'storeLabel': storeLabel,
      'terminalLabel': terminalLabel,
      'purposeOfTransaction': purposeOfTransaction,
      'languagePreference': languagePreference,
      'merchantNameAlternateLanguage': merchantNameAlternateLanguage,
      'merchantCityAlternateLanguage': merchantCityAlternateLanguage,
      'creationTimestamp': creationTimestamp,
      'expirationTimestamp': expirationTimestamp,
      'payloadFormatIndicator': payloadFormatIndicator,
      'pointofInitiationMethod': pointofInitiationMethod,
      'unionPayMerchant': unionPayMerchant,
      'merchantCategoryCode': merchantCategoryCode,
      'transactionCurrency': transactionCurrency,
      'transactionAmount': transactionAmount,
      'countryCode': countryCode,
      'merchantName': merchantName,
      'merchantCity': merchantCity,
      'crc': crc,
    };
  }
}
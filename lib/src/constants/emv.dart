class EMV {
  static const String payloadFormatIndicator = "00";
  static const String defaultPayloadFormatIndicator = "01";
  static const String pointOfInitiationMethod = "01";
  static const String staticQR = "11";
  static const String dynamicQR = "12";
  static const String merchantAccountInformationIndividual = "29";
  static const String merchantAccountInformationMerchant = "30";
  static const String bakongAccountIdentifier = "00";
  static const String merchantAccountInformationMerchantId = "01";
  static const String individualAccountInformation = "01";
  static const String merchantAccountInformationAcquiringBank = "02";
  static const String merchantCategoryCode = "52";
  static const String defaultMerchantCategoryCode = "5999";
  static const String transactionCurrency = "53";
  static const String transactionAmount = "54";
  static const String defaultTransactionAmount = "0";
  static const String countryCode = "58";
  static const String defaultCountryCode = "KH";
  static const String merchantName = "59";
  static const String merchantCity = "60";
  static const String defaultMerchantCity = "Phnom Penh";
  static const String crc = "63";
  static const String crcLength = "04";
  static const String additionalDataTag = "62";
  static const String billNumberTag = "01";
  static const String additionalDataFieldMobileNumber = "02";
  static const String storeLabelTag = "03";
  static const String terminalTag = "07";
  static const String purposeOfTransaction = "08";
  static const String timestampTag = "99";
  static const String creationTimestamp = "00";
  static const String expirationTimestamp = "01";
  static const String merchantInformationLanguageTemplate = "64";
  static const String languagePreference = "00";
  static const String merchantNameAlternateLanguage = "01";
  static const String merchantCityAlternateLanguage = "02";
  static const String unionpayMerchantAccount = "15";

  static const Map<String, int> invalidLength = {
    'khqr': 12,
    'merchantName': 25,
    'bakongAccount': 32,
    'amount': 13,
    'countryCode': 3,
    'merchantCategoryCode': 4,
    'merchantCity': 15,
    'timestamp': 13,
    'transactionAmount': 14,
    'transactionCurrency': 3,
    'billNumber': 25,
    'storeLabel': 25,
    'terminalLabel': 25,
    'purposeOfTransaction': 25,
    'merchantId': 32,
    'acquiringBank': 32,
    'mobileNumber': 25,
    'accountInformation': 32,
    'merchantInformationLanguageTemplate': 99,
    'upiMerchant': 99,
    'languagePreference': 2,
    'merchantNameAlternateLanguage': 25,
    'merchantCityAlternateLanguage': 15,
  };
}
class ErrorCode {
  final int code;
  final String message;

  const ErrorCode(this.code, this.message);

  static const bakongAccountIdRequired = ErrorCode(1, "Bakong Account ID cannot be null or empty");
  static const merchantNameRequired = ErrorCode(2, "Merchant name cannot be null or empty");
  static const bakongAccountIdInvalid = ErrorCode(3, "Bakong Account ID is invalid");
  static const transactionAmountInvalid = ErrorCode(4, "Amount is invalid");
  static const merchantTypeRequired = ErrorCode(5, "Merchant type cannot be null or empty");
  static const bakongAccountIdLengthInvalid = ErrorCode(6, "Bakong Account ID Length is Invalid");
  static const merchantNameLengthInvalid = ErrorCode(7, "Merchant Name Length is invalid");
  static const khqrInvalid = ErrorCode(8, "KHQR provided is invalid");
  static const currencyTypeRequired = ErrorCode(9, "Currency type cannot be null or empty");
  static const billNumberLengthInvalid = ErrorCode(10, "Bill Name Length is invalid");
  static const storeLabelLengthInvalid = ErrorCode(11, "Store Label Length is invalid");
  static const terminalLabelLengthInvalid = ErrorCode(12, "Terminal Label Length is invalid");
  static const connectionTimeout = ErrorCode(13, "Cannot reach Bakong Open API service. Please check internet connection");
  static const invalidDeepLinkSourceInfo = ErrorCode(14, "Source Info for Deep Link is invalid");
  static const internalServer = ErrorCode(15, "Internal server error");
  static const payloadFormatIndicatorLengthInvalid = ErrorCode(16, "Payload Format indicator Length is invalid");
  static const pointInitiationLengthInvalid = ErrorCode(17, "Point of initiation Length is invalid");
  static const merchantCodeLengthInvalid = ErrorCode(18, "Merchant code Length is invalid");
  static const transactionCurrencyLengthInvalid = ErrorCode(19, "Transaction currency Length is invalid");
  static const countryCodeLengthInvalid = ErrorCode(20, "Country code Length is invalid");
  static const merchantCityLengthInvalid = ErrorCode(21, "Merchant city Length is invalid");
  static const crcLengthInvalid = ErrorCode(22, "CRC Length is invalid");
  static const payloadFormatIndicatorTagRequired = ErrorCode(23, "Payload format indicator tag required");
  static const crcTagRequired = ErrorCode(24, "CRC tag required");
  static const merchantCategoryTagRequired = ErrorCode(25, "Merchant category tag required");
  static const countryCodeTagRequired = ErrorCode(26, "Country Code cannot be null or empty");
  static const merchantCityTagRequired = ErrorCode(27, "Merchant City cannot be null or empty");
  static const unsupportedCurrency = ErrorCode(28, "Unsupported currency");
  static const invalidDeepLinkUrl = ErrorCode(29, "Deep Link URL is not valid");
  static const merchantIdRequired = ErrorCode(30, "Merchant ID cannot be null or empty");
  static const acquiringBankRequired = ErrorCode(31, "Acquiring Bank cannot be null or empty");
  static const merchantIdLengthInvalid = ErrorCode(32, "Merchant ID Length is invalid");
  static const acquiringBankLengthInvalid = ErrorCode(33, "Acquiring Bank Length is invalid");
  static const mobileNumberLengthInvalid = ErrorCode(34, "Mobile Number Length is invalid");
  static const accountInformationLengthInvalid = ErrorCode(35, "Account Information Length is invalid");
  static const tagNotInOrder = ErrorCode(36, "Tag is not in order");
  static const languagePreferenceRequired = ErrorCode(37, "Language Preference cannot be null or empty");
  static const languagePreferenceLengthInvalid = ErrorCode(38, "Language Preference Length is invalid");
  static const merchantNameAlternateLanguageRequired = ErrorCode(39, "Merchant Name Alternate Language cannot be null or empty");
  static const merchantNameAlternateLanguageLengthInvalid = ErrorCode(40, "Merchant Name Alternate Language Length is invalid");
  static const merchantCityAlternateLanguageLengthInvalid = ErrorCode(41, "Merchant City Alternate Language Length is invalid");
  static const purposeOfTransactionLengthInvalid = ErrorCode(42, "Purpose of Transaction Length is invalid");
  static const upiAccountInformationLengthInvalid = ErrorCode(43, "Upi Account Information Length is invalid");
  static const upiAccountInformationInvalidCurrency = ErrorCode(44, "Upi Account Information Length does not accept USD");
  static const expirationTimestampRequired = ErrorCode(45, "Expiration timestamp is required for dynamic KHQR");
  static const khqrExpired = ErrorCode(46, "This dynamic KHQR has expired");
  static const invalidDynamicKhqr = ErrorCode(47, "This dynamic KHQR has invalid field transaction amount");
  static const pointOfInitiationMethodInvalid = ErrorCode(48, "Point of Initiation Method is invalid");
  static const expirationTimestampLengthInvalid = ErrorCode(49, "Expiration timestamp length is invalid");
  static const expirationTimestampInThePast = ErrorCode(50, "Expiration timestamp is in the past");
  static const invalidMerchantCategoryCode = ErrorCode(51, "Invalid merchant category code");

  @override
  String toString() => 'ErrorCode($code, $message)';
}
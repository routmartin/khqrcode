import '../models/tag_length_string.dart';
import '../constants/error_codes.dart';
import '../constants/emv.dart';
import '../models/response.dart';

class LanguagePreference extends TagLengthString {
  LanguagePreference(String tag, String value) : super(tag, value) {
    if (value.length > EMV.invalidLength['languagePreference']! || value.isEmpty) {
      throw KHQRResponse.error(ErrorCode.languagePreferenceLengthInvalid);
    }
  }
}

class MerchantNameAlternateLanguage extends TagLengthString {
  MerchantNameAlternateLanguage(String tag, String value) : super(tag, value) {
    if (value.length > EMV.invalidLength['merchantNameAlternateLanguage']! || value.isEmpty) {
      throw KHQRResponse.error(ErrorCode.merchantNameAlternateLanguageLengthInvalid);
    }
  }
}

class MerchantCityAlternateLanguage extends TagLengthString {
  MerchantCityAlternateLanguage(String tag, String value) : super(tag, value) {
    if (value.length > EMV.invalidLength['merchantCityAlternateLanguage']! || value.isEmpty) {
      throw KHQRResponse.error(ErrorCode.merchantCityAlternateLanguageLengthInvalid);
    }
  }
}

class MerchantInformationLanguageTemplate extends TagLengthString {
  final LanguagePreference? languagePreference;
  final MerchantNameAlternateLanguage? merchantNameAlternateLanguage;
  final MerchantCityAlternateLanguage? merchantCityAlternateLanguage;
  final Map<String, dynamic> data;

  MerchantInformationLanguageTemplate(String tag, Map<String, dynamic>? value)
      : languagePreference = value?['languagePreference'] != null
            ? LanguagePreference(EMV.languagePreference, value!['languagePreference'])
            : null,
        merchantNameAlternateLanguage = value?['merchantNameAlternateLanguage'] != null
            ? MerchantNameAlternateLanguage(EMV.merchantNameAlternateLanguage, value!['merchantNameAlternateLanguage'])
            : null,
        merchantCityAlternateLanguage = value?['merchantCityAlternateLanguage'] != null
            ? MerchantCityAlternateLanguage(EMV.merchantCityAlternateLanguage, value!['merchantCityAlternateLanguage'])
            : null,
        data = value ?? {},
        super(tag, _buildLanguageTemplateString(value)) {
    
    // Validation: if languagePreference is provided, merchantNameAlternateLanguage is required
    if (value != null && 
        value['languagePreference'] != null && 
        value['merchantNameAlternateLanguage'] == null) {
      throw KHQRResponse.error(ErrorCode.merchantNameAlternateLanguageRequired);
    }
  }

  static String _buildLanguageTemplateString(Map<String, dynamic>? value) {
    if (value == null) return '';
    
    String languageTemplateString = '';
    
    // Add language preference first (if merchantNameAlternateLanguage exists)
    if (value['merchantNameAlternateLanguage'] != null) {
      final preference = LanguagePreference(
        EMV.languagePreference, 
        value['languagePreference'] ?? 'en'
      );
      languageTemplateString += preference.toString();
    }
    
    if (value['merchantNameAlternateLanguage'] != null) {
      final alterName = MerchantNameAlternateLanguage(
        EMV.merchantNameAlternateLanguage, 
        value['merchantNameAlternateLanguage']
      );
      languageTemplateString += alterName.toString();
    }
    
    if (value['merchantCityAlternateLanguage'] != null) {
      final alterCity = MerchantCityAlternateLanguage(
        EMV.merchantCityAlternateLanguage, 
        value['merchantCityAlternateLanguage']
      );
      languageTemplateString += alterCity.toString();
    }
    
    return languageTemplateString;
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/information.dart';
import 'models/response.dart';
import 'models/crc_validation.dart';
import 'constants/khqr_data.dart';
import 'constants/error_codes.dart';
import 'constants/emv.dart';
import 'helpers/crc16.dart';

import 'helpers/source_info.dart';
import 'controllers/generate_khqr.dart';
import 'controllers/decode_khqr.dart';
import 'models/decoded_qr_data.dart';

class BakongKHQR {
  /// Generate Individual QR
  ///
  /// Example:
  /// ```dart
  /// final individualInfo = IndividualInfo(
  ///   bakongAccountId: 'devit@abaa',
  ///   merchantName: 'devit',
  ///   merchantCity: 'Battambang',
  ///   currency: KHQRData.currency['khr']!,
  /// );
  ///
  /// final bakongKhqr = BakongKHQR();
  /// final result = bakongKhqr.generateIndividual(individualInfo);
  /// ```
  KHQRResponse<KHQRData> generateIndividual(IndividualInfo individualInfo) {
    try {
      final khqr = GenerateKHQR.generate(individualInfo, KHQRDataConst.merchantType['individual']!);

      if (khqr is KHQRResponse) {
        return khqr as KHQRResponse<KHQRData>;
      }

      final result = KHQRData(khqr as String);
      return KHQRResponse.success(result);
    } catch (e) {
      if (e is KHQRResponse) {
        return e as KHQRResponse<KHQRData>;
      }
      return KHQRResponse.error(ErrorCode.khqrInvalid);
    }
  }

  /// Generate Merchant QR
  ///
  /// Example:
  /// ```dart
  /// final merchantInfo = MerchantInfo(
  ///   bakongAccountId: 'merchant@bank',
  ///   merchantName: 'My Store',
  ///   merchantCity: 'Phnom Penh',
  ///   merchantId: 'MERCHANT123',
  ///   acquiringBankName: 'Bank Name',
  ///   currency: KHQRData.currency['usd']!,
  /// );
  ///
  /// final bakongKhqr = BakongKHQR();
  /// final result = bakongKhqr.generateMerchant(merchantInfo);
  /// ```
  KHQRResponse<KHQRData> generateMerchant(MerchantInfo merchantInfo) {
    try {
      final khqr = GenerateKHQR.generate(merchantInfo, KHQRDataConst.merchantType['merchant']!);

      if (khqr is KHQRResponse) {
        return khqr as KHQRResponse<KHQRData>;
      }

      final result = KHQRData(khqr as String);
      return KHQRResponse.success(result);
    } catch (e) {
      if (e is KHQRResponse) {
        return e as KHQRResponse<KHQRData>;
      }
      return KHQRResponse.error(ErrorCode.khqrInvalid);
    }
  }

  /// Decode KHQR string
  ///
  /// Example:
  /// ```dart
  /// final decodedResult = BakongKHQR.decode(khqrString);
  /// if (decodedResult.isSuccess) {
  ///   print('Decoded data: ${decodedResult.data}');
  /// }
  /// ```
  static KHQRResponse<DecodedQrData> decode(String khqrString) {
    try {
      final decodedData = DecodeKHQR.decode(khqrString);
      return KHQRResponse.success(decodedData);
    } catch (e) {
      if (e is KHQRResponse) {
        return e as KHQRResponse<DecodedQrData>;
      }
      return KHQRResponse.error(ErrorCode.khqrInvalid);
    }
  }

  /// Decode non-KHQR string (generic QR codes)
  ///
  /// Example:
  /// ```dart
  /// final decodedResult = BakongKHQR.decodeNonKhqr(qrString);
  /// ```
  static KHQRResponse<Map<String, dynamic>> decodeNonKhqr(String qrString) {
    try {
      final decodedData = DecodeKHQR.decodeNonKhqr(qrString);
      return KHQRResponse.success(decodedData);
    } catch (e) {
      return KHQRResponse.error(ErrorCode.khqrInvalid);
    }
  }

  /// Verify KHQR string
  ///
  /// Example:
  /// ```dart
  /// final verification = BakongKHQR.verify(khqrString);
  /// if (verification.isValid) {
  ///   print('KHQR is valid');
  /// }
  /// ```
  static CRCValidation verify(String khqrString) {
    final isCorrectFormCRC = _checkCRCRegExp(khqrString);
    if (!isCorrectFormCRC) return CRCValidation(false);

    final crc = khqrString.substring(khqrString.length - 4);
    final khqrNoCrc = khqrString.substring(0, khqrString.length - 4);
    final validCRC = CRC16.calculate(khqrNoCrc) == crc.toUpperCase();

    if (!validCRC || khqrString.length < EMV.invalidLength['khqr']!) {
      return CRCValidation(false);
    }

    try {
      DecodeKHQR.decodeValidation(khqrString);
      return CRCValidation(true);
    } catch (e) {
      return CRCValidation(false);
    }
  }

  /// Generate Deep Link
  ///
  /// Example:
  /// ```dart
  /// final deepLinkResult = await BakongKHQR.generateDeepLink(
  ///   'https://api.example.com/v1/generate_deeplink_by_qr',
  ///   khqrString,
  ///   sourceInfo, // optional
  /// );
  /// ```
  static Future<KHQRResponse<KHQRDeepLinkData>> generateDeepLink(
    String url,
    String qr, [
    SourceInfo? sourceInfo,
  ]) async {
    // Check invalid URL
    if (!_isValidLink(url)) {
      return KHQRResponse.error(ErrorCode.invalidDeepLinkUrl);
    }

    // Check QR is valid (CRC)
    final isValidKHQR = verify(qr);
    if (!isValidKHQR.isValid) {
      return KHQRResponse.error(ErrorCode.khqrInvalid);
    }

    // Check data source field
    if (sourceInfo != null) {
      if (sourceInfo.appIconUrl == null || sourceInfo.appName == null || sourceInfo.appDeepLinkCallback == null) {
        return KHQRResponse.error(ErrorCode.invalidDeepLinkSourceInfo);
      }
    }

    try {
      final data = await _callDeepLinkAPI(url, {'qr': qr});
      final deepLinkData = KHQRDeepLinkData(data['data']['shortLink']);
      return KHQRResponse.success(deepLinkData);
    } catch (e) {
      return KHQRResponse.error(ErrorCode.connectionTimeout);
    }
  }

  /// Check if Bakong Account exists
  ///
  /// Example:
  /// ```dart
  /// final accountCheck = await BakongKHQR.checkBakongAccount(
  ///   'https://api-bakong.nbc.gov.kh/v1/check_account_by_id',
  ///   'user@bank',
  /// );
  /// ```
  static Future<KHQRResponse<Map<String, dynamic>>> checkBakongAccount(String url, String bakongId) async {
    try {
      if (bakongId.length > EMV.invalidLength['bakongAccount']!) {
        return KHQRResponse.error(ErrorCode.bakongAccountIdLengthInvalid);
      }

      if (bakongId.split('@').length != 2) {
        return KHQRResponse.error(ErrorCode.bakongAccountIdInvalid);
      }

      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'accountId': bakongId}),
          )
          .timeout(const Duration(seconds: 45));

      final respData = json.decode(response.body) as Map<String, dynamic>;
      final responseCode = respData['responseCode'];
      final error = respData['errorCode'];

      if (error == 11) {
        return KHQRResponse.success({'bakongAccountExisted': false});
      }
      if (error == 12) {
        return KHQRResponse.error(ErrorCode.bakongAccountIdInvalid);
      }

      if (responseCode == 0) {
        return KHQRResponse.success({'bakongAccountExisted': true});
      } else {
        return KHQRResponse.success({'bakongAccountExisted': false});
      }
    } catch (e) {
      return KHQRResponse.error(ErrorCode.connectionTimeout);
    }
  }

  static bool _checkCRCRegExp(String crc) {
    final crcRegExp = RegExp(r'6304[A-Fa-f0-9]{4}$');
    return crcRegExp.hasMatch(crc);
  }

  static bool _isValidLink(String link) {
    try {
      final uri = Uri.parse(link);
      return uri.path == '/v1/generate_deeplink_by_qr';
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> _callDeepLinkAPI(String url, Map<String, dynamic> data) async {
    final response = await http
        .post(Uri.parse(url), headers: {'Content-Type': 'application/json'}, body: json.encode(data))
        .timeout(const Duration(seconds: 45));

    final respBody = json.decode(response.body) as Map<String, dynamic>;
    final error = respBody['errorCode'];

    if (error == 5) {
      throw KHQRResponse.error(ErrorCode.invalidDeepLinkSourceInfo);
    } else if (error == 4) {
      throw KHQRResponse.error(ErrorCode.internalServer);
    }

    return respBody;
  }
}

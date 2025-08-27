import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../constants/error_codes.dart';

class KHQRData {
  final String qr;
  final String md5Hash;

  KHQRData(this.qr) : md5Hash = _generateMd5(qr);

  static String _generateMd5(String input) {
    var bytes = utf8.encode(input);
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  Map<String, dynamic> getData() {
    return {
      'qr': qr,
      'md5': md5Hash,
    };
  }
}

class KHQRDeepLinkData {
  final String shortLink;

  KHQRDeepLinkData(this.shortLink);

  Map<String, dynamic> getData() {
    return {
      'shortLink': shortLink,
    };
  }
}

class KHQRResponse<T> {
  final KHQRStatus status;
  final T? data;

  KHQRResponse(this.data, ErrorCode? errorCode)
      : status = KHQRStatus(
          code: errorCode == null ? 0 : 1,
          errorCode: errorCode?.code,
          message: errorCode?.message,
        );

  KHQRResponse.error(ErrorCode errorCode)
      : status = KHQRStatus(
          code: 1,
          errorCode: errorCode.code,
          message: errorCode.message,
        ),
        data = null;

  KHQRResponse.success(this.data)
      : status = KHQRStatus(
          code: 0,
          errorCode: null,
          message: null,
        );

  bool get isSuccess => status.code == 0;
  bool get isError => status.code == 1;

  Map<String, dynamic> toJson() {
    return {
      'status': status.toJson(),
      'data': data,
    };
  }
}

class KHQRStatus {
  final int code;
  final int? errorCode;
  final String? message;

  KHQRStatus({
    required this.code,
    this.errorCode,
    this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'errorCode': errorCode,
      'message': message,
    };
  }
}
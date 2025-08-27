import '../models/tag_length_string.dart';
import '../constants/error_codes.dart';
import '../constants/emv.dart';
import '../models/response.dart';

class TimeStampMilliSecond extends TagLengthString {
  TimeStampMilliSecond(String tag, int value) : super(tag, value.toString());
}

class TimeStamp extends TagLengthString {
  final TimeStampMilliSecond? createdTimestamp;
  final TimeStampMilliSecond? expiredTimestamp;

  TimeStamp(String tag, Map<String, dynamic>? timestamp, String? poi)
      : createdTimestamp = timestamp?['creationTimestamp'] != null
            ? TimeStampMilliSecond(EMV.creationTimestamp, timestamp!['creationTimestamp'])
            : null,
        expiredTimestamp = timestamp?['expirationTimestamp'] != null
            ? TimeStampMilliSecond(EMV.expirationTimestamp, timestamp!['expirationTimestamp'])
            : null,
        super(tag, _buildTimestampString(timestamp, poi)) {
    
    if (timestamp == null) return;
    
    final creationTimestamp = timestamp['creationTimestamp'];
    final expirationTimestamp = timestamp['expirationTimestamp'];
    
    if (poi == EMV.dynamicQR) {
      // Dynamic QR validation
      if (expirationTimestamp == null) {
        throw KHQRResponse.error(ErrorCode.expirationTimestampRequired);
      }
      
      if (expirationTimestamp.toString().length != EMV.invalidLength['timestamp']) {
        throw KHQRResponse.error(ErrorCode.expirationTimestampLengthInvalid);
      }
      
      // Check if expiration timestamp is a valid date
      try {
        final expirationDate = DateTime.fromMillisecondsSinceEpoch(expirationTimestamp);
        if (expirationDate.millisecondsSinceEpoch.isNaN) {
          throw KHQRResponse.error(ErrorCode.invalidDynamicKhqr);
        }
      } catch (e) {
        throw KHQRResponse.error(ErrorCode.invalidDynamicKhqr);
      }
      
      // Check if expiration is in the past compared to creation
      if (creationTimestamp != null && expirationTimestamp < creationTimestamp) {
        throw KHQRResponse.error(ErrorCode.expirationTimestampInThePast);
      }
      
      // Check if QR has expired
      if (expirationTimestamp < DateTime.now().millisecondsSinceEpoch) {
        throw KHQRResponse.error(ErrorCode.khqrExpired);
      }
    }
  }

  static String _buildTimestampString(Map<String, dynamic>? timestamp, String? poi) {
    if (timestamp == null) return '';
    
    String timestampString = '';
    
    if (timestamp['creationTimestamp'] != null) {
      final createdTimestamp = TimeStampMilliSecond(
        EMV.creationTimestamp, 
        timestamp['creationTimestamp']
      );
      timestampString += createdTimestamp.toString();
    }
    
    if (timestamp['expirationTimestamp'] != null) {
      final expiredTimestamp = TimeStampMilliSecond(
        EMV.expirationTimestamp, 
        timestamp['expirationTimestamp']
      );
      timestampString += expiredTimestamp.toString();
    }
    
    return timestampString;
  }
}
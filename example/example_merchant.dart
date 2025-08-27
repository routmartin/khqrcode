import '../lib/khqrcode.dart';

void main() async {
  // Example 1: Generate Individual QR
  final individualInfo = MerchantInfo(
    acquiringBankName: "YOUR BANK",
    merchantId: "234234234",
    bakongAccountId: 'receivekhqr@yourbank',
    merchantName: 'FLick Coffee',
    expirationTimestamp: DateTime.now().add(Duration(minutes: 15)).millisecondsSinceEpoch,
    merchantCity: 'Phnom Penh',
    currency: KHQRDataConst.currency['khr']!,
    amount: 1,
  );

  final bakongKhqr = BakongKHQR();
  final individualResult = bakongKhqr.generateMerchant(individualInfo);

  if (individualResult.isSuccess) {
    print('generateMerchant QR: ${individualResult.data!.qr}');
    print('MD5: ${individualResult.data!.md5Hash}');
  } else {
    print('Error: ${individualResult.status.message}');
  }

  var qr = individualResult.data!.qr;

  var verification = BakongKHQR.verify(qr);
  if (verification.isValid) {
    print("qr is valid");
  } else {
    print("qr is not valid");
  }

  var decodedData = BakongKHQR.decode(qr);
  if (decodedData.isSuccess) {
    print('Decoded data: ${decodedData.data!.toJson()}');
  }
}

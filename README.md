# KHQR Code

A Dart/Flutter library for generating and decoding KHQR (Cambodia QR Code Payment) codes for the Bakong payment system.

## Features

- Generate KHQR codes for individual payments
- Generate KHQR codes for merchant payments
- Decode existing KHQR codes
- Verify KHQR code validity
- Support for both USD and KHR currencies
- Compatible with Cambodia's Bakong payment system

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  khqrcode: ^1.0.0
```

Then run:

```bash
dart pub get
```

## Usage

### Generating Individual QR Code

```dart
import 'package:khqrcode/khqrcode.dart';

final individualInfo = IndividualInfo(
  bakongAccountId: 'receivekhqr@dvpy',
  accountInformation: "021550815",
  merchantName: 'M Sovan',
  acquiringBank: 'DVPAY',
  expirationTimestamp: DateTime.now().add(Duration(minutes: 15)).millisecondsSinceEpoch,
  merchantCity: 'Phnom Penh',
  currency: KHQRDataConst.currency['khr']!,
  amount: 1,
);

final bakongKhqr = BakongKHQR();
final result = bakongKhqr.generateIndividual(individualInfo);

if (result.isSuccess) {
  print('QR Code: ${result.data!.qr}');
  print('MD5: ${result.data!.md5Hash}');
}
```

### Generating Merchant QR Code

```dart
final merchantInfo = MerchantInfo(
  acquiringBankName: "DVPAY",
  merchantId: "234234234",
  bakongAccountId: 'receivekhqr@dvpy',
  merchantName: 'FLick Coffee',
  merchantCity: 'Phnom Penh',
  currency: KHQRDataConst.currency['khr']!,
  amount: 1,
);

final result = bakongKhqr.generateMerchant(merchantInfo);
```

### Decoding and Verifying QR Code

```dart
// Verify QR code
var verification = BakongKHQR.verify(qrString);
if (verification.isValid) {
  print("QR is valid");
}

// Decode QR code
var decodedData = BakongKHQR.decode(qrString);
if (decodedData.isSuccess) {
  print('Decoded data: ${decodedData.data!.toJson()}');
}
```

## Additional information

This library implements the KHQR specification for Cambodia's Bakong payment system. For more information about KHQR, visit the official Bakong documentation.

### Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Issues

If you encounter any issues, please file them on the [GitHub repository](https://github.com/yourusername/khqrcode/issues).

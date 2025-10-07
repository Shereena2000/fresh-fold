import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/payment_model.dart' show PaymentModel, PaymentMethod, UpiApp;

class PaymentViewModel extends ChangeNotifier {
  PaymentModel _paymentModel = PaymentModel(totalAmount: 1);

  PaymentModel get paymentModel => _paymentModel;

  void selectPaymentMethod(PaymentMethod method) {
    _paymentModel = _paymentModel.copyWith(
      selectedMethod: method,
      showUpiOptions: method == PaymentMethod.upi,
      clearUpiApp: method != PaymentMethod.upi,
    );
    notifyListeners();
  }

  void selectUpiApp(UpiApp app) {
    _paymentModel = _paymentModel.copyWith(selectedUpiApp: app);
    notifyListeners();
  }

  Future<void> launchUpiApp(UpiApp app) async {
    String upiUrl = '';
    String packageName = '';

    switch (app) {
      case UpiApp.googlePay:
        packageName = 'com.google.android.apps.nbu.paisa.user';
        //upiUrl='test@upi';
       upiUrl = 'tez://upi/pay?pa=merchant@upi&pn=FreshFold&am=1&cu=INR';
        break;
      case UpiApp.phonePe:
        packageName = 'com.phonepe.app';
       upiUrl = 'phonepe://pay?pa=merchant@upi&pn=FreshFold&am=1&cu=INR';
        break;
      case UpiApp.paytm:
        packageName = 'net.one97.paytm';
        upiUrl = 'paytmmp://pay?pa=merchant@upi&pn=FreshFold&am=1&cu=INR';
        break;
    }

    try {
      final Uri uri = Uri.parse(upiUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to generic UPI intent
        final Uri fallbackUri = Uri.parse(
          'upi://pay?pa=merchant@upi&pn=FreshFold&am=350&cu=INR',
        );
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching UPI app: $e');
    }
  }

  Future<void> processPayment(BuildContext context) async {
    if (_paymentModel.selectedMethod == PaymentMethod.upi) {
      if (_paymentModel.selectedUpiApp != null) {
        await launchUpiApp(_paymentModel.selectedUpiApp!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a UPI app')),
        );
      }
    } else if (_paymentModel.selectedMethod == PaymentMethod.card) {
      // Navigate to card payment screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card payment not implemented')),
      );
    } else {
      // Cash on delivery
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed with Cash on Delivery')),
      );
    }
  }

  String getUpiAppName(UpiApp app) {
    switch (app) {
      case UpiApp.googlePay:
        return 'Google Pay';
      case UpiApp.phonePe:
        return 'PhonePe';
      case UpiApp.paytm:
        return 'Paytm';
    }
  }

  IconData getUpiAppIcon(UpiApp app) {
    switch (app) {
      case UpiApp.googlePay:
        return Icons.g_mobiledata;
      case UpiApp.phonePe:
        return Icons.phone_android;
      case UpiApp.paytm:
        return Icons.payment;
    }
  }
}

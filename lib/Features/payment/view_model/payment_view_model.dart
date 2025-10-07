import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../model/payment_model.dart';

class PaymentViewModel extends ChangeNotifier {
  PaymentModel _paymentModel = PaymentModel(totalAmount: 1);
  late Razorpay _razorpay;
  bool _isInitialized = false;

  PaymentModel get paymentModel => _paymentModel;
  
  // Available UPI apps (all supported by Razorpay)
  List<UpiAppType> get availableApps => UpiAppType.values;

  PaymentViewModel() {
    _initRazorpay();
  }

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _isInitialized = true;
  }

  void selectPaymentMethod(PaymentMethod method) {
    _paymentModel = _paymentModel.copyWith(
      selectedMethod: method,
      showUpiOptions: method == PaymentMethod.upi,
      clearUpiApp: method != PaymentMethod.upi,
    );
    notifyListeners();
  }

  void selectUpiApp(UpiAppType app) {
    _paymentModel = _paymentModel.copyWith(selectedUpiApp: app);
    notifyListeners();
  }

  Future<void> launchUpiApp(UpiAppType appType, BuildContext context) async {
    if (!_isInitialized) {
      _showError(context, 'Payment system not initialized');
      return;
    }

    try {
      final amount = _paymentModel.totalAmount;
      
      var options = {
        'key': 'rzp_test_1DP5mmOlF5G5ag', // Replace with your Razorpay API key
        'amount': (amount * 100).toInt(), // Amount in paise (₹1 = 100 paise)
        'name': 'FreshFold',
        'description': 'Payment for FreshFold Services',
        'prefill': {
          'contact': '9876543210', // Optional: Customer phone
          'email': 'customer@freshfold.com' // Optional: Customer email
        },
        'method': _getUpiMethod(appType),
        'theme': {
          'color': '#3399cc'
        }
      };

      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error initiating UPI payment: $e');
      if (context.mounted) {
        _showError(context, 'Payment failed: ${e.toString()}');
      }
    }
  }

  Map<String, dynamic> _getUpiMethod(UpiAppType appType) {
    // Razorpay will automatically open the selected UPI app
    String wallet = '';
    switch (appType) {
      case UpiAppType.googlePay:
        wallet = 'gpay';
        break;
      case UpiAppType.phonePe:
        wallet = 'phonepe';
        break;
      case UpiAppType.paytm:
        wallet = 'paytm';
        break;
    }
    
    return {
      'wallet': wallet,
    };
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Payment Success: ${response.paymentId}');
    
    _saveTransaction(
      transactionId: response.paymentId ?? 'N/A',
      amount: _paymentModel.totalAmount,
      status: 'Success',
      paymentMethod: 'UPI - ${getUpiAppName(_paymentModel.selectedUpiApp!)}',
    );

    // You can navigate or show success message here
    // Note: Context is not available here, handle in UI layer
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Payment Error: ${response.code} - ${response.message}');
    
    _saveTransaction(
      transactionId: 'FAILED_${DateTime.now().millisecondsSinceEpoch}',
      amount: _paymentModel.totalAmount,
      status: 'Failed',
      paymentMethod: 'UPI - ${getUpiAppName(_paymentModel.selectedUpiApp ?? UpiAppType.googlePay)}',
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
  }

  void _saveTransaction({
    required String transactionId,
    required double amount,
    required String status,
    required String paymentMethod,
  }) {
    // TODO: Implement database storage (Hive/SQLite/Firebase)
    debugPrint('═══════════════════════════════════');
    debugPrint('Transaction Saved:');
    debugPrint('ID: $transactionId');
    debugPrint('Amount: ₹$amount');
    debugPrint('Status: $status');
    debugPrint('Method: $paymentMethod');
    debugPrint('Date: ${DateTime.now()}');
    debugPrint('═══════════════════════════════════');
  }

  Future<void> processPayment(BuildContext context) async {
    if (_paymentModel.selectedMethod == PaymentMethod.upi) {
      if (_paymentModel.selectedUpiApp != null) {
        await launchUpiApp(_paymentModel.selectedUpiApp!, context);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a UPI app first'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } else if (_paymentModel.selectedMethod == PaymentMethod.card) {
      // Razorpay supports cards too
      _openRazorpayForCard();
    } else {
      // Cash on Delivery
      if (context.mounted) {
        _saveTransaction(
          transactionId: 'COD${DateTime.now().millisecondsSinceEpoch}',
          amount: _paymentModel.totalAmount,
          status: 'Pending',
          paymentMethod: 'Cash on Delivery',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed with Cash on Delivery ✓'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) {
            Navigator.pop(context);
          }
        });
      }
    }
  }

  void _openRazorpayForCard() {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': (_paymentModel.totalAmount * 100).toInt(),
      'name': 'FreshFold',
      'description': 'Payment for FreshFold Services',
      'prefill': {
        'contact': '9876543210',
        'email': 'customer@freshfold.com'
      },
    };
    _razorpay.open(options);
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String getUpiAppName(UpiAppType app) {
    switch (app) {
      case UpiAppType.googlePay:
        return 'Google Pay';
      case UpiAppType.phonePe:
        return 'PhonePe';
      case UpiAppType.paytm:
        return 'Paytm';
    }
  }

  IconData getUpiAppIcon(UpiAppType app) {
    switch (app) {
      case UpiAppType.googlePay:
        return Icons.g_mobiledata;
      case UpiAppType.phonePe:
        return Icons.phone_android;
      case UpiAppType.paytm:
        return Icons.payment;
    }
  }
  
  void updateTotalAmount(double amount) {
    _paymentModel = _paymentModel.copyWith(totalAmount: amount);
    notifyListeners();
  }
  
  bool isUpiAppAvailable(UpiAppType appType) {
    // Razorpay handles availability internally
    return true;
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
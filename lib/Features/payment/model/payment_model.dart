enum PaymentMethod { upi, card, cod }

enum UpiApp { googlePay, phonePe, paytm }

class PaymentModel {
  final double totalAmount;
  final PaymentMethod selectedMethod;
  final UpiApp? selectedUpiApp;
  final bool showUpiOptions;

  PaymentModel({
    required this.totalAmount,
    this.selectedMethod = PaymentMethod.upi,
    this.selectedUpiApp,
    this.showUpiOptions = false,
  });

  PaymentModel copyWith({
    double? totalAmount,
    PaymentMethod? selectedMethod,
    UpiApp? selectedUpiApp,
    bool? showUpiOptions,
    bool clearUpiApp = false,
  }) {
    return PaymentModel(
      totalAmount: totalAmount ?? this.totalAmount,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      selectedUpiApp: clearUpiApp ? null : (selectedUpiApp ?? this.selectedUpiApp),
      showUpiOptions: showUpiOptions ?? this.showUpiOptions,
    );
  }
}

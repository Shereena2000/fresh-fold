enum PaymentMethod { upi, card, cod }

// Renamed to avoid conflict with upi_india package
enum UpiAppType { googlePay, phonePe, paytm }

class PaymentModel {
  final double totalAmount;
  final PaymentMethod selectedMethod;
  final UpiAppType? selectedUpiApp;
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
    UpiAppType? selectedUpiApp,
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
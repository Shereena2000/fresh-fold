class PhoneAuthModel {
  final String phoneNumber;
  final String verificationId;
  final int? resendToken;

  PhoneAuthModel({
    required this.phoneNumber,
    required this.verificationId,
    this.resendToken,
  });

  PhoneAuthModel copyWith({
    String? phoneNumber,
    String? verificationId,
    int? resendToken,
  }) {
    return PhoneAuthModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      verificationId: verificationId ?? this.verificationId,
      resendToken: resendToken ?? this.resendToken,
    );
  }
}
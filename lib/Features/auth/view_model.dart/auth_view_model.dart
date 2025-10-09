import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/phone_auth_model.dart';
import '../model/user_model.dart';
import '../repositories/auth_repositories.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool _isLoading = false;
  String? _errorMessage;
  PhoneAuthModel? _phoneAuthModel;
  UserModel? _currentUser;
  int _resendTimer = 60;
  Timer? _timer;
  bool _canResend = false;

  // Password visibility toggles
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool get isLoading => _isLoading;
  String? get error => _errorMessage;
  String? get errorMessage => _errorMessage;
  PhoneAuthModel? get phoneAuthModel => _phoneAuthModel;
  UserModel? get currentUser => _currentUser;
  int get resendTimer => _resendTimer;
  bool get canResend => _canResend;
  bool get isAuthenticated => _repository.getCurrentFirebaseUser() != null;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  // Controllers for phone auth
  final TextEditingController phoneController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  // Controllers for email auth
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Controllers for profile
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    locationController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  // ==================== PASSWORD VISIBILITY TOGGLES ====================

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  // ==================== EMAIL/PASSWORD AUTHENTICATION ====================

  /// Sign in with email and password
  Future<bool> signIn() async {
    if (emailController.text.isEmpty) {
      _errorMessage = 'Please enter your email';
      notifyListeners();
      return false;
    }

    if (passwordController.text.isEmpty) {
      _errorMessage = 'Please enter your password';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      UserCredential userCredential = await _repository.signInWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      String uid = userCredential.user!.uid;
      await loadUserData(uid);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign up with email and password
  Future<bool> signUp() async {
    // Validate username
    if (usernameController.text.isEmpty) {
      _errorMessage = 'Please enter a username';
      notifyListeners();
      return false;
    }

    // Validate email
    if (emailController.text.isEmpty) {
      _errorMessage = 'Please enter your email';
      notifyListeners();
      return false;
    }

    if (!_isValidEmail(emailController.text)) {
      _errorMessage = 'Please enter a valid email address';
      notifyListeners();
      return false;
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      _errorMessage = 'Please enter a password';
      notifyListeners();
      return false;
    }

    if (passwordController.text.length < 6) {
      _errorMessage = 'Password must be at least 6 characters';
      notifyListeners();
      return false;
    }

    // Validate confirm password
    if (confirmPasswordController.text.isEmpty) {
      _errorMessage = 'Please confirm your password';
      notifyListeners();
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _errorMessage = 'Passwords do not match';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Create user account
      UserCredential userCredential = await _repository.signUpWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      String uid = userCredential.user!.uid;

      // Save user data to Firestore
      await _repository.registerUserWithEmail(
        uid: uid,
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
      );

      // Send verification email
      await _repository.sendEmailVerification();

      // Load user data
      await loadUserData(uid);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    print('🔐 Attempting to send password reset email to: $email');
    
    if (email.isEmpty) {
      _errorMessage = 'Please enter your email address';
      notifyListeners();
      return false;
    }

    if (!_isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email address';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('📧 Sending password reset email...');
      await _repository.sendPasswordResetEmail(email);
      print('✅ Password reset email sent successfully');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Failed to send password reset email: $e');
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // ==================== INITIALIZATION & USER DATA ====================

  Future<void> initialize() async {
    User? firebaseUser = _repository.getCurrentFirebaseUser();
    if (firebaseUser != null) {
      await loadUserData(firebaseUser.uid);
    }
  }

  Future<void> loadUserData(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _repository.getUserData(uid);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== PHONE AUTHENTICATION ====================

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = 60;
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        _resendTimer--;
        notifyListeners();
      } else {
        _canResend = true;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  Future<bool> sendOTP() async {
    if (phoneController.text.isEmpty) {
      _errorMessage = 'Please enter your mobile number';
      notifyListeners();
      return false;
    }

    // Check if it has exactly 10 digits
    String cleanPhone = phoneController.text.trim().replaceAll(' ', '');
    if (cleanPhone.length != 10 || !RegExp(r'^\d{10}$').hasMatch(cleanPhone)) {
      _errorMessage = 'Mobile number must be exactly 10 digits';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    String phoneNumber = '+91${phoneController.text.trim()}';

    try {
      bool success = false;
      await _repository.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        forceResendingToken: _phoneAuthModel?.resendToken,
        onCodeSent: (verificationId, resendToken) {
          _phoneAuthModel = PhoneAuthModel(
            phoneNumber: phoneNumber,
            verificationId: verificationId,
            resendToken: resendToken,
          );
          _isLoading = false;
          _startResendTimer();
          success = true;
          notifyListeners();
        },
        onError: (error) {
          _errorMessage = error;
          _isLoading = false;
          success = false;
          notifyListeners();
        },
        onAutoVerify: (credential) async {
          await _handleSuccessfulAuth(credential);
          success = true;
        },
      );
      return success;
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resendOTP() async {
    if (!_canResend || _phoneAuthModel == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      bool success = false;
      await _repository.verifyPhoneNumber(
        phoneNumber: _phoneAuthModel!.phoneNumber,
        forceResendingToken: _phoneAuthModel!.resendToken,
        onCodeSent: (verificationId, resendToken) {
          _phoneAuthModel = _phoneAuthModel!.copyWith(
            verificationId: verificationId,
            resendToken: resendToken,
          );
          _isLoading = false;
          _startResendTimer();
          success = true;
          notifyListeners();
        },
        onError: (error) {
          _errorMessage = error;
          _isLoading = false;
          success = false;
          notifyListeners();
        },
        onAutoVerify: (credential) async {
          await _handleSuccessfulAuth(credential);
          success = true;
        },
      );
      return success;
    } catch (e) {
      _errorMessage = 'Failed to resend OTP. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<String?> verifyOTP() async {
    String otp = otpControllers.map((c) => c.text).join();

    if (otp.length != 6) {
      _errorMessage = 'Please enter complete OTP';
      notifyListeners();
      return null;
    }

    if (_phoneAuthModel == null) {
      _errorMessage = 'Verification ID not found. Please resend OTP.';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      UserCredential userCredential = await _repository.verifyOTP(
        verificationId: _phoneAuthModel!.verificationId,
        otp: otp,
      );

      String uid = userCredential.user!.uid;

      await loadUserData(uid);

      _isLoading = false;
      notifyListeners();

      if (_currentUser == null || !_currentUser!.isRegistered) {
        phoneController.text = _phoneAuthModel!.phoneNumber.substring(3);
        return 'registration';
      } else {
        return 'wrapper';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        _errorMessage = 'Invalid OTP. Please try again.';
      } else {
        _errorMessage = e.message ?? 'Verification failed.';
      }
      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<String?> _handleSuccessfulAuth(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential =
          await _repository.signInWithCredential(credential);
      String uid = userCredential.user!.uid;

      await loadUserData(uid);

      _isLoading = false;
      notifyListeners();

      if (_currentUser == null || !_currentUser!.isRegistered) {
        return 'registration';
      } else {
        return 'wrapper';
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> registerUser() async {
    // Validate phone number - check if not empty and has 10 digits
    if (phoneController.text.isEmpty) {
      _errorMessage = 'Please enter your mobile number';
      notifyListeners();
      return false;
    }

    // Remove any spaces and check if it has exactly 10 digits
    String cleanPhone = phoneController.text.trim().replaceAll(' ', '');
    if (cleanPhone.length != 10 || !RegExp(r'^\d{10}$').hasMatch(cleanPhone)) {
      _errorMessage = 'Mobile number must be exactly 10 digits';
      notifyListeners();
      return false;
    }

    if (locationController.text.isEmpty) {
      _errorMessage = 'Please enter your location';
      notifyListeners();
      return false;
    }

    User? firebaseUser = _repository.getCurrentFirebaseUser();
    if (firebaseUser == null) {
      _errorMessage = 'User not authenticated';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.registerUser(
        uid: firebaseUser.uid,
        phoneNumber: firebaseUser.phoneNumber ?? phoneController.text,
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        location: locationController.text.trim(),
      );

      await loadUserData(firebaseUser.uid);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Registration failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<String> checkAuthStatus() async {
    User? firebaseUser = _repository.getCurrentFirebaseUser();

    if (firebaseUser == null) {
      return 'onboarding';
    }

    await loadUserData(firebaseUser.uid);

    if (_currentUser == null || !_currentUser!.isRegistered) {
      return 'registration';
    }

    return 'wrapper';
  }



  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }



  // Add these methods to your existing AuthViewModel

/// Update user profile
Future<bool> updateProfile({
  String? fullName,
  String? email,
  String? location,
  String? gender,
  DateTime? dateOfBirth,
  String? profession,
  String? alternativePhone,
}) async {
  User? firebaseUser = _repository.getCurrentFirebaseUser();
  if (firebaseUser == null || _currentUser == null) {
    _errorMessage = 'User not authenticated';
    notifyListeners();
    return false;
  }

  // Validate alternative phone number if provided (not empty)
  if (alternativePhone != null && alternativePhone.trim().isNotEmpty) {
    String cleanPhone = alternativePhone.trim().replaceAll(' ', '');
    if (cleanPhone.length != 10 || !RegExp(r'^\d{10}$').hasMatch(cleanPhone)) {
      _errorMessage = 'Alternative phone number must be exactly 10 digits';
      notifyListeners();
      return false;
    }
  }

  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    UserModel updatedUser = _currentUser!.copyWith(
      fullName: fullName ?? _currentUser!.fullName,
      email: email ?? _currentUser!.email,
      location: location ?? _currentUser!.location,
      gender: gender ?? _currentUser!.gender,
      dateOfBirth: dateOfBirth ?? _currentUser!.dateOfBirth,
      profession: profession ?? _currentUser!.profession,
      alternativePhone: alternativePhone ?? _currentUser!.alternativePhone,
      updatedAt: DateTime.now(),
    );

    await _repository.updateUserProfile(updatedUser);
    _currentUser = updatedUser;

    _isLoading = false;
    notifyListeners();
    return true;
  } catch (e) {
    _errorMessage = 'Failed to update profile: ${e.toString()}';
    _isLoading = false;
    notifyListeners();
    return false;
  }
}

/// Update single field
Future<bool> updateProfileField(String field, dynamic value) async {
  User? firebaseUser = _repository.getCurrentFirebaseUser();
  if (firebaseUser == null) {
    _errorMessage = 'User not authenticated';
    notifyListeners();
    return false;
  }

  try {
    await _repository.updateUserField(firebaseUser.uid, field, value);
    await loadUserData(firebaseUser.uid);
    return true;
  } catch (e) {
    _errorMessage = e.toString();
    notifyListeners();
    return false;
  }
}
// Add this method to AuthViewModel
void prepareRegistrationData() {
  // Pre-fill controllers with existing user data
  if (_currentUser != null) {
    if (_currentUser!.email != null && _currentUser!.email!.isNotEmpty) {
      emailController.text = _currentUser!.email!;
    }
    if (_currentUser!.fullName != null && _currentUser!.fullName!.isNotEmpty) {
      fullNameController.text = _currentUser!.fullName!;
    }
  }
}
// Add these specific clear methods to AuthViewModel

/// Clear login form data
void clearAllData() {
  // Clear all text controllers
  _clearAllControllers();
  
  // Clear other state
  _phoneAuthModel = null;
  _errorMessage = null;
  _isPasswordVisible = false;
  _isConfirmPasswordVisible = false;
  _timer?.cancel();
  _resendTimer = 60;
  _canResend = false;
  _isLoading = false;
  
  notifyListeners();
}

/// Clear all controllers
void _clearAllControllers() {
  phoneController.clear();
  fullNameController.clear();
  emailController.clear();
  locationController.clear();
  usernameController.clear();
  passwordController.clear();
  confirmPasswordController.clear();
  
  // Clear OTP controllers
  for (var controller in otpControllers) {
    controller.clear();
  }
}

/// Clear login-specific data
void clearLoginData() {
  emailController.clear();
  passwordController.clear();
  _errorMessage = null;
  _isPasswordVisible = false;
  notifyListeners();
}

/// Clear signup-specific data  
void clearSignupData() {
  usernameController.clear();
  emailController.clear();
  passwordController.clear();
  confirmPasswordController.clear();
  _errorMessage = null;
  _isPasswordVisible = false;
  _isConfirmPasswordVisible = false;
  notifyListeners();
}

/// Clear registration-specific data
void clearRegistrationData() {
  fullNameController.clear();
  emailController.clear();
  locationController.clear();
  phoneController.clear();
  _errorMessage = null;
  notifyListeners();
}

// Update the signOut method
Future<void> signOut() async {
  await _repository.signOut();
  _currentUser = null;
  clearAllData(); // Use clearAllData instead of clearData
  notifyListeners();
}
}
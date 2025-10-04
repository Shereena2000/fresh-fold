import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentFirebaseUser() {
    return _firebaseAuth.currentUser;
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // ==================== EMAIL/PASSWORD AUTHENTICATION ====================
  
  /// Sign in with email and password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign up with email and password
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  /// Check if email is verified
  bool isEmailVerified() {
    return _firebaseAuth.currentUser?.emailVerified ?? false;
  }

  /// Reload current user to get updated email verification status
  Future<void> reloadUser() async {
    await _firebaseAuth.currentUser?.reload();
  }

  /// Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password is too weak. Use at least 6 characters.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }

  // ==================== PHONE AUTHENTICATION ====================

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(String error) onError,
    required Function(PhoneAuthCredential credential) onAutoVerify,
    int? forceResendingToken,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      forceResendingToken: forceResendingToken,
      verificationCompleted: (PhoneAuthCredential credential) async {
        onAutoVerify(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          onError('The phone number entered is invalid.');
        } else {
          onError(e.message ?? 'Verification failed. Please try again.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<UserCredential> verifyOTP({
    required String verificationId,
    required String otp,
  }) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithCredential(
      PhoneAuthCredential credential) async {
    return await _firebaseAuth.signInWithCredential(credential);
  }

  // ==================== USER DATA MANAGEMENT ====================

  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveUserData(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(
          user.toMap(),
          SetOptions(merge: true),
        );
  }

  Future<void> registerUser({
    required String uid,
    required String phoneNumber,
    required String fullName,
    required String email,
    required String location,
  }) async {
    UserModel user = UserModel(
      uid: uid,
      phoneNumber: phoneNumber,
      fullName: fullName,
      email: email,
      location: location,
      createdAt: DateTime.now(),
    );
    await saveUserData(user);
  }

  /// Register user with email (for email/password auth)
  Future<void> registerUserWithEmail({
    required String uid,
    required String username,
    required String email,
  }) async {
    UserModel user = UserModel(
      uid: uid,
      phoneNumber: '', // Optional for email auth
      fullName: username,
      email: email,
      location: '', // Can be added later in profile
      createdAt: DateTime.now(),
    );
    await saveUserData(user);
  }

  Future<bool> isUserRegistered(String uid) async {
    UserModel? user = await getUserData(uid);
    return user != null && user.isRegistered;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }


/// Update user profile data
Future<void> updateUserProfile(UserModel user) async {
  try {
    await _firestore.collection('users').doc(user.uid).update(
      user.copyWith(updatedAt: DateTime.now()).toMap(),
    );
  } catch (e) {
    throw Exception('Failed to update profile: $e');
  }
}

/// Update specific profile field
Future<void> updateUserField(String uid, String field, dynamic value) async {
  try {
    await _firestore.collection('users').doc(uid).update({
      field: value,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    throw Exception('Failed to update $field: $e');
  }
}

/// Delete user account and data
Future<void> deleteUserAccount(String uid) async {
  try {
    // Delete user data from Firestore
    await _firestore.collection('users').doc(uid).delete();
    
    // Delete Firebase Auth account
    await _firebaseAuth.currentUser?.delete();
  } catch (e) {
    throw Exception('Failed to delete account: $e');
  }
}
}
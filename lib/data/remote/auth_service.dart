// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lifeos/core/utils/logger.dart';

/// Auth service - handles all Firebase Authentication operations
class AuthService with LoggerMixin {
  AuthService(this._auth, this._googleSignIn);

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Current user (synchronous access)
  User? get currentUser => _auth.currentUser;

  /// Current user ID or null
  String? get currentUserId => _auth.currentUser?.uid;

  /// Sign in anonymously
  Future<UserCredential> signInAnonymously() async {
    try {
      logD('Signing in anonymously');
      final result = await _auth.signInAnonymously();
      logD('Anonymous sign-in successful: ${result.user?.uid}');
      return result;
    } on FirebaseAuthException catch (e) {
      logE('Anonymous sign-in failed', error: e);
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      logD('Signing in with email: $email');
      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      logD('Email sign-in successful: ${result.user?.uid}');
      return result;
    } on FirebaseAuthException catch (e) {
      logE('Email sign-in failed', error: e);
      rethrow;
    }
  }

  /// Create account with email and password
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      logD('Creating account with email: $email');
      final result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (displayName != null && result.user != null) {
        await result.user!.updateDisplayName(displayName);
        await result.user!.reload();
      }
      logD('Account creation successful: ${result.user?.uid}');
      return result;
    } on FirebaseAuthException catch (e) {
      logE('Account creation failed', error: e);
      rethrow;
    }
  }

  /// Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      logD('Starting Google sign-in');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        logD('Google sign-in cancelled by user');
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Google sign-in was cancelled',
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      logD('Google sign-in successful: ${result.user?.uid}');
      return result;
    } on FirebaseAuthException catch (e) {
      logE('Google sign-in failed', error: e);
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      logD('Signing out');
      await _googleSignIn.signOut();
      await _auth.signOut();
      logD('Sign out successful');
    } on FirebaseAuthException catch (e) {
      logE('Sign out failed', error: e);
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      logD('Sending password reset to: $email');
      await _auth.sendPasswordResetEmail(email: email.trim());
      logD('Password reset email sent');
    } on FirebaseAuthException catch (e) {
      logE('Password reset failed', error: e);
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'NO_CURRENT_USER',
        message: 'No user is currently signed in',
      );
    }

    try {
      logD('Updating profile for user: ${user.uid}');
      await user.updateDisplayName(displayName);
      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }
      await user.reload();
      logD('Profile updated successfully');
    } on FirebaseAuthException catch (e) {
      logE('Profile update failed', error: e);
      rethrow;
    }
  }

  /// Delete current user account
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'NO_CURRENT_USER',
        message: 'No user is currently signed in',
      );
    }

    try {
      logD('Deleting account for user: ${user.uid}');
      await user.delete();
      logD('Account deleted successfully');
    } on FirebaseAuthException catch (e) {
      logE('Account deletion failed', error: e);
      rethrow;
    }
  }

  /// Re-authenticate user (required for sensitive operations)
  Future<void> reauthenticateWithCredential(AuthCredential credential) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'NO_CURRENT_USER',
        message: 'No user is currently signed in',
      );
    }

    try {
      logD('Re-authenticating user: ${user.uid}');
      await user.reauthenticateWithCredential(credential);
      logD('Re-authentication successful');
    } on FirebaseAuthException catch (e) {
      logE('Re-authentication failed', error: e);
      rethrow;
    }
  }

  /// Get ID token for API calls
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      return await user.getIdToken(forceRefresh);
    } on FirebaseAuthException catch (e) {
      logE('Failed to get ID token', error: e);
      return null;
    }
  }
}

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    FirebaseAuth.instance,
    GoogleSignIn(
        // Optional: configure with client ID for iOS/macOS
        // clientId: 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com',
        ),
  );
});

// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/core/utils/logger.dart';
import 'package:lifeos/data/remote/auth_service.dart';
import 'package:lifeos/data/remote/firestore_service.dart';
import 'package:lifeos/domain/entities/user.dart';
import 'package:lifeos/domain/repositories/repository_interfaces.dart';

/// User repository implementation using Firebase Auth and Firestore
class UserRepositoryImpl with LoggerMixin implements UserRepository {
  UserRepositoryImpl(this._authService, this._firestoreService);

  final AuthService _authService;
  final FirestoreService _firestoreService;

  @override
  Future<User?> getUser(String userId) async {
    try {
      // First try to get from Firestore
      final userData = await _firestoreService.getUser(userId);
      if (userData != null) {
        return User.fromJson(userData);
      }

      // If not in Firestore, try to get from Firebase Auth and create
      final currentUser = _authService.currentUser;
      if (currentUser != null && currentUser.uid == userId) {
        return _createUserFromAuthUser(currentUser);
      }
      return null;
    } catch (e) {
      logE('Failed to get user', error: e);
      return null;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) return null;

      // Try to get from Firestore first
      final userData = await _firestoreService.getUser(currentUser.uid);
      if (userData != null) {
        return User.fromJson(userData);
      }

      // Create from auth user
      return _createUserFromAuthUser(currentUser);
    } catch (e) {
      logE('Failed to get current user', error: e);
      return null;
    }
  }

  @override
  Future<void> saveUser(User user) async {
    try {
      logD('Saving user: ${user.id}');
      await _firestoreService.saveUser(user.toJson());
    } catch (e) {
      logE('Failed to save user', error: e);
      rethrow;
    }
  }

  @override
  Future<void> updateUser(User user) async {
    try {
      logD('Updating user: ${user.id}');
      await _firestoreService.updateUser(user.id, user.toJson());
    } catch (e) {
      logE('Failed to update user', error: e);
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      logD('Deleting user: $userId');
      await _firestoreService.deleteUser(userId);
    } catch (e) {
      logE('Failed to delete user', error: e);
      rethrow;
    }
  }

  @override
  Stream<User?> watchUser(String userId) {
    return _firestoreService.watchUser(userId).map((data) {
      if (data == null) return null;
      return User.fromJson(data);
    });
  }

  User _createUserFromAuthUser(firebase_auth.User authUser) {
    return User(
      id: authUser.uid,
      email: authUser.email ?? '',
      displayName: authUser.displayName,
      photoUrl: authUser.photoURL,
      isPremium: false,
      subscriptionEndDate: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      stats: const UserStats(),
    );
  }
}

/// User repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);
  return UserRepositoryImpl(authService, firestoreService);
});

/// Auth repository provider (wraps AuthService for convenience)
final authRepositoryProvider = Provider<AuthService>((ref) {
  return ref.watch(authServiceProvider);
});
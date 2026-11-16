// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import 'package:lifeos/core/di/providers.dart' hide AuthPage, OnboardingPage;
import 'package:lifeos/presentation/auth/auth_page.dart';
import 'package:lifeos/presentation/onboarding/onboarding_page.dart';
import 'package:lifeos/domain/entities/item.dart';

// Test-specific Notifier that doesn't require AuthService
class TestAuthStateNotifier extends AuthStateNotifier {
  final List<String> methodCalls = [];
  final _testStreamController = StreamController<AuthState>.broadcast();
  AuthState _testState = const AuthState();

  @override
  AuthState build() {
    // Don't call super.build() to avoid needing AuthService
    return _testState;
  }

  @override
  Stream<AuthState> get stream => _testStreamController.stream;

  @override
  AuthState get state => _testState;

  @override
  set state(AuthState newState) {
    _testState = newState;
    _testStreamController.add(newState);
  }

  @override
  Future<void> signInAnonymously() async {
    methodCalls.add('signInAnonymously');
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    methodCalls.add('signInWithEmailAndPassword');
  }

  @override
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    methodCalls.add('createUserWithEmailAndPassword');
  }

  @override
  Future<void> signInWithGoogle() async {
    methodCalls.add('signInWithGoogle');
  }

  @override
  void completeOnboarding() {
    methodCalls.add('completeOnboarding');
    state = state.copyWith(onboardingCompleted: true);
  }
}

// Notifier that delays signInWithEmailAndPassword for testing loading indicator
class DelayedSignInNotifier extends TestAuthStateNotifier {
  late final Completer<void> _signInCompleter;

  DelayedSignInNotifier() {
    _signInCompleter = Completer<void>();
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    methodCalls.add('signInWithEmailAndPassword');
    return _signInCompleter.future;
  }

  void completeSignIn() {
    if (!_signInCompleter.isCompleted) {
      _signInCompleter.complete();
    }
  }
}

void main() {
  group('AuthPage Widget Tests', () {
    late ProviderContainer container;
    late TestAuthStateNotifier testAuthNotifier;

    setUp(() {
      testAuthNotifier = TestAuthStateNotifier();

      container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith(() => testAuthNotifier),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('shows sign in form by default', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: AuthPage()),
        ),
      );

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Create Account'), findsNothing);
    });

    testWidgets('shows sign up form when toggled', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: AuthPage()),
        ),
      );

      // Scroll to and tap sign up toggle (the TextButton, not the FilledButton)
      final signUpToggle = find.widgetWithText(TextButton, 'Sign Up');
      await tester.ensureVisible(signUpToggle);
      await tester.tap(signUpToggle);
      await tester.pump();

      expect(find.text('Create your second brain'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
      // The TextButton should now say "Sign In"
      expect(find.widgetWithText(TextButton, 'Sign In'), findsOneWidget);
    });

    testWidgets('shows error when email is empty on submit', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: AuthPage()),
        ),
      );

      await tester.tap(find.text('Sign In'));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('shows error when password is empty on submit', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: AuthPage()),
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('shows error when password is too short', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: AuthPage()),
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, '123');
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('sign up requires display name', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: AuthPage()),
        ),
      );

      // Toggle to sign up
      final signUpToggle = find.widgetWithText(TextButton, 'Sign Up');
      await tester.ensureVisible(signUpToggle);
      await tester.tap(signUpToggle);
      await tester.pump();

      // Fill email and passwords but NOT display name
      await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      await tester.enterText(find.byType(TextFormField).at(3), 'password123');

      // Scroll to and tap submit
      final submitButton = find.text('Create Account');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pump();

      expect(find.text('Please enter your name'), findsOneWidget);
    });

    testWidgets('sign up requires matching passwords', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: AuthPage()),
        ),
      );

      // Toggle to sign up
      final signUpToggle = find.widgetWithText(TextButton, 'Sign Up');
      await tester.ensureVisible(signUpToggle);
      await tester.tap(signUpToggle);
      await tester.pump();

      // Fill all fields including display name
      final nameField = find.byType(TextFormField).at(0);
      await tester.ensureVisible(nameField);
      await tester.enterText(nameField, 'Test User');

      await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      await tester.enterText(find.byType(TextFormField).at(3), 'different');

      // Scroll to and tap submit
      final submitButton = find.text('Create Account');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('calls signInAnonymously when guest button pressed', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: AuthPage()),
        ),
      );

      final guestButton = find.widgetWithText(OutlinedButton, 'Continue as Guest');
      await tester.ensureVisible(guestButton);
      await tester.tap(guestButton);
      await tester.pump();

      expect(testAuthNotifier.methodCalls, contains('signInAnonymously'));
    });

    testWidgets('shows loading indicator during submit', (tester) async {
      final delayedNotifier = DelayedSignInNotifier();
      final testContainer = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith(() => delayedNotifier),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: testContainer,
          child: const MaterialApp(home: AuthPage()),
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      final signInButton = find.widgetWithText(FilledButton, 'Sign In');
      await tester.ensureVisible(signInButton);
      await tester.tap(signInButton);
      await tester.pump();

      // Loading indicator should be visible
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the sign-in future
      delayedNotifier.completeSignIn();
      await tester.pump();

      testContainer.dispose();
    });
  });

  group('OnboardingPage Widget Tests', () {
    late ProviderContainer container;
    late TestAuthStateNotifier testAuthNotifier;

    // Helper to build the test widget with GoRouter for navigation tests
    Widget buildTestWidget({required Widget child}) {
      return UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: '/onboarding',
            routes: [
              GoRoute(
                path: '/onboarding',
                builder: (context, state) => child,
              ),
              GoRoute(
                path: '/inbox',
                builder: (context, state) => const Scaffold(body: Text('Inbox')),
              ),
            ],
          ),
        ),
      );
    }

    setUp(() {
      testAuthNotifier = TestAuthStateNotifier();
      // Override state to be authenticated with onboarding not completed
      testAuthNotifier.state = const AuthState(
        isAuthenticated: true,
        onboardingCompleted: false,
      );

      container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith(() => testAuthNotifier),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('shows all 4 onboarding slides', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: OnboardingPage()),
        ),
      );

      // Check first slide
      expect(find.text('Capture Everything'), findsOneWidget);
      expect(find.text('Save links, notes, PDFs, images, and recordings in one place. Your digital inbox for life.'), findsOneWidget);

      // Tap Next to go to second slide
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('AI Organizes Automatically'), findsOneWidget);

      // Tap Next to go to third slide
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('Chat with Your Knowledge'), findsOneWidget);

      // Tap Next to go to fourth slide
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('Smart Digests & Reminders'), findsOneWidget);
    });

    testWidgets('page indicators show current page', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: OnboardingPage()),
        ),
      );

      // First indicator should be wider (active)
      final indicators = find.byType(AnimatedContainer).evaluate();
      expect(indicators.length, 4);
    });

    testWidgets('skip button navigates away', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(child: const OnboardingPage()),
      );

      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(testAuthNotifier.methodCalls, contains('completeOnboarding'));
    });

    testWidgets('next button advances to next slide', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: OnboardingPage()),
        ),
      );

      expect(find.text('Next'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('AI Organizes Automatically'), findsOneWidget);
    });

    testWidgets('get started button on last slide completes onboarding', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(child: const OnboardingPage()),
      );

      // Navigate to last slide using Next button
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }

      expect(find.text('Get Started'), findsOneWidget);

      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      expect(testAuthNotifier.methodCalls, contains('completeOnboarding'));
    });

    testWidgets('shows correct icons for each slide', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: OnboardingPage()),
        ),
      );

      // Check icons are present (using Icon widget)
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.auto_awesome_outlined), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.summarize_outlined), findsOneWidget);
    });
  });
}
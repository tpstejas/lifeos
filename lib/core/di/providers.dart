// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import 'package:lifeos/core/config/app_config.dart';
import 'package:lifeos/core/utils/logger.dart';
import 'package:lifeos/data/remote/auth_service.dart';
import 'package:lifeos/data/remote/firestore_service.dart';
import 'package:lifeos/domain/entities/item.dart';
import 'package:lifeos/presentation/inbox/inbox_page.dart';
import 'package:lifeos/presentation/inbox/capture_page.dart';
import 'package:lifeos/presentation/library/library_page.dart';
import 'package:lifeos/presentation/library/item_detail_page.dart';
import 'package:lifeos/presentation/library/collection_page.dart';
import 'package:lifeos/presentation/chat/chat_page.dart';
import 'package:lifeos/presentation/chat/conversation_page.dart';
import 'package:lifeos/presentation/digests/digests_page.dart';
import 'package:lifeos/presentation/digests/digest_detail_page.dart';
import 'package:lifeos/presentation/tasks/tasks_page.dart';
import 'package:lifeos/presentation/tasks/create_task_page.dart';
import 'package:lifeos/presentation/tasks/task_detail_page.dart';
import 'package:lifeos/presentation/settings/settings_page.dart';
import 'package:lifeos/presentation/settings/profile_page.dart';
import 'package:lifeos/presentation/settings/subscription_page.dart';
import 'package:lifeos/presentation/auth/auth_page.dart';
import 'package:lifeos/presentation/onboarding/onboarding_page.dart';

/// App router provider using GoRouter
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final authStateNotifier = ref.watch(authStateProvider.notifier);

  return GoRouter(
    initialLocation: '/inbox',
    refreshListenable: GoRouterRefreshStream(authStateNotifier.stream),
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isOnboarding = authState.onboardingCompleted;

      // If not logged in, redirect to auth
      if (!isLoggedIn && !state.matchedLocation.startsWith('/auth')) {
        return '/auth';
      }

      // If logged in but onboarding not complete, redirect to onboarding
      if (isLoggedIn &&
          !isOnboarding &&
          !state.matchedLocation.startsWith('/onboarding')) {
        return '/onboarding';
      }

      // If logged in and onboarding complete, but on auth/onboarding pages, redirect to inbox
      if (isLoggedIn &&
          isOnboarding &&
          (state.matchedLocation.startsWith('/auth') ||
              state.matchedLocation.startsWith('/onboarding'))) {
        return '/inbox';
      }

      return null;
    },
    routes: [
      // Authentication routes
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthPage(),
      ),

      // Onboarding route
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),

      // Main shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // Inbox (Capture)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inbox',
                name: 'inbox',
                builder: (context, state) => const InboxPage(),
                routes: [
                  GoRoute(
                    path: 'capture/:type',
                    name: 'capture',
                    builder: (context, state) {
                      final type = state.pathParameters['type']!;
                      return CapturePage(captureType: type);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Library (Browse)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                name: 'library',
                builder: (context, state) => const LibraryPage(),
                routes: [
                  GoRoute(
                    path: 'item/:id',
                    name: 'item-detail',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return ItemDetailPage(itemId: id);
                    },
                  ),
                  GoRoute(
                    path: 'collection/:collection',
                    name: 'collection',
                    builder: (context, state) {
                      final collection = state.pathParameters['collection']!;
                      return CollectionPage(collection: collection);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Chat (RAG)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chat',
                name: 'chat',
                builder: (context, state) => const ChatPage(),
                routes: [
                  GoRoute(
                    path: 'conversation/:id',
                    name: 'conversation',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return ConversationPage(conversationId: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Digests
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/digests',
                name: 'digests',
                builder: (context, state) => const DigestsPage(),
                routes: [
                  GoRoute(
                    path: ':period/:date',
                    name: 'digest-detail',
                    builder: (context, state) {
                      final period = state.pathParameters['period']!;
                      final date = state.pathParameters['date']!;
                      return DigestDetailPage(period: period, date: date);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Tasks
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tasks',
                name: 'tasks',
                builder: (context, state) => const TasksPage(),
                routes: [
                  GoRoute(
                    path: 'create',
                    name: 'create-task',
                    builder: (context, state) => const CreateTaskPage(),
                  ),
                  GoRoute(
                    path: ':id',
                    name: 'task-detail',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return TaskDetailPage(taskId: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsPage(),
                routes: [
                  GoRoute(
                    path: 'profile',
                    name: 'profile',
                    builder: (context, state) => const ProfilePage(),
                  ),
                  GoRoute(
                    path: 'subscription',
                    name: 'subscription',
                    builder: (context, state) => const SubscriptionPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found: ${state.error}'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/inbox'),
              child: const Text('Go to Inbox'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Auth state provider
@immutable
class AuthState {
  final bool isAuthenticated;
  final String? userId;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool onboardingCompleted;

  const AuthState({
    this.isAuthenticated = false,
    this.userId,
    this.email,
    this.displayName,
    this.photoUrl,
    this.onboardingCompleted = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userId,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? onboardingCompleted,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}

class AuthStateNotifier extends Notifier<AuthState> {
  final _streamController = StreamController<AuthState>.broadcast();
  AuthService? _authService;
  StreamSubscription<User?>? _authSubscription;

  @override
  AuthState build() {
    _authService = ref.read(authServiceProvider);
    _listenToAuthChanges();

    // Register cleanup callback
    ref.onDispose(() {
      _authSubscription?.cancel();
      _streamController.close();
    });

    return const AuthState();
  }

  Stream<AuthState> get stream => _streamController.stream;

  void _updateState(AuthState newState) {
    state = newState;
    _streamController.add(newState);
  }

  void _listenToAuthChanges() {
    _authSubscription = _authService!.authStateChanges.listen((User? user) {
      if (user != null) {
        _updateState(AuthState(
          isAuthenticated: true,
          userId: user.uid,
          email: user.email,
          displayName: user.displayName,
          photoUrl: user.photoURL,
        ));
      } else {
        _updateState(const AuthState());
      }
    });
  }

  Future<void> signInAnonymously() async {
    await _authService!.signInAnonymously();
    // State will be updated via authStateChanges listener
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _authService!.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    await _authService!.createUserWithEmailAndPassword(
      email: email,
      password: password,
      displayName: displayName,
    );
  }

  Future<void> signInWithGoogle() async {
    await _authService!.signInWithGoogle();
  }

  Future<void> signOut() async {
    await _authService!.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _authService!.sendPasswordResetEmail(email);
  }

  void completeOnboarding() {
    _updateState(state.copyWith(onboardingCompleted: true));
  }
}

final authStateProvider =
    NotifierProvider<AuthStateNotifier, AuthState>(AuthStateNotifier.new);

/// Firestore service provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService(FirebaseFirestore.instance);
});

/// Items stream provider - watches real-time items from Firestore
final itemsStreamProvider =
    StreamProvider.autoDispose.family<List<Item>, String>(
  (ref, userId) {
    if (userId.isEmpty) {
      return const Stream.empty();
    }
    final firestoreService = ref.watch(firestoreServiceProvider);
    return firestoreService.listenToItems(userId);
  },
);

/// Theme provider
class ThemeNotifier extends Notifier<AppTheme> {
  @override
  AppTheme build() => AppTheme(
        lightTheme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(),
        themeMode: AppConfig.themeMode,
      );

  Future<void> _init() async {
    final mode = AppConfig.themeMode;
    state = state.copyWith(themeMode: mode);
  }

  void setThemeMode(ThemeMode mode) {
    AppConfig.setThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }

  static ThemeData _buildLightTheme() {
    const seedColor = Color(0xFF6366F1); // Indigo

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      ).copyWith(
        surfaceContainerHighest: const Color(0xFFF1F5F9),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        margin: EdgeInsets.zero,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: CircleBorder(),
        elevation: 4,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: seedColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        backgroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: seedColor, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
        labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade200,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        modalBackgroundColor: Colors.white,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 70,
        backgroundColor: Colors.white,
        indicatorColor: seedColor.withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: seedColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }
          return TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          );
        }),
      ),
    );
  }

  static ThemeData _buildDarkTheme() {
    const seedColor = Color(0xFF818CF8); // Lighter indigo for dark

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ).copyWith(
        surfaceContainerHighest: const Color(0xFF1E293B),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade800),
        ),
        margin: EdgeInsets.zero,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: CircleBorder(),
        elevation: 4,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: seedColor,
        unselectedItemColor: Colors.grey.shade500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        backgroundColor: const Color(0xFF0F172A),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: seedColor, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
        labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        backgroundColor: const Color(0xFF1E293B),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade800,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        modalBackgroundColor: const Color(0xFF1E293B),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 70,
        backgroundColor: const Color(0xFF0F172A),
        indicatorColor: seedColor.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: seedColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }
          return TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
          );
        }),
      ),
    );
  }
}

final themeProvider =
    NotifierProvider<ThemeNotifier, AppTheme>(ThemeNotifier.new);

/// Main shell with bottom navigation
class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inbox_outlined),
            selectedIcon: Icon(Icons.inbox),
            label: 'Inbox',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.summarize_outlined),
            selectedIcon: Icon(Icons.summarize),
            label: 'Digests',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Tasks',
          ),
        ],
      ),
    );
  }
}

/// GoRouter refresh stream helper
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<AuthState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

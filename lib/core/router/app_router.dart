import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:orders/core/router/router_refresh.dart';
import 'package:orders/features/auth/provider/auth_provider.dart';

import 'package:orders/features/auth/screen/login_screen.dart';
import 'package:orders/features/auth/screen/register_screen.dart';
import 'package:orders/features/auth/screen/splash_screen.dart';
import 'package:orders/features/chat/chat_screen.dart';

import 'package:orders/features/home/home_screen.dart';
import 'package:orders/features/home/buyer/screen/product_details_screen.dart';
import 'package:orders/features/profile/profile_screen.dart';
import 'package:orders/features/settings/settings_screen.dart';

import 'package:orders/main_scaffod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = FirebaseAuth.instance;

  return GoRouter(
    initialLocation: '/splash',

    refreshListenable: GoRouterRefreshStream(
      auth.authStateChanges(),
    ),

    redirect: (context, state) {
      final user = auth.currentUser;

      final loggedIn = user != null;

      final location = state.matchedLocation;

      final isSplash = location == '/splash';
      final isLogin = location == '/login';
      final isRegister = location == '/register';

      // 🟡 لا توقف على loading
      if (auth.currentUser == null && auth.authStateChanges() == null) {
        return null;
      }

      // 🟣 Splash
      if (isSplash) {
        return loggedIn ? '/home' : '/login';
      }

      // ❌ Not logged in
      if (!loggedIn) {
        if (isLogin || isRegister) return null;
        return '/login';
      }

      // 🔐 logged in on auth pages
      if (loggedIn && (isLogin || isRegister)) {
        return '/home';
      }

      return null;
    },

    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),

      GoRoute(
        path: '/products/:id',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailsScreen(productId: productId);
        },
      ),

      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
          GoRoute(path: '/chat', builder: (_, _) => const ChatScreen()),
          GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
          GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
        ],
      ),
    ],
  );
});

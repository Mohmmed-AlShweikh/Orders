import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:orders/core/router/router_refresh.dart';
import 'package:orders/features/auth/screen/login_screen.dart';
import 'package:orders/features/auth/screen/register_screen.dart';
import 'package:orders/features/auth/screen/splash_screen.dart';
import 'package:orders/features/chat/screen/chat_list_screen.dart';
import 'package:orders/features/home/home_screen.dart';
import 'package:orders/features/profile/profile_screen.dart';
import 'package:orders/features/settings/settings_screen.dart';
import 'package:orders/main_scaffod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = FirebaseAuth.instance;

  return GoRouter(
    initialLocation: '/splash',

    /// 🔥 مهم: فقط trigger مش logic
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
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/chat', builder: (_, __) => const ChatsScreen()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
        ],
      ),
    ],
  );
});
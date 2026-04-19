import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orders/core/router/router_refresh.dart';
import 'package:orders/features/auth/provider/auth_provider.dart';
import 'package:orders/features/auth/screen/login_screen.dart';
import 'package:orders/features/auth/screen/register_screen.dart';
import 'package:orders/features/auth/screen/splash_screen.dart';
import 'package:orders/features/home/home_screen.dart';
import 'package:orders/main_scaffod.dart';
import 'package:orders/profile_screen.dart';
import 'package:orders/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authUserProvider);

  return GoRouter(
    initialLocation: '/splash',
     refreshListenable: GoRouterRefreshStream(
      ref.watch(authRepoProvider).userStream(),
    ),

    redirect: (context, state) {
      final auth = ref.read(authUserProvider);

      final loading = auth.isLoading;
      final user = auth.value;
      final loggedIn = user != null;

      final location = state.matchedLocation;

      final isSplash = location == '/splash';
      final isLogin = location == '/login';
      final isRegister = location == '/register';

      // ⏳ Loading
      if (loading) return null;

      // 🧠 Splash logic
      if (isSplash) {
        return loggedIn ? '/home' : '/login';
      }

      // ❌ Not logged in
      if (!loggedIn) {
        if (isLogin || isRegister) return null;
        return '/login';
      }

      // ✅ Logged in
      if (loggedIn && (isLogin || isRegister)) {
        return '/home';
      }

      return null;
    },

    routes: [
      /// 🟣 Splash
      GoRoute(
        path: '/splash',
        builder: (_, _) => const SplashScreen(),
      ),

      /// 🔐 Auth
      GoRoute(
        path: '/login',
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, _) => const RegisterScreen(),
      ),

      /// 🧱 MAIN APP (Bottom Nav)
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child,);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, _) => const HomeScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, _) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (_, _) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});
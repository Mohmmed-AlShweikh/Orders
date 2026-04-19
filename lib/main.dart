
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orders/core/router/app_router.dart';
import 'package:orders/core/theme/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final router = ref.watch(routerProvider);
     final settings = ref.watch(settingsProvider);

     
    

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: settings.isDark ? ThemeMode.dark : ThemeMode.light,
      locale: Locale(settings.language),
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      routerConfig: router,
    );
  }

  }



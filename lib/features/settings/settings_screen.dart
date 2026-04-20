import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orders/core/theme/settings_provider.dart';
import 'package:orders/features/auth/provider/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: const Color(0xff0f172a),
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: const Color(0xff0f172a),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 🔥 HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                color: Color(0xff1e293b),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                children: const [
                  Icon(Icons.settings, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "App Settings",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _card(
                    child: Column(
                      children: [
                        /// 🌐 Language
                        _tile(
                          title: "Language",
                          subtitle: settings.language == "ar"
                              ? "Arabic"
                              : "English",
                          icon: Icons.language,
                          trailing: DropdownButton<String>(
                            value: settings.language,
                            dropdownColor: const Color(0xff1e293b),
                            style: const TextStyle(color: Colors.white),
                            underline: const SizedBox(),
                            items: const [
                              DropdownMenuItem(
                                value: "ar",
                                child: Text("Arabic"),
                              ),
                              DropdownMenuItem(
                                value: "en",
                                child: Text("English"),
                              ),
                            ],
                            onChanged: (value) {
                              ref
                                  .read(settingsProvider.notifier)
                                  .changeLanguage(value!);
                            },
                          ),
                        ),

                        const Divider(color: Colors.white12),

                        /// 🌙 Theme
                        _tile(
                          title: "Dark Mode",
                          subtitle: settings.isDark
                              ? "Enabled"
                              : "Disabled",
                          icon: Icons.dark_mode,
                          trailing: Switch(
                            value: settings.isDark,
                            onChanged: (_) {
                              ref
                                  .read(settingsProvider.notifier)
                                  .toggleTheme();
                            },
                          ),
                        ),
                        GestureDetector(
                            onTap: ()async {
                          await ref.read(authControllerProvider.notifier).logout();
                                        ref.invalidate(authUserProvider);
                                                },
                          child: _card(
                                              child: _tile(
                                                title: "Logout",
                                                subtitle: "Sign out from account",
                                                icon: Icons.logout,
                                               
                                              
                                              ),
                                            ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xff1e293b),
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }

  Widget _tile({
    required String title,
    required String subtitle,
    required IconData icon,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle:
          Text(subtitle, style: const TextStyle(color: Colors.white54)),
      trailing: trailing,
    );
  }
}

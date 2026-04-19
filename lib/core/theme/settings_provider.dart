import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool isDark;
  final String language;

  SettingsState({required this.isDark, required this.language});

  SettingsState copyWith({bool? isDark, String? language}) {
    return SettingsState(
      isDark: isDark ?? this.isDark,
      language: language ?? this.language,
    );
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<SettingsState> {
  SharedPreferences? _prefs;

  SettingsNotifier()
      : super(SettingsState(isDark: false, language: 'en')) {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();

    final isDark = _prefs?.getBool('isDark') ?? false;
    final language = _prefs?.getString('language') ?? 'en';

    state = SettingsState(isDark: isDark, language: language);
  }

  Future<void> toggleTheme() async {
    final newTheme = !state.isDark;

    await _prefs?.setBool('isDark', newTheme);
    state = state.copyWith(isDark: newTheme);
  }

  Future<void> changeLanguage(String lang) async {
    await _prefs?.setString('language', lang);
    state = state.copyWith(language: lang);
  }
}
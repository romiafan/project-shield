import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:app/src/common/theme_mode_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeModeNotifier', () {
    test('loads system theme by default', () async {
      SharedPreferences.setMockInitialValues({});
      final notifier = ThemeModeNotifier();
      await Future.delayed(const Duration(milliseconds: 100));
      expect(notifier.state, ThemeMode.system);
    });

    test('sets and persists theme mode', () async {
      SharedPreferences.setMockInitialValues({});
      final notifier = ThemeModeNotifier();
      await notifier.setThemeMode(ThemeMode.dark);
      expect(notifier.state, ThemeMode.dark);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('theme_mode'), 'dark');
    });

    test('loads persisted theme mode', () async {
      SharedPreferences.setMockInitialValues({'theme_mode': 'light'});
      final notifier = ThemeModeNotifier();
      await Future.delayed(const Duration(milliseconds: 100));
      expect(notifier.state, ThemeMode.light);
    });
  });
}

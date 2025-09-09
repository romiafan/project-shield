import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../credentials/presentation/credentials_screen.dart';
import '../generator/presentation/generator_screen.dart' as gen;
import '../../common/theme_mode_provider.dart';

final shellIndexProvider = StateProvider<int>((ref) => 0);

class ShellView extends ConsumerStatefulWidget {
  const ShellView({super.key});

  @override
  ConsumerState<ShellView> createState() => _ShellViewState();
}

class _ShellViewState extends ConsumerState<ShellView> {
  static final List<Widget> _screens = <Widget>[
    const CredentialsScreen(),
    const gen.GeneratorScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final int currentIndex = ref.watch(shellIndexProvider);

    return Scaffold(
      body: _screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int index) =>
            ref.read(shellIndexProvider.notifier).state = index,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shield_outlined),
            activeIcon: Icon(Icons.shield),
            label: 'Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.generating_tokens_outlined),
            activeIcon: Icon(Icons.generating_tokens),
            label: 'Generator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// Placeholder removed: Vault tab now shows CredentialsScreen

class GeneratorScreen extends StatelessWidget {
  const GeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Generator'));
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.brightness_6),
                    const SizedBox(width: 16),
                    const Text('Theme', style: TextStyle(fontSize: 16)),
                    const Spacer(),
                    ToggleButtons(
                      isSelected: [
                        themeMode == ThemeMode.light,
                        themeMode == ThemeMode.dark,
                        themeMode == ThemeMode.system,
                      ],
                      borderRadius: BorderRadius.circular(8),
                      onPressed: (index) {
                        ThemeMode selected;
                        if (index == 0)
                          selected = ThemeMode.light;
                        else if (index == 1)
                          selected = ThemeMode.dark;
                        else
                          selected = ThemeMode.system;
                        themeNotifier.setThemeMode(selected);
                      },
                      children: const [
                        Tooltip(
                          message: 'Light',
                          child: Icon(Icons.light_mode),
                        ),
                        Tooltip(message: 'Dark', child: Icon(Icons.dark_mode)),
                        Tooltip(
                          message: 'System',
                          child: Icon(Icons.brightness_auto),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

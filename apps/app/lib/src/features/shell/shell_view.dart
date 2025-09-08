import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../credentials/presentation/credentials_screen.dart';
import '../generator/presentation/generator_screen.dart' as gen;

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

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings'));
  }
}

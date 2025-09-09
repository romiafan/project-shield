import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/src/feature_config.dart';

import 'src/features/shell/shell_view.dart';
import 'src/common/theme_mode_provider.dart';

final featureConfigProvider = Provider<Map<String, bool>>(
  (ref) => kFeatureConfig,
);

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Project Shield',
      theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      themeMode: themeMode,
      home: const ShellView(),
    );
  }
}

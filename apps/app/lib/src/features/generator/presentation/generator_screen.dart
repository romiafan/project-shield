import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordLengthProvider = StateProvider<int>((ref) => 16);
final includeNumbersProvider = StateProvider<bool>((ref) => true);
final includeSymbolsProvider = StateProvider<bool>((ref) => true);
final includeUppercaseProvider = StateProvider<bool>((ref) => true);
final generatedPasswordProvider = StateProvider<String>((ref) => '');

String _generatePassword({
  required int length,
  required bool numbers,
  required bool symbols,
  required bool uppercase,
}) {
  const String lowers = 'abcdefghijklmnopqrstuvwxyz';
  const String uppers = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const String nums = '0123456789';
  const String syms = '!@#\$%^&*()-_=+[]{};:,.?/';

  String charset = lowers;
  if (uppercase) charset += uppers;
  if (numbers) charset += nums;
  if (symbols) charset += syms;

  final Random rng = Random.secure();
  return List<String>.generate(
    length,
    (_) => charset[rng.nextInt(charset.length)],
  ).join();
}

class GeneratorScreen extends ConsumerWidget {
  const GeneratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int length = ref.watch(passwordLengthProvider);
    final bool numbers = ref.watch(includeNumbersProvider);
    final bool symbols = ref.watch(includeSymbolsProvider);
    final bool uppercase = ref.watch(includeUppercaseProvider);
    final String password = ref.watch(generatedPasswordProvider);

    void regenerate() {
      final String pwd = _generatePassword(
        length: length,
        numbers: numbers,
        symbols: symbols,
        uppercase: uppercase,
      );
      ref.read(generatedPasswordProvider.notifier).state = pwd;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SelectableText(
              password.isEmpty ? 'Tap Generate' : password,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                const Text('Length'),
                Expanded(
                  child: Slider(
                    value: length.toDouble(),
                    min: 8,
                    max: 64,
                    divisions: 56,
                    label: length.toString(),
                    onChanged: (double v) =>
                        ref.read(passwordLengthProvider.notifier).state = v
                            .round(),
                  ),
                ),
                Text(length.toString()),
              ],
            ),
            SwitchListTile(
              value: numbers,
              onChanged: (bool v) =>
                  ref.read(includeNumbersProvider.notifier).state = v,
              title: const Text('Include numbers'),
            ),
            SwitchListTile(
              value: symbols,
              onChanged: (bool v) =>
                  ref.read(includeSymbolsProvider.notifier).state = v,
              title: const Text('Include symbols'),
            ),
            SwitchListTile(
              value: uppercase,
              onChanged: (bool v) =>
                  ref.read(includeUppercaseProvider.notifier).state = v,
              title: const Text('Include uppercase'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: regenerate,
                child: const Text('Generate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';

class PasswordGenerator {
  PasswordGenerator({Random? random}) : _random = random ?? Random.secure();

  final Random _random;

  String generate({
    required int length,
    required bool includeNumbers,
    required bool includeSymbols,
    required bool includeUppercase,
  }) {
    const String lowers = 'abcdefghijklmnopqrstuvwxyz';
    const String uppers = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String nums = '0123456789';
    const String syms = '!@#\$%^&*()-_=+[]{};:,.?/';

    String charset = lowers;
    if (includeUppercase) charset += uppers;
    if (includeNumbers) charset += nums;
    if (includeSymbols) charset += syms;

    if (charset.isEmpty) {
      throw ArgumentError('Character set must not be empty');
    }

    return List<String>.generate(
      length,
      (_) => charset[_random.nextInt(charset.length)],
    ).join();
  }
}

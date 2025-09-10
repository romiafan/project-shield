import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../credentials/application/credentials_notifier.dart';
import '../models/credential.dart';
// Only import dart:html for web
// ignore: avoid_web_libraries_in_flutter
import 'package:flutter/foundation.dart' show kIsWeb;
import 'web_passkey_helper_stub.dart'
    if (dart.library.html) 'web_passkey_helper.dart';
import 'dart:typed_data';

class AddEditCredentialScreen extends ConsumerStatefulWidget {
  const AddEditCredentialScreen({super.key, this.credential});

  final Credential? credential;

  @override
  ConsumerState<AddEditCredentialScreen> createState() =>
      _AddEditCredentialScreenState();
}

class _AddEditCredentialScreenState
    extends ConsumerState<AddEditCredentialScreen> {
  final List<String> _credentialTypes = const [
    'basic',
    'totp',
    'passkey',
    'credit_card',
    'secure_note',
    'identity',
    'license',
  ];
  late String _selectedType;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _urlController;
  late final TextEditingController _notesController;
  // New controllers for expanded types
  late final TextEditingController _totpSecretController;
  late final TextEditingController _totpDigitsController;
  late final TextEditingController _totpPeriodController;
  late final TextEditingController _passkeyCredentialIdController;
  late final TextEditingController _passkeyPublicKeyController;
  late final TextEditingController _cardNumberController;
  late final TextEditingController _cardExpiryController;
  late final TextEditingController _cardHolderController;
  late final TextEditingController _cardCvcController;
  late final TextEditingController _noteContentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.credential?.title ?? '',
    );
    _usernameController = TextEditingController(
      text: widget.credential?.username ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.credential?.password ?? '',
    );
    _urlController = TextEditingController(text: widget.credential?.url ?? '');
    _notesController = TextEditingController(
      text: widget.credential?.notes ?? '',
    );
    _selectedType = widget.credential?.type ?? 'basic';
    _totpSecretController = TextEditingController(
      text: widget.credential?.totpSecret ?? '',
    );
    _totpDigitsController = TextEditingController(
      text: widget.credential?.totpDigits?.toString() ?? '6',
    );
    _totpPeriodController = TextEditingController(
      text: widget.credential?.totpPeriod?.toString() ?? '30',
    );
    _passkeyCredentialIdController = TextEditingController(
      text: widget.credential?.passkeyCredentialId ?? '',
    );
    _passkeyPublicKeyController = TextEditingController(
      text: widget.credential?.passkeyPublicKey ?? '',
    );
    _cardNumberController = TextEditingController(
      text: widget.credential?.cardNumber ?? '',
    );
    _cardExpiryController = TextEditingController(
      text: widget.credential?.cardExpiry ?? '',
    );
    _cardHolderController = TextEditingController(
      text: widget.credential?.cardHolder ?? '',
    );
    _cardCvcController = TextEditingController(
      text: widget.credential?.cardCvc ?? '',
    );
    _noteContentController = TextEditingController(
      text: widget.credential?.noteContent ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    _totpSecretController.dispose();
    _totpDigitsController.dispose();
    _totpPeriodController.dispose();
    _passkeyCredentialIdController.dispose();
    _passkeyPublicKeyController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardHolderController.dispose();
    _cardCvcController.dispose();
    _noteContentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    final AsyncValue<CredentialsNotifier> init = ref.read(
      credentialsNotifierProviderInit,
    );
    if (!init.hasValue) return;
    final base = Credential(
      id: widget.credential?.id ?? now.microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
      url: _urlController.text.trim().isEmpty
          ? null
          : _urlController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      updatedAt: now,
      type: _selectedType,
      // Expanded fields
      totpSecret: _totpSecretController.text.trim().isEmpty
          ? null
          : _totpSecretController.text.trim(),
      totpDigits: int.tryParse(_totpDigitsController.text.trim()),
      totpPeriod: int.tryParse(_totpPeriodController.text.trim()),
      passkeyCredentialId: _passkeyCredentialIdController.text.trim().isEmpty
          ? null
          : _passkeyCredentialIdController.text.trim(),
      passkeyPublicKey: _passkeyPublicKeyController.text.trim().isEmpty
          ? null
          : _passkeyPublicKeyController.text.trim(),
      cardNumber: _cardNumberController.text.trim().isEmpty
          ? null
          : _cardNumberController.text.trim(),
      cardExpiry: _cardExpiryController.text.trim().isEmpty
          ? null
          : _cardExpiryController.text.trim(),
      cardHolder: _cardHolderController.text.trim().isEmpty
          ? null
          : _cardHolderController.text.trim(),
      cardCvc: _cardCvcController.text.trim().isEmpty
          ? null
          : _cardCvcController.text.trim(),
      noteContent: _noteContentController.text.trim().isEmpty
          ? null
          : _noteContentController.text.trim(),
    );
    if (widget.credential == null) {
      init.value!.addCredential(base);
    } else {
      init.value!.updateCredential(base);
    }
    ref.invalidate(credentialsNotifierProviderInit);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.credential != null;
    String password = _passwordController.text;
    int score = 0;
    if (password.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;
    Color barColor;
    String strengthText;
    if (score >= 4) {
      barColor = Colors.green;
      strengthText = 'Strong';
    } else if (score >= 2) {
      barColor = Colors.orange;
      strengthText = 'Medium';
    } else {
      barColor = Colors.red;
      strengthText = 'Weak';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Credential' : 'Add Credential'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                DropdownButtonFormField<String>(
                  initialValue: _selectedType,
                  items: _credentialTypes
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.replaceAll('_', ' ').toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    if (value != null) setState(() => _selectedType = value);
                  },
                  decoration: const InputDecoration(labelText: 'Type'),
                ),
                if (_selectedType == 'totp') ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _totpSecretController,
                    decoration: const InputDecoration(labelText: 'TOTP Secret'),
                    validator: (String? v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _totpDigitsController,
                    decoration: const InputDecoration(labelText: 'Digits'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _totpPeriodController,
                    decoration: const InputDecoration(
                      labelText: 'Period (seconds)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
                if (_selectedType == 'passkey') ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.fingerprint, color: Colors.blue, size: 28),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Passkey credentials use WebAuthn for secure, passwordless authentication. Register a passkey using your device.',
                          style: TextStyle(
                            color: Colors.blueGrey[700],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passkeyCredentialIdController,
                    decoration: const InputDecoration(
                      labelText: 'Passkey Credential ID',
                      prefixIcon: Icon(Icons.vpn_key),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passkeyPublicKeyController,
                    decoration: const InputDecoration(
                      labelText: 'Passkey Public Key',
                      prefixIcon: Icon(Icons.security),
                    ),
                    readOnly: true,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Builder(
                    builder: (context) {
                      bool isRegistered =
                          _passkeyCredentialIdController.text.isNotEmpty &&
                          _passkeyPublicKeyController.text.isNotEmpty;
                      bool loading = false;
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton.icon(
                                icon: loading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.fingerprint),
                                label: Text(
                                  isRegistered
                                      ? 'Passkey Registered'
                                      : 'Register Passkey (WebAuthn)',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isRegistered
                                      ? Colors.green
                                      : null,
                                ),
                                onPressed: isRegistered
                                    ? null
                                    : () async {
                                        if (!kIsWeb) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'WebAuthn only available on web.',
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                        setState(() => loading = true);
                                        try {
                                          final result =
                                              await registerWebAuthnPasskey();
                                          if (result != null) {
                                            setState(() {
                                              _passkeyCredentialIdController
                                                      .text =
                                                  result['credentialId'] ?? '';
                                              _passkeyPublicKeyController.text =
                                                  result['publicKey'] ?? '';
                                            });
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Passkey registered!',
                                                ),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'WebAuthn registration failed.',
                                                ),
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'WebAuthn error: $e',
                                              ),
                                            ),
                                          );
                                        } finally {
                                          setState(() => loading = false);
                                        }
                                      },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
                if (_selectedType == 'credit_card') ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: const InputDecoration(labelText: 'Card Number'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cardExpiryController,
                    decoration: const InputDecoration(
                      labelText: 'Expiry (MM/YY)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cardHolderController,
                    decoration: const InputDecoration(labelText: 'Card Holder'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cardCvcController,
                    decoration: const InputDecoration(labelText: 'CVC'),
                    keyboardType: TextInputType.number,
                  ),
                ],
                if (_selectedType == 'secure_note') ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _noteContentController,
                    decoration: const InputDecoration(
                      labelText: 'Note Content',
                    ),
                    maxLines: 4,
                  ),
                ],
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (String? v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'URL (optional)',
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (String? v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        validator: (String? v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Tooltip(
                      message:
                          'Strong passwords should be at least 12 characters and include uppercase, numbers, and symbols.',
                      child: Icon(Icons.help_outline, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(strengthText, style: TextStyle(color: barColor)),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submit,
                    child: Text(isEditing ? 'Save' : 'Add'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

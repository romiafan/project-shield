import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../credentials/application/credentials_notifier.dart';
import '../models/credential.dart';

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
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    final AsyncValue<CredentialsNotifier> init = ref.read(
      credentialsNotifierProviderInit,
    );
    if (!init.hasValue) return;
    if (widget.credential == null) {
      final newCredential = Credential(
        id: now.microsecondsSinceEpoch.toString(),
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
      );
      init.value!.addCredential(newCredential);
    } else {
      final updated = Credential(
        id: widget.credential!.id,
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
      );
      init.value!.updateCredential(updated);
    }
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
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _selectedType,
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
                decoration: const InputDecoration(labelText: 'URL (optional)'),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 12),
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
                      decoration: const InputDecoration(labelText: 'Password'),
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
              const Spacer(),
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
    );
  }
}

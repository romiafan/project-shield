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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.credential?.title ?? '',
    );
    _usernameController = TextEditingController(
      text: widget.credential?.username ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    if (widget.credential == null) {
      final newCredential = Credential(
        id: now.microsecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        username: _usernameController.text.trim(),
        updatedAt: now,
      );
      ref
          .read(credentialsNotifierProvider.notifier)
          .addCredential(newCredential);
    } else {
      final updated = Credential(
        id: widget.credential!.id,
        title: _titleController.text.trim(),
        username: _usernameController.text.trim(),
        updatedAt: now,
      );
      ref.read(credentialsNotifierProvider.notifier).updateCredential(updated);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.credential != null;
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
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (String? v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (String? v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
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

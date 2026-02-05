import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../providers/user_management_provider.dart';

class AddUserDialog extends ConsumerStatefulWidget {
  const AddUserDialog({super.key});

  @override
  ConsumerState<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends ConsumerState<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _personelIdController = TextEditingController();
  String _selectedPermission = 'Operator';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _personelIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      LucideIcons.userPlus,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Yeni Kullanıcı Ekle',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Username
              TextFormField(
                controller: _usernameController,
                style: const TextStyle(color: AppColors.textMain),
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  prefixIcon: const Icon(LucideIcons.atSign, size: 18),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kullanıcı adı gerekli';
                  }
                  if (value.length < 3) {
                    return 'En az 3 karakter olmalı';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Full Name
              TextFormField(
                controller: _fullNameController,
                style: const TextStyle(color: AppColors.textMain),
                decoration: InputDecoration(
                  labelText: 'Ad Soyad',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  prefixIcon: const Icon(LucideIcons.user, size: 18),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ad soyad gerekli';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Permission
              DropdownButtonFormField<String>(
                initialValue: _selectedPermission,
                dropdownColor: AppColors.surface,
                style: const TextStyle(color: AppColors.textMain),
                decoration: InputDecoration(
                  labelText: 'Yetki Seviyesi',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  prefixIcon: const Icon(LucideIcons.shield, size: 18),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
                items: permissionLevels.map((permission) {
                  return DropdownMenuItem(
                    value: permission,
                    child: Text(_getPermissionLabel(permission)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedPermission = value!);
                },
              ),
              const SizedBox(height: 16),

              // Personnel ID (optional)
              TextFormField(
                controller: _personelIdController,
                style: const TextStyle(color: AppColors.textMain),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Personel ID (Opsiyonel)',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  prefixIcon: const Icon(LucideIcons.hash, size: 18),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                style: const TextStyle(color: AppColors.textMain),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  prefixIcon: const Icon(LucideIcons.lock, size: 18),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Şifre gerekli';
                  }
                  if (value.length < 6) {
                    return 'En az 6 karakter olmalı';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                style: const TextStyle(color: AppColors.textMain),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre Tekrar',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  prefixIcon: const Icon(LucideIcons.lock, size: 18),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Şifreler eşleşmiyor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: AppColors.border),
                      ),
                      child: const Text(
                        'İptal',
                        style: TextStyle(color: AppColors.textMain),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _addUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Ekle'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPermissionLabel(String permission) {
    switch (permission) {
      case 'Admin':
        return 'Yönetici';
      case 'Inspector':
        return 'Kontrolör';
      case 'QualityEngineer':
        return 'Kalite Mühendisi';
      case 'Operator':
        return 'Operatör';
      default:
        return permission;
    }
  }

  void _addUser() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(userManagementProvider.notifier)
          .addUser(
            kullaniciAdi: _usernameController.text,
            hesapSeviyesi: _selectedPermission,
            personelId: _personelIdController.text.isNotEmpty
                ? int.tryParse(_personelIdController.text)
                : null,
            personelAdi: _fullNameController.text,
          );

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_fullNameController.text} başarıyla eklendi'),
          backgroundColor: AppColors.duzceGreen,
        ),
      );
    }
  }
}

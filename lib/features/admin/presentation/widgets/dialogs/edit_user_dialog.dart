import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../auth/domain/entities/user.dart';
import '../../providers/user_management_provider.dart';

class EditUserDialog extends ConsumerStatefulWidget {
  final User user;

  const EditUserDialog({super.key, required this.user});

  @override
  ConsumerState<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends ConsumerState<EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedPermission;
  final _fullNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedPermission = widget.user.hesapSeviyesi;
    _fullNameController.text = widget.user.personelAdi ?? '';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 450,
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
                      LucideIcons.edit2,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Kullanıcı Düzenle',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Username (read-only)
              TextFormField(
                initialValue: widget.user.kullaniciAdi,
                enabled: false,
                style: const TextStyle(color: AppColors.textSecondary),
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  prefixIcon: const Icon(LucideIcons.atSign, size: 18),
                  filled: true,
                  fillColor: AppColors.background.withValues(alpha: 0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
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
                      onPressed: _updateUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Güncelle'),
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

  void _updateUser() {
    ref
        .read(userManagementProvider.notifier)
        .updateUser(
          widget.user.id,
          hesapSeviyesi: _selectedPermission,
          personelAdi: _fullNameController.text.isNotEmpty
              ? _fullNameController.text
              : null,
        );

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kullanıcı güncellendi'),
        backgroundColor: AppColors.duzceGreen,
      ),
    );
  }
}

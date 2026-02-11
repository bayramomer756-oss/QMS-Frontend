import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing user permission levels
///
/// Permission levels:
/// - 'Admin': Full access, can edit all fields including date/time
/// - 'Manager': Management access, can edit all fields including date/time
/// - 'User': Basic access, can only read date/time fields (read-only)
class UserPermissionNotifier extends Notifier<String> {
  @override
  String build() {
    // Default to 'Admin' for development/testing

    return 'Admin';
  }

  /// Update the current user's permission level
  void setPermission(String permission) {
    if (['Admin', 'Manager', 'User'].contains(permission)) {
      state = permission;
    }
  }

  /// Check if current user can edit forms (Admin or Manager)
  bool canEditForms() {
    return state == 'Admin' || state == 'Manager';
  }

  /// Check if current user is Admin
  bool isAdmin() {
    return state == 'Admin';
  }

  /// Check if current user is Manager
  bool isManager() {
    return state == 'Manager';
  }

  /// Check if current user is basic User
  bool isUser() {
    return state == 'User';
  }
}

/// Global provider instance for user permissions
final userPermissionProvider = NotifierProvider<UserPermissionNotifier, String>(
  () {
    return UserPermissionNotifier();
  },
);

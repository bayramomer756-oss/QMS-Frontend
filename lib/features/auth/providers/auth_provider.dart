import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Kullanıcı rolü enum
enum UserRole { admin, operator }

/// Kullanıcı modeli
class UserModel {
  final String id;
  final String username;
  final String fullName;
  final UserRole role;
  // Yeni Alanlar
  final String? phoneNumber;
  final DateTime? birthDate;
  final String? emergencyContact;

  const UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.role,
    this.phoneNumber,
    this.birthDate,
    this.emergencyContact,
  });

  bool get isAdmin => role == UserRole.admin;
}

/// Auth state
class AuthState {
  final UserModel? currentUser;
  final bool isLoading;
  final String? error;

  const AuthState({this.currentUser, this.isLoading = false, this.error});

  AuthState copyWith({UserModel? currentUser, bool? isLoading, String? error}) {
    return AuthState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Auth notifier - Modern Riverpod 3.x API
class AuthNotifier extends Notifier<AuthState> {
  // Simülasyon için mock kullanıcılar
  final List<UserModel> _mockUsers = [
    UserModel(
      id: '1',
      username: 'admin',
      fullName: 'Admin Kullanıcı',
      role: UserRole.admin,
      phoneNumber: '5551234567',
      birthDate: DateTime(1985, 5, 15),
      emergencyContact: 'Eşi: 5559876543',
    ),
    UserModel(
      id: '2',
      username: 'furkan',
      fullName: 'Furkan Yılmaz',
      role: UserRole.operator,
      phoneNumber: '5321112233',
      birthDate: DateTime(1995, 8, 20),
      emergencyContact: 'Babası: 5334445566',
    ),
    UserModel(
      id: '3',
      username: 'ahmet',
      fullName: 'Ahmet Demir',
      role: UserRole.operator,
      phoneNumber: '5447778899',
      birthDate: DateTime(1998, 3, 10),
      // Bugün doğum günü senaryosu için mock
      // birthDate: DateTime(1998, DateTime.now().month, DateTime.now().day),
      emergencyContact: 'Annesi: 5551112233',
    ),
  ];

  @override
  AuthState build() => const AuthState();

  List<UserModel> get allUsers => _mockUsers;

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    await Future.delayed(const Duration(seconds: 1));

    // Simülasyon: kullanıcı adı eşleşmesi yeterli
    final user = _mockUsers
        .where((u) => u.username.toLowerCase() == username.toLowerCase())
        .firstOrNull;

    if (user != null) {
      state = state.copyWith(currentUser: user, isLoading: false);
      return true;
    } else {
      state = state.copyWith(isLoading: false, error: 'Kullanıcı bulunamadı');
      return false;
    }
  }

  void logout() {
    state = const AuthState();
  }

  // Kullanıcı ekle simülasyonu
  void addUser(UserModel user) {
    _mockUsers.add(user);
    // State güncellemeye gerek yok çünkü allUsers getter'ı kullanılıyor ve listeden çekiliyor
    // Ama gerçek app'te state update gerekir.
    // Burada mock listeyi güncelliyoruz.
  }

  // Kullanıcı güncelle simülasyonu
  void updateUser(UserModel updatedUser) {
    final index = _mockUsers.indexWhere((u) => u.id == updatedUser.id);
    if (index != -1) {
      _mockUsers[index] = updatedUser;
    }
  }

  bool get isAdmin => state.currentUser?.isAdmin ?? false;
}

/// Auth provider
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

/// Current user provider
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).currentUser;
});

/// Is admin provider
final isAdminProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).currentUser?.isAdmin ?? false;
});

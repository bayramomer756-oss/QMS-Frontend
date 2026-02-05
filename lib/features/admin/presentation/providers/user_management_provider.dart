import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/entities/user.dart';

// Mock user state notifier
class UserManagementNotifier extends Notifier<List<User>> {
  @override
  List<User> build() => _generateMockUsers();

  static List<User> _generateMockUsers() {
    return [
      User(
        id: 1,
        kullaniciAdi: 'admin',
        hesapSeviyesi: 'Admin',
        personelId: null,
        personelAdi: 'Admin User',
        kayitTarihi: DateTime(2024, 1, 15),
      ),
      User(
        id: 2,
        kullaniciAdi: 'furkan.yilmaz',
        hesapSeviyesi: 'Inspector',
        personelId: 101,
        personelAdi: 'Furkan Yılmaz',
        kayitTarihi: DateTime(2024, 3, 20),
      ),
      User(
        id: 3,
        kullaniciAdi: 'ahmet.demir',
        hesapSeviyesi: 'Operator',
        personelId: 102,
        personelAdi: 'Ahmet Demir',
        kayitTarihi: DateTime(2024, 5, 10),
      ),
      User(
        id: 4,
        kullaniciAdi: 'mehmet.yilmaz',
        hesapSeviyesi: 'QualityEngineer',
        personelId: 103,
        personelAdi: 'Mehmet Yılmaz',
        kayitTarihi: DateTime(2024, 6, 5),
      ),
      User(
        id: 5,
        kullaniciAdi: 'ali.veli',
        hesapSeviyesi: 'Operator',
        personelId: 104,
        personelAdi: 'Ali Veli',
        kayitTarihi: DateTime(2024, 7, 12),
      ),
    ];
  }

  void addUser({
    required String kullaniciAdi,
    required String hesapSeviyesi,
    int? personelId,
    String? personelAdi,
  }) {
    final newUser = User(
      id: state.isEmpty
          ? 1
          : state.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1,
      kullaniciAdi: kullaniciAdi,
      hesapSeviyesi: hesapSeviyesi,
      personelId: personelId,
      personelAdi: personelAdi,
      kayitTarihi: DateTime.now(),
    );
    state = [...state, newUser];
  }

  void updateUser(int id, {String? hesapSeviyesi, String? personelAdi}) {
    state = state.map((user) {
      if (user.id == id) {
        return User(
          id: user.id,
          kullaniciAdi: user.kullaniciAdi,
          hesapSeviyesi: hesapSeviyesi ?? user.hesapSeviyesi,
          personelId: user.personelId,
          personelAdi: personelAdi ?? user.personelAdi,
          kayitTarihi: user.kayitTarihi,
        );
      }
      return user;
    }).toList();
  }

  void deleteUser(int id) {
    state = state.where((user) => user.id != id).toList();
  }

  void changePassword(int id, String newPassword) {
    // Mock implementation - just show success message
    // In real implementation, this would call API
  }
}

// Provider
final userManagementProvider =
    NotifierProvider<UserManagementNotifier, List<User>>(() {
      return UserManagementNotifier();
    });

// Permission levels
final permissionLevels = ['Admin', 'Inspector', 'Operator', 'QualityEngineer'];

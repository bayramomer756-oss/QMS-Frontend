class User {
  final int id;
  final String kullaniciAdi;
  final String hesapSeviyesi; // Admin, Inspector, Operator, QualityEngineer
  final int? personelId;
  final String? personelAdi;
  final DateTime kayitTarihi;

  User({
    required this.id,
    required this.kullaniciAdi,
    required this.hesapSeviyesi,
    this.personelId,
    this.personelAdi,
    required this.kayitTarihi,
  });

  // Getter properties for English field names (for compatibility with screens)
  String get username => kullaniciAdi;
  String get fullName => personelAdi ?? kullaniciAdi;
  bool get isAdmin => hesapSeviyesi == 'Admin';

  // Note: These fields don't exist in backend yet, return null for now
  DateTime? get birthDate => null;
  String? get phoneNumber => null;
  String? get emergencyContact => null;
}

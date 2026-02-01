import '../../domain/entities/fire_kayit_formu.dart';

class FireKayitFormuDto extends FireKayitFormu {
  FireKayitFormuDto({
    required super.id,
    super.vardiyaId,
    super.vardiyaAdi,
    required super.islemTarihi,
    required super.urunKodu,
    super.sarjNo,
    super.tezgahId,
    super.tezgahNo,
    super.operasyonId,
    super.operasyonAdi,
    super.bolgeId,
    super.bolgeAdi,
    super.retKoduId,
    super.retKodu,
    super.operatorAdi,
    super.aciklama,
    super.fotografYolu,
    required super.kullaniciId,
    super.kullaniciAdi,
    required super.olusturmaZamani,
    super.guncellemeZamani,
  });

  factory FireKayitFormuDto.fromJson(Map<String, dynamic> json) {
    return FireKayitFormuDto(
      id: json['id'] as int,
      vardiyaId: json['vardiyaId'] as int?,
      vardiyaAdi: json['vardiyaAdi'] as String?,
      islemTarihi: DateTime.parse(json['islemTarihi'] as String),
      urunKodu: json['urunKodu'] as String,
      sarjNo: json['sarjNo'] as String?,
      tezgahId: json['tezgahId'] as int?,
      tezgahNo: json['tezgahNo'] as String?,
      operasyonId: json['operasyonId'] as int?,
      operasyonAdi: json['operasyonAdi'] as String?,
      bolgeId: json['bolgeId'] as int?,
      bolgeAdi: json['bolgeAdi'] as String?,
      retKoduId: json['retKoduId'] as int?,
      retKodu: json['retKodu'] as String?,
      operatorAdi: json['operatorAdi'] as String?,
      aciklama: json['aciklama'] as String?,
      fotografYolu: json['fotografYolu'] as String?,
      kullaniciId: json['kullaniciId'] as int,
      kullaniciAdi: json['kullaniciAdi'] as String?,
      olusturmaZamani: DateTime.parse(json['olusturmaZamani'] as String),
      guncellemeZamani: json['guncellemeZamani'] != null
          ? DateTime.parse(json['guncellemeZamani'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vardiyaId': vardiyaId,
      'vardiyaAdi': vardiyaAdi,
      'islemTarihi': islemTarihi.toIso8601String(),
      'urunKodu': urunKodu,
      'sarjNo': sarjNo,
      'tezgahId': tezgahId,
      'tezgahNo': tezgahNo,
      'operasyonId': operasyonId,
      'operasyonAdi': operasyonAdi,
      'bolgeId': bolgeId,
      'bolgeAdi': bolgeAdi,
      'retKoduId': retKoduId,
      'retKodu': retKodu,
      'operatorAdi': operatorAdi,
      'aciklama': aciklama,
      'fotografYolu': fotografYolu,
      'kullaniciId': kullaniciId,
      'kullaniciAdi': kullaniciAdi,
      'olusturmaZamani': olusturmaZamani.toIso8601String(),
      'guncellemeZamani': guncellemeZamani?.toIso8601String(),
    };
  }
}

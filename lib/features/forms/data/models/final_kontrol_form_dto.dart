import '../../domain/entities/final_kontrol_form.dart';

class FinalKontrolFormDto extends FinalKontrolForm {
  FinalKontrolFormDto({
    super.id,
    required super.urunKodu,
    required super.sarjNo,
    required super.paketMiktar,
    required super.hurdaMiktar,
    required super.reworkMiktar,
    super.aciklama,
    required super.kayitTarihi,
  });

  factory FinalKontrolFormDto.fromJson(Map<String, dynamic> json) {
    return FinalKontrolFormDto(
      id: json['id'] as int?,
      urunKodu: json['urunKodu'] as String,
      sarjNo: json['sarjNo'] as String,
      paketMiktar: json['paketMiktar'] as int,
      hurdaMiktar: json['hurdaMiktar'] as int,
      reworkMiktar: json['reworkMiktar'] as int,
      aciklama: json['aciklama'] as String?,
      kayitTarihi: DateTime.parse(json['kayitTarihi'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'urunKodu': urunKodu,
      'sarjNo': sarjNo,
      'paketMiktar': paketMiktar,
      'hurdaMiktar': hurdaMiktar,
      'reworkMiktar': reworkMiktar,
      if (aciklama != null) 'aciklama': aciklama,
      'kayitTarihi': kayitTarihi.toIso8601String(),
    };
  }

  FinalKontrolForm toEntity() {
    return FinalKontrolForm(
      id: id,
      urunKodu: urunKodu,
      sarjNo: sarjNo,
      paketMiktar: paketMiktar,
      hurdaMiktar: hurdaMiktar,
      reworkMiktar: reworkMiktar,
      aciklama: aciklama,
      kayitTarihi: kayitTarihi,
    );
  }
}

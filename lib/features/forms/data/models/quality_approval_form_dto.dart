import '../../domain/entities/quality_approval_form.dart';

class QualityApprovalFormDto extends QualityApprovalForm {
  QualityApprovalFormDto({
    super.id,
    required super.urunKodu,
    required super.urunAdi,
    required super.urunTuru,
    required super.adet,
    required super.uygunlukDurumu,
    super.retKoduId,
    super.aciklama,
    required super.kayitTarihi,
  });

  factory QualityApprovalFormDto.fromJson(Map<String, dynamic> json) {
    return QualityApprovalFormDto(
      id: json['id'] as int?,
      urunKodu: json['urunKodu'] as String,
      urunAdi: json['urunAdi'] as String,
      urunTuru: json['urunTuru'] as String,
      adet: json['adet'] as int,
      uygunlukDurumu: json['uygunlukDurumu'] as String,
      retKoduId: json['retKoduId'] as int?,
      aciklama: json['aciklama'] as String?,
      kayitTarihi: DateTime.parse(json['kayitTarihi'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'urunKodu': urunKodu,
      'urunAdi': urunAdi,
      'urunTuru': urunTuru,
      'adet': adet,
      'uygunlukDurumu': uygunlukDurumu,
      if (retKoduId != null) 'retKoduId': retKoduId,
      if (aciklama != null) 'aciklama': aciklama,
      'kayitTarihi': kayitTarihi.toIso8601String(),
    };
  }

  QualityApprovalForm toEntity() {
    return QualityApprovalForm(
      id: id,
      urunKodu: urunKodu,
      urunAdi: urunAdi,
      urunTuru: urunTuru,
      adet: adet,
      uygunlukDurumu: uygunlukDurumu,
      retKoduId: retKoduId,
      aciklama: aciklama,
      kayitTarihi: kayitTarihi,
    );
  }
}

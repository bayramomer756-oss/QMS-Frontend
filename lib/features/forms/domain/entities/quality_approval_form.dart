class QualityApprovalForm {
  final int? id;
  final String urunKodu;
  final String urunAdi;
  final String urunTuru;
  final int adet;
  final String uygunlukDurumu; // 'Uygun' or 'RET'
  final int? retKoduId;
  final String? aciklama;
  final DateTime kayitTarihi;

  QualityApprovalForm({
    this.id,
    required this.urunKodu,
    required this.urunAdi,
    required this.urunTuru,
    required this.adet,
    required this.uygunlukDurumu,
    this.retKoduId,
    this.aciklama,
    required this.kayitTarihi,
  });
}

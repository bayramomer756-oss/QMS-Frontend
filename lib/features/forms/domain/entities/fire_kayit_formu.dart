class FireKayitFormu {
  final int id;
  final int? vardiyaId;
  final String? vardiyaAdi;
  final DateTime islemTarihi;
  final String urunKodu;
  final String? sarjNo;
  final int? tezgahId;
  final String? tezgahNo;
  final int? operasyonId;
  final String? operasyonAdi;
  final int? bolgeId;
  final String? bolgeAdi;
  final int? retKoduId;
  final String? retKodu;
  final String? operatorAdi;
  final String? aciklama;
  final String? fotografYolu;
  final int kullaniciId;
  final String? kullaniciAdi;
  final DateTime olusturmaZamani;
  final DateTime? guncellemeZamani;

  FireKayitFormu({
    required this.id,
    this.vardiyaId,
    this.vardiyaAdi,
    required this.islemTarihi,
    required this.urunKodu,
    this.sarjNo,
    this.tezgahId,
    this.tezgahNo,
    this.operasyonId,
    this.operasyonAdi,
    this.bolgeId,
    this.bolgeAdi,
    this.retKoduId,
    this.retKodu,
    this.operatorAdi,
    this.aciklama,
    this.fotografYolu,
    required this.kullaniciId,
    this.kullaniciAdi,
    required this.olusturmaZamani,
    this.guncellemeZamani,
  });
}

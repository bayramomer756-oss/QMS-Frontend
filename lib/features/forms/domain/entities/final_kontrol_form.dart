class FinalKontrolForm {
  final int? id;
  final String urunKodu;
  final String sarjNo;
  final int paketMiktar;
  final int hurdaMiktar;
  final int reworkMiktar;
  final String? aciklama;
  final DateTime kayitTarihi;

  FinalKontrolForm({
    this.id,
    required this.urunKodu,
    required this.sarjNo,
    required this.paketMiktar,
    required this.hurdaMiktar,
    required this.reworkMiktar,
    this.aciklama,
    required this.kayitTarihi,
  });
}

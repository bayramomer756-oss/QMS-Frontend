import '../../domain/entities/saf_b9_counter_entry.dart';

class SafB9CounterEntryDto extends SafB9CounterEntry {
  SafB9CounterEntryDto({
    super.id,
    required super.urunKodu,
    required super.urunAdi,
    required super.duzceCount,
    required super.almanyaCount,
    required super.hurdaCount,
    super.retNedeni,
    required super.kayitTarihi,
  });

  factory SafB9CounterEntryDto.fromJson(Map<String, dynamic> json) {
    return SafB9CounterEntryDto(
      id: json['id'] as int?,
      urunKodu: json['urunKodu'] as String,
      urunAdi: json['urunAdi'] as String,
      duzceCount: json['duzceCount'] as int,
      almanyaCount: json['almanyaCount'] as int,
      hurdaCount: json['hurdaCount'] as int,
      retNedeni: json['retNedeni'] as String?,
      kayitTarihi: DateTime.parse(json['kayitTarihi'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'urunKodu': urunKodu,
      'urunAdi': urunAdi,
      'duzceCount': duzceCount,
      'almanyaCount': almanyaCount,
      'hurdaCount': hurdaCount,
      if (retNedeni != null) 'retNedeni': retNedeni,
      'kayitTarihi': kayitTarihi.toIso8601String(),
    };
  }

  SafB9CounterEntry toEntity() {
    return SafB9CounterEntry(
      id: id,
      urunKodu: urunKodu,
      urunAdi: urunAdi,
      duzceCount: duzceCount,
      almanyaCount: almanyaCount,
      hurdaCount: hurdaCount,
      retNedeni: retNedeni,
      kayitTarihi: kayitTarihi,
    );
  }
}

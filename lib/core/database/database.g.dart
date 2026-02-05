// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SiparislerTable extends Siparisler
    with TableInfo<$SiparislerTable, Siparis> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SiparislerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<int> localId = GeneratedColumn<int>(
    'local_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending_insert'),
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _musteriAdiMeta = const VerificationMeta(
    'musteriAdi',
  );
  @override
  late final GeneratedColumn<String> musteriAdi = GeneratedColumn<String>(
    'musteri_adi',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _siparisTarihiMeta = const VerificationMeta(
    'siparisTarihi',
  );
  @override
  late final GeneratedColumn<String> siparisTarihi = GeneratedColumn<String>(
    'siparis_tarihi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toplamTutarMeta = const VerificationMeta(
    'toplamTutar',
  );
  @override
  late final GeneratedColumn<double> toplamTutar = GeneratedColumn<double>(
    'toplam_tutar',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _durumMeta = const VerificationMeta('durum');
  @override
  late final GeneratedColumn<String> durum = GeneratedColumn<String>(
    'durum',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('taslak'),
  );
  static const VerificationMeta _aciklamaMeta = const VerificationMeta(
    'aciklama',
  );
  @override
  late final GeneratedColumn<String> aciklama = GeneratedColumn<String>(
    'aciklama',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _olusturanKullaniciMeta =
      const VerificationMeta('olusturanKullanici');
  @override
  late final GeneratedColumn<String> olusturanKullanici =
      GeneratedColumn<String>(
        'olusturan_kullanici',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    remoteId,
    syncStatus,
    lastModified,
    createdAt,
    musteriAdi,
    siparisTarihi,
    toplamTutar,
    durum,
    aciklama,
    olusturanKullanici,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'siparisler';
  @override
  VerificationContext validateIntegrity(
    Insertable<Siparis> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('musteri_adi')) {
      context.handle(
        _musteriAdiMeta,
        musteriAdi.isAcceptableOrUnknown(data['musteri_adi']!, _musteriAdiMeta),
      );
    } else if (isInserting) {
      context.missing(_musteriAdiMeta);
    }
    if (data.containsKey('siparis_tarihi')) {
      context.handle(
        _siparisTarihiMeta,
        siparisTarihi.isAcceptableOrUnknown(
          data['siparis_tarihi']!,
          _siparisTarihiMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_siparisTarihiMeta);
    }
    if (data.containsKey('toplam_tutar')) {
      context.handle(
        _toplamTutarMeta,
        toplamTutar.isAcceptableOrUnknown(
          data['toplam_tutar']!,
          _toplamTutarMeta,
        ),
      );
    }
    if (data.containsKey('durum')) {
      context.handle(
        _durumMeta,
        durum.isAcceptableOrUnknown(data['durum']!, _durumMeta),
      );
    }
    if (data.containsKey('aciklama')) {
      context.handle(
        _aciklamaMeta,
        aciklama.isAcceptableOrUnknown(data['aciklama']!, _aciklamaMeta),
      );
    }
    if (data.containsKey('olusturan_kullanici')) {
      context.handle(
        _olusturanKullaniciMeta,
        olusturanKullanici.isAcceptableOrUnknown(
          data['olusturan_kullanici']!,
          _olusturanKullaniciMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  Siparis map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Siparis(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      musteriAdi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}musteri_adi'],
      )!,
      siparisTarihi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}siparis_tarihi'],
      )!,
      toplamTutar: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}toplam_tutar'],
      )!,
      durum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}durum'],
      )!,
      aciklama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aciklama'],
      ),
      olusturanKullanici: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}olusturan_kullanici'],
      ),
    );
  }

  @override
  $SiparislerTable createAlias(String alias) {
    return $SiparislerTable(attachedDatabase, alias);
  }
}

class Siparis extends DataClass implements Insertable<Siparis> {
  /// Local unique ID (autoincrement)
  final int localId;

  /// Server'dan gelen gerçek ID
  final String? remoteId;

  /// Senkronizasyon durumu: synced, pending_insert, pending_update, pending_delete
  final String syncStatus;

  /// Son değişiklik zamanı (conflict resolution için)
  final DateTime lastModified;

  /// Oluşturulma zamanı
  final DateTime createdAt;
  final String musteriAdi;
  final String siparisTarihi;
  final double toplamTutar;
  final String durum;
  final String? aciklama;
  final String? olusturanKullanici;
  const Siparis({
    required this.localId,
    this.remoteId,
    required this.syncStatus,
    required this.lastModified,
    required this.createdAt,
    required this.musteriAdi,
    required this.siparisTarihi,
    required this.toplamTutar,
    required this.durum,
    this.aciklama,
    this.olusturanKullanici,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<int>(localId);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['last_modified'] = Variable<DateTime>(lastModified);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['musteri_adi'] = Variable<String>(musteriAdi);
    map['siparis_tarihi'] = Variable<String>(siparisTarihi);
    map['toplam_tutar'] = Variable<double>(toplamTutar);
    map['durum'] = Variable<String>(durum);
    if (!nullToAbsent || aciklama != null) {
      map['aciklama'] = Variable<String>(aciklama);
    }
    if (!nullToAbsent || olusturanKullanici != null) {
      map['olusturan_kullanici'] = Variable<String>(olusturanKullanici);
    }
    return map;
  }

  SiparislerCompanion toCompanion(bool nullToAbsent) {
    return SiparislerCompanion(
      localId: Value(localId),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      syncStatus: Value(syncStatus),
      lastModified: Value(lastModified),
      createdAt: Value(createdAt),
      musteriAdi: Value(musteriAdi),
      siparisTarihi: Value(siparisTarihi),
      toplamTutar: Value(toplamTutar),
      durum: Value(durum),
      aciklama: aciklama == null && nullToAbsent
          ? const Value.absent()
          : Value(aciklama),
      olusturanKullanici: olusturanKullanici == null && nullToAbsent
          ? const Value.absent()
          : Value(olusturanKullanici),
    );
  }

  factory Siparis.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Siparis(
      localId: serializer.fromJson<int>(json['localId']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      musteriAdi: serializer.fromJson<String>(json['musteriAdi']),
      siparisTarihi: serializer.fromJson<String>(json['siparisTarihi']),
      toplamTutar: serializer.fromJson<double>(json['toplamTutar']),
      durum: serializer.fromJson<String>(json['durum']),
      aciklama: serializer.fromJson<String?>(json['aciklama']),
      olusturanKullanici: serializer.fromJson<String?>(
        json['olusturanKullanici'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<int>(localId),
      'remoteId': serializer.toJson<String?>(remoteId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastModified': serializer.toJson<DateTime>(lastModified),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'musteriAdi': serializer.toJson<String>(musteriAdi),
      'siparisTarihi': serializer.toJson<String>(siparisTarihi),
      'toplamTutar': serializer.toJson<double>(toplamTutar),
      'durum': serializer.toJson<String>(durum),
      'aciklama': serializer.toJson<String?>(aciklama),
      'olusturanKullanici': serializer.toJson<String?>(olusturanKullanici),
    };
  }

  Siparis copyWith({
    int? localId,
    Value<String?> remoteId = const Value.absent(),
    String? syncStatus,
    DateTime? lastModified,
    DateTime? createdAt,
    String? musteriAdi,
    String? siparisTarihi,
    double? toplamTutar,
    String? durum,
    Value<String?> aciklama = const Value.absent(),
    Value<String?> olusturanKullanici = const Value.absent(),
  }) => Siparis(
    localId: localId ?? this.localId,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    syncStatus: syncStatus ?? this.syncStatus,
    lastModified: lastModified ?? this.lastModified,
    createdAt: createdAt ?? this.createdAt,
    musteriAdi: musteriAdi ?? this.musteriAdi,
    siparisTarihi: siparisTarihi ?? this.siparisTarihi,
    toplamTutar: toplamTutar ?? this.toplamTutar,
    durum: durum ?? this.durum,
    aciklama: aciklama.present ? aciklama.value : this.aciklama,
    olusturanKullanici: olusturanKullanici.present
        ? olusturanKullanici.value
        : this.olusturanKullanici,
  );
  Siparis copyWithCompanion(SiparislerCompanion data) {
    return Siparis(
      localId: data.localId.present ? data.localId.value : this.localId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      musteriAdi: data.musteriAdi.present
          ? data.musteriAdi.value
          : this.musteriAdi,
      siparisTarihi: data.siparisTarihi.present
          ? data.siparisTarihi.value
          : this.siparisTarihi,
      toplamTutar: data.toplamTutar.present
          ? data.toplamTutar.value
          : this.toplamTutar,
      durum: data.durum.present ? data.durum.value : this.durum,
      aciklama: data.aciklama.present ? data.aciklama.value : this.aciklama,
      olusturanKullanici: data.olusturanKullanici.present
          ? data.olusturanKullanici.value
          : this.olusturanKullanici,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Siparis(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastModified: $lastModified, ')
          ..write('createdAt: $createdAt, ')
          ..write('musteriAdi: $musteriAdi, ')
          ..write('siparisTarihi: $siparisTarihi, ')
          ..write('toplamTutar: $toplamTutar, ')
          ..write('durum: $durum, ')
          ..write('aciklama: $aciklama, ')
          ..write('olusturanKullanici: $olusturanKullanici')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    remoteId,
    syncStatus,
    lastModified,
    createdAt,
    musteriAdi,
    siparisTarihi,
    toplamTutar,
    durum,
    aciklama,
    olusturanKullanici,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Siparis &&
          other.localId == this.localId &&
          other.remoteId == this.remoteId &&
          other.syncStatus == this.syncStatus &&
          other.lastModified == this.lastModified &&
          other.createdAt == this.createdAt &&
          other.musteriAdi == this.musteriAdi &&
          other.siparisTarihi == this.siparisTarihi &&
          other.toplamTutar == this.toplamTutar &&
          other.durum == this.durum &&
          other.aciklama == this.aciklama &&
          other.olusturanKullanici == this.olusturanKullanici);
}

class SiparislerCompanion extends UpdateCompanion<Siparis> {
  final Value<int> localId;
  final Value<String?> remoteId;
  final Value<String> syncStatus;
  final Value<DateTime> lastModified;
  final Value<DateTime> createdAt;
  final Value<String> musteriAdi;
  final Value<String> siparisTarihi;
  final Value<double> toplamTutar;
  final Value<String> durum;
  final Value<String?> aciklama;
  final Value<String?> olusturanKullanici;
  const SiparislerCompanion({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.musteriAdi = const Value.absent(),
    this.siparisTarihi = const Value.absent(),
    this.toplamTutar = const Value.absent(),
    this.durum = const Value.absent(),
    this.aciklama = const Value.absent(),
    this.olusturanKullanici = const Value.absent(),
  });
  SiparislerCompanion.insert({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.createdAt = const Value.absent(),
    required String musteriAdi,
    required String siparisTarihi,
    this.toplamTutar = const Value.absent(),
    this.durum = const Value.absent(),
    this.aciklama = const Value.absent(),
    this.olusturanKullanici = const Value.absent(),
  }) : musteriAdi = Value(musteriAdi),
       siparisTarihi = Value(siparisTarihi);
  static Insertable<Siparis> custom({
    Expression<int>? localId,
    Expression<String>? remoteId,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastModified,
    Expression<DateTime>? createdAt,
    Expression<String>? musteriAdi,
    Expression<String>? siparisTarihi,
    Expression<double>? toplamTutar,
    Expression<String>? durum,
    Expression<String>? aciklama,
    Expression<String>? olusturanKullanici,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (remoteId != null) 'remote_id': remoteId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastModified != null) 'last_modified': lastModified,
      if (createdAt != null) 'created_at': createdAt,
      if (musteriAdi != null) 'musteri_adi': musteriAdi,
      if (siparisTarihi != null) 'siparis_tarihi': siparisTarihi,
      if (toplamTutar != null) 'toplam_tutar': toplamTutar,
      if (durum != null) 'durum': durum,
      if (aciklama != null) 'aciklama': aciklama,
      if (olusturanKullanici != null) 'olusturan_kullanici': olusturanKullanici,
    });
  }

  SiparislerCompanion copyWith({
    Value<int>? localId,
    Value<String?>? remoteId,
    Value<String>? syncStatus,
    Value<DateTime>? lastModified,
    Value<DateTime>? createdAt,
    Value<String>? musteriAdi,
    Value<String>? siparisTarihi,
    Value<double>? toplamTutar,
    Value<String>? durum,
    Value<String?>? aciklama,
    Value<String?>? olusturanKullanici,
  }) {
    return SiparislerCompanion(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      syncStatus: syncStatus ?? this.syncStatus,
      lastModified: lastModified ?? this.lastModified,
      createdAt: createdAt ?? this.createdAt,
      musteriAdi: musteriAdi ?? this.musteriAdi,
      siparisTarihi: siparisTarihi ?? this.siparisTarihi,
      toplamTutar: toplamTutar ?? this.toplamTutar,
      durum: durum ?? this.durum,
      aciklama: aciklama ?? this.aciklama,
      olusturanKullanici: olusturanKullanici ?? this.olusturanKullanici,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (musteriAdi.present) {
      map['musteri_adi'] = Variable<String>(musteriAdi.value);
    }
    if (siparisTarihi.present) {
      map['siparis_tarihi'] = Variable<String>(siparisTarihi.value);
    }
    if (toplamTutar.present) {
      map['toplam_tutar'] = Variable<double>(toplamTutar.value);
    }
    if (durum.present) {
      map['durum'] = Variable<String>(durum.value);
    }
    if (aciklama.present) {
      map['aciklama'] = Variable<String>(aciklama.value);
    }
    if (olusturanKullanici.present) {
      map['olusturan_kullanici'] = Variable<String>(olusturanKullanici.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SiparislerCompanion(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastModified: $lastModified, ')
          ..write('createdAt: $createdAt, ')
          ..write('musteriAdi: $musteriAdi, ')
          ..write('siparisTarihi: $siparisTarihi, ')
          ..write('toplamTutar: $toplamTutar, ')
          ..write('durum: $durum, ')
          ..write('aciklama: $aciklama, ')
          ..write('olusturanKullanici: $olusturanKullanici')
          ..write(')'))
        .toString();
  }
}

class $SiparisKalemleriTable extends SiparisKalemleri
    with TableInfo<$SiparisKalemleriTable, SiparisKalemi> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SiparisKalemleriTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<int> localId = GeneratedColumn<int>(
    'local_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending_insert'),
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _siparisLocalIdMeta = const VerificationMeta(
    'siparisLocalId',
  );
  @override
  late final GeneratedColumn<int> siparisLocalId = GeneratedColumn<int>(
    'siparis_local_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES siparisler (local_id)',
    ),
  );
  static const VerificationMeta _siparisRemoteIdMeta = const VerificationMeta(
    'siparisRemoteId',
  );
  @override
  late final GeneratedColumn<String> siparisRemoteId = GeneratedColumn<String>(
    'siparis_remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urunKoduMeta = const VerificationMeta(
    'urunKodu',
  );
  @override
  late final GeneratedColumn<String> urunKodu = GeneratedColumn<String>(
    'urun_kodu',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urunAdiMeta = const VerificationMeta(
    'urunAdi',
  );
  @override
  late final GeneratedColumn<String> urunAdi = GeneratedColumn<String>(
    'urun_adi',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _miktarMeta = const VerificationMeta('miktar');
  @override
  late final GeneratedColumn<int> miktar = GeneratedColumn<int>(
    'miktar',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _birimFiyatMeta = const VerificationMeta(
    'birimFiyat',
  );
  @override
  late final GeneratedColumn<double> birimFiyat = GeneratedColumn<double>(
    'birim_fiyat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _toplamFiyatMeta = const VerificationMeta(
    'toplamFiyat',
  );
  @override
  late final GeneratedColumn<double> toplamFiyat = GeneratedColumn<double>(
    'toplam_fiyat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    remoteId,
    syncStatus,
    lastModified,
    createdAt,
    siparisLocalId,
    siparisRemoteId,
    urunKodu,
    urunAdi,
    miktar,
    birimFiyat,
    toplamFiyat,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'siparis_kalemleri';
  @override
  VerificationContext validateIntegrity(
    Insertable<SiparisKalemi> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('siparis_local_id')) {
      context.handle(
        _siparisLocalIdMeta,
        siparisLocalId.isAcceptableOrUnknown(
          data['siparis_local_id']!,
          _siparisLocalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_siparisLocalIdMeta);
    }
    if (data.containsKey('siparis_remote_id')) {
      context.handle(
        _siparisRemoteIdMeta,
        siparisRemoteId.isAcceptableOrUnknown(
          data['siparis_remote_id']!,
          _siparisRemoteIdMeta,
        ),
      );
    }
    if (data.containsKey('urun_kodu')) {
      context.handle(
        _urunKoduMeta,
        urunKodu.isAcceptableOrUnknown(data['urun_kodu']!, _urunKoduMeta),
      );
    } else if (isInserting) {
      context.missing(_urunKoduMeta);
    }
    if (data.containsKey('urun_adi')) {
      context.handle(
        _urunAdiMeta,
        urunAdi.isAcceptableOrUnknown(data['urun_adi']!, _urunAdiMeta),
      );
    } else if (isInserting) {
      context.missing(_urunAdiMeta);
    }
    if (data.containsKey('miktar')) {
      context.handle(
        _miktarMeta,
        miktar.isAcceptableOrUnknown(data['miktar']!, _miktarMeta),
      );
    }
    if (data.containsKey('birim_fiyat')) {
      context.handle(
        _birimFiyatMeta,
        birimFiyat.isAcceptableOrUnknown(data['birim_fiyat']!, _birimFiyatMeta),
      );
    }
    if (data.containsKey('toplam_fiyat')) {
      context.handle(
        _toplamFiyatMeta,
        toplamFiyat.isAcceptableOrUnknown(
          data['toplam_fiyat']!,
          _toplamFiyatMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  SiparisKalemi map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SiparisKalemi(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      siparisLocalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}siparis_local_id'],
      )!,
      siparisRemoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}siparis_remote_id'],
      ),
      urunKodu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}urun_kodu'],
      )!,
      urunAdi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}urun_adi'],
      )!,
      miktar: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}miktar'],
      )!,
      birimFiyat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}birim_fiyat'],
      )!,
      toplamFiyat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}toplam_fiyat'],
      )!,
    );
  }

  @override
  $SiparisKalemleriTable createAlias(String alias) {
    return $SiparisKalemleriTable(attachedDatabase, alias);
  }
}

class SiparisKalemi extends DataClass implements Insertable<SiparisKalemi> {
  /// Local unique ID (autoincrement)
  final int localId;

  /// Server'dan gelen gerçek ID
  final String? remoteId;

  /// Senkronizasyon durumu: synced, pending_insert, pending_update, pending_delete
  final String syncStatus;

  /// Son değişiklik zamanı (conflict resolution için)
  final DateTime lastModified;

  /// Oluşturulma zamanı
  final DateTime createdAt;
  final int siparisLocalId;
  final String? siparisRemoteId;
  final String urunKodu;
  final String urunAdi;
  final int miktar;
  final double birimFiyat;
  final double toplamFiyat;
  const SiparisKalemi({
    required this.localId,
    this.remoteId,
    required this.syncStatus,
    required this.lastModified,
    required this.createdAt,
    required this.siparisLocalId,
    this.siparisRemoteId,
    required this.urunKodu,
    required this.urunAdi,
    required this.miktar,
    required this.birimFiyat,
    required this.toplamFiyat,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<int>(localId);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['last_modified'] = Variable<DateTime>(lastModified);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['siparis_local_id'] = Variable<int>(siparisLocalId);
    if (!nullToAbsent || siparisRemoteId != null) {
      map['siparis_remote_id'] = Variable<String>(siparisRemoteId);
    }
    map['urun_kodu'] = Variable<String>(urunKodu);
    map['urun_adi'] = Variable<String>(urunAdi);
    map['miktar'] = Variable<int>(miktar);
    map['birim_fiyat'] = Variable<double>(birimFiyat);
    map['toplam_fiyat'] = Variable<double>(toplamFiyat);
    return map;
  }

  SiparisKalemleriCompanion toCompanion(bool nullToAbsent) {
    return SiparisKalemleriCompanion(
      localId: Value(localId),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      syncStatus: Value(syncStatus),
      lastModified: Value(lastModified),
      createdAt: Value(createdAt),
      siparisLocalId: Value(siparisLocalId),
      siparisRemoteId: siparisRemoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(siparisRemoteId),
      urunKodu: Value(urunKodu),
      urunAdi: Value(urunAdi),
      miktar: Value(miktar),
      birimFiyat: Value(birimFiyat),
      toplamFiyat: Value(toplamFiyat),
    );
  }

  factory SiparisKalemi.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SiparisKalemi(
      localId: serializer.fromJson<int>(json['localId']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      siparisLocalId: serializer.fromJson<int>(json['siparisLocalId']),
      siparisRemoteId: serializer.fromJson<String?>(json['siparisRemoteId']),
      urunKodu: serializer.fromJson<String>(json['urunKodu']),
      urunAdi: serializer.fromJson<String>(json['urunAdi']),
      miktar: serializer.fromJson<int>(json['miktar']),
      birimFiyat: serializer.fromJson<double>(json['birimFiyat']),
      toplamFiyat: serializer.fromJson<double>(json['toplamFiyat']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<int>(localId),
      'remoteId': serializer.toJson<String?>(remoteId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastModified': serializer.toJson<DateTime>(lastModified),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'siparisLocalId': serializer.toJson<int>(siparisLocalId),
      'siparisRemoteId': serializer.toJson<String?>(siparisRemoteId),
      'urunKodu': serializer.toJson<String>(urunKodu),
      'urunAdi': serializer.toJson<String>(urunAdi),
      'miktar': serializer.toJson<int>(miktar),
      'birimFiyat': serializer.toJson<double>(birimFiyat),
      'toplamFiyat': serializer.toJson<double>(toplamFiyat),
    };
  }

  SiparisKalemi copyWith({
    int? localId,
    Value<String?> remoteId = const Value.absent(),
    String? syncStatus,
    DateTime? lastModified,
    DateTime? createdAt,
    int? siparisLocalId,
    Value<String?> siparisRemoteId = const Value.absent(),
    String? urunKodu,
    String? urunAdi,
    int? miktar,
    double? birimFiyat,
    double? toplamFiyat,
  }) => SiparisKalemi(
    localId: localId ?? this.localId,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    syncStatus: syncStatus ?? this.syncStatus,
    lastModified: lastModified ?? this.lastModified,
    createdAt: createdAt ?? this.createdAt,
    siparisLocalId: siparisLocalId ?? this.siparisLocalId,
    siparisRemoteId: siparisRemoteId.present
        ? siparisRemoteId.value
        : this.siparisRemoteId,
    urunKodu: urunKodu ?? this.urunKodu,
    urunAdi: urunAdi ?? this.urunAdi,
    miktar: miktar ?? this.miktar,
    birimFiyat: birimFiyat ?? this.birimFiyat,
    toplamFiyat: toplamFiyat ?? this.toplamFiyat,
  );
  SiparisKalemi copyWithCompanion(SiparisKalemleriCompanion data) {
    return SiparisKalemi(
      localId: data.localId.present ? data.localId.value : this.localId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      siparisLocalId: data.siparisLocalId.present
          ? data.siparisLocalId.value
          : this.siparisLocalId,
      siparisRemoteId: data.siparisRemoteId.present
          ? data.siparisRemoteId.value
          : this.siparisRemoteId,
      urunKodu: data.urunKodu.present ? data.urunKodu.value : this.urunKodu,
      urunAdi: data.urunAdi.present ? data.urunAdi.value : this.urunAdi,
      miktar: data.miktar.present ? data.miktar.value : this.miktar,
      birimFiyat: data.birimFiyat.present
          ? data.birimFiyat.value
          : this.birimFiyat,
      toplamFiyat: data.toplamFiyat.present
          ? data.toplamFiyat.value
          : this.toplamFiyat,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SiparisKalemi(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastModified: $lastModified, ')
          ..write('createdAt: $createdAt, ')
          ..write('siparisLocalId: $siparisLocalId, ')
          ..write('siparisRemoteId: $siparisRemoteId, ')
          ..write('urunKodu: $urunKodu, ')
          ..write('urunAdi: $urunAdi, ')
          ..write('miktar: $miktar, ')
          ..write('birimFiyat: $birimFiyat, ')
          ..write('toplamFiyat: $toplamFiyat')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    remoteId,
    syncStatus,
    lastModified,
    createdAt,
    siparisLocalId,
    siparisRemoteId,
    urunKodu,
    urunAdi,
    miktar,
    birimFiyat,
    toplamFiyat,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SiparisKalemi &&
          other.localId == this.localId &&
          other.remoteId == this.remoteId &&
          other.syncStatus == this.syncStatus &&
          other.lastModified == this.lastModified &&
          other.createdAt == this.createdAt &&
          other.siparisLocalId == this.siparisLocalId &&
          other.siparisRemoteId == this.siparisRemoteId &&
          other.urunKodu == this.urunKodu &&
          other.urunAdi == this.urunAdi &&
          other.miktar == this.miktar &&
          other.birimFiyat == this.birimFiyat &&
          other.toplamFiyat == this.toplamFiyat);
}

class SiparisKalemleriCompanion extends UpdateCompanion<SiparisKalemi> {
  final Value<int> localId;
  final Value<String?> remoteId;
  final Value<String> syncStatus;
  final Value<DateTime> lastModified;
  final Value<DateTime> createdAt;
  final Value<int> siparisLocalId;
  final Value<String?> siparisRemoteId;
  final Value<String> urunKodu;
  final Value<String> urunAdi;
  final Value<int> miktar;
  final Value<double> birimFiyat;
  final Value<double> toplamFiyat;
  const SiparisKalemleriCompanion({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.siparisLocalId = const Value.absent(),
    this.siparisRemoteId = const Value.absent(),
    this.urunKodu = const Value.absent(),
    this.urunAdi = const Value.absent(),
    this.miktar = const Value.absent(),
    this.birimFiyat = const Value.absent(),
    this.toplamFiyat = const Value.absent(),
  });
  SiparisKalemleriCompanion.insert({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.createdAt = const Value.absent(),
    required int siparisLocalId,
    this.siparisRemoteId = const Value.absent(),
    required String urunKodu,
    required String urunAdi,
    this.miktar = const Value.absent(),
    this.birimFiyat = const Value.absent(),
    this.toplamFiyat = const Value.absent(),
  }) : siparisLocalId = Value(siparisLocalId),
       urunKodu = Value(urunKodu),
       urunAdi = Value(urunAdi);
  static Insertable<SiparisKalemi> custom({
    Expression<int>? localId,
    Expression<String>? remoteId,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastModified,
    Expression<DateTime>? createdAt,
    Expression<int>? siparisLocalId,
    Expression<String>? siparisRemoteId,
    Expression<String>? urunKodu,
    Expression<String>? urunAdi,
    Expression<int>? miktar,
    Expression<double>? birimFiyat,
    Expression<double>? toplamFiyat,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (remoteId != null) 'remote_id': remoteId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastModified != null) 'last_modified': lastModified,
      if (createdAt != null) 'created_at': createdAt,
      if (siparisLocalId != null) 'siparis_local_id': siparisLocalId,
      if (siparisRemoteId != null) 'siparis_remote_id': siparisRemoteId,
      if (urunKodu != null) 'urun_kodu': urunKodu,
      if (urunAdi != null) 'urun_adi': urunAdi,
      if (miktar != null) 'miktar': miktar,
      if (birimFiyat != null) 'birim_fiyat': birimFiyat,
      if (toplamFiyat != null) 'toplam_fiyat': toplamFiyat,
    });
  }

  SiparisKalemleriCompanion copyWith({
    Value<int>? localId,
    Value<String?>? remoteId,
    Value<String>? syncStatus,
    Value<DateTime>? lastModified,
    Value<DateTime>? createdAt,
    Value<int>? siparisLocalId,
    Value<String?>? siparisRemoteId,
    Value<String>? urunKodu,
    Value<String>? urunAdi,
    Value<int>? miktar,
    Value<double>? birimFiyat,
    Value<double>? toplamFiyat,
  }) {
    return SiparisKalemleriCompanion(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      syncStatus: syncStatus ?? this.syncStatus,
      lastModified: lastModified ?? this.lastModified,
      createdAt: createdAt ?? this.createdAt,
      siparisLocalId: siparisLocalId ?? this.siparisLocalId,
      siparisRemoteId: siparisRemoteId ?? this.siparisRemoteId,
      urunKodu: urunKodu ?? this.urunKodu,
      urunAdi: urunAdi ?? this.urunAdi,
      miktar: miktar ?? this.miktar,
      birimFiyat: birimFiyat ?? this.birimFiyat,
      toplamFiyat: toplamFiyat ?? this.toplamFiyat,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (siparisLocalId.present) {
      map['siparis_local_id'] = Variable<int>(siparisLocalId.value);
    }
    if (siparisRemoteId.present) {
      map['siparis_remote_id'] = Variable<String>(siparisRemoteId.value);
    }
    if (urunKodu.present) {
      map['urun_kodu'] = Variable<String>(urunKodu.value);
    }
    if (urunAdi.present) {
      map['urun_adi'] = Variable<String>(urunAdi.value);
    }
    if (miktar.present) {
      map['miktar'] = Variable<int>(miktar.value);
    }
    if (birimFiyat.present) {
      map['birim_fiyat'] = Variable<double>(birimFiyat.value);
    }
    if (toplamFiyat.present) {
      map['toplam_fiyat'] = Variable<double>(toplamFiyat.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SiparisKalemleriCompanion(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastModified: $lastModified, ')
          ..write('createdAt: $createdAt, ')
          ..write('siparisLocalId: $siparisLocalId, ')
          ..write('siparisRemoteId: $siparisRemoteId, ')
          ..write('urunKodu: $urunKodu, ')
          ..write('urunAdi: $urunAdi, ')
          ..write('miktar: $miktar, ')
          ..write('birimFiyat: $birimFiyat, ')
          ..write('toplamFiyat: $toplamFiyat')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SiparislerTable siparisler = $SiparislerTable(this);
  late final $SiparisKalemleriTable siparisKalemleri = $SiparisKalemleriTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    siparisler,
    siparisKalemleri,
  ];
}

typedef $$SiparislerTableCreateCompanionBuilder =
    SiparislerCompanion Function({
      Value<int> localId,
      Value<String?> remoteId,
      Value<String> syncStatus,
      Value<DateTime> lastModified,
      Value<DateTime> createdAt,
      required String musteriAdi,
      required String siparisTarihi,
      Value<double> toplamTutar,
      Value<String> durum,
      Value<String?> aciklama,
      Value<String?> olusturanKullanici,
    });
typedef $$SiparislerTableUpdateCompanionBuilder =
    SiparislerCompanion Function({
      Value<int> localId,
      Value<String?> remoteId,
      Value<String> syncStatus,
      Value<DateTime> lastModified,
      Value<DateTime> createdAt,
      Value<String> musteriAdi,
      Value<String> siparisTarihi,
      Value<double> toplamTutar,
      Value<String> durum,
      Value<String?> aciklama,
      Value<String?> olusturanKullanici,
    });

final class $$SiparislerTableReferences
    extends BaseReferences<_$AppDatabase, $SiparislerTable, Siparis> {
  $$SiparislerTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SiparisKalemleriTable, List<SiparisKalemi>>
  _siparisKalemleriRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.siparisKalemleri,
    aliasName: $_aliasNameGenerator(
      db.siparisler.localId,
      db.siparisKalemleri.siparisLocalId,
    ),
  );

  $$SiparisKalemleriTableProcessedTableManager get siparisKalemleriRefs {
    final manager =
        $$SiparisKalemleriTableTableManager($_db, $_db.siparisKalemleri).filter(
          (f) => f.siparisLocalId.localId.sqlEquals(
            $_itemColumn<int>('local_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _siparisKalemleriRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SiparislerTableFilterComposer
    extends Composer<_$AppDatabase, $SiparislerTable> {
  $$SiparislerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get musteriAdi => $composableBuilder(
    column: $table.musteriAdi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siparisTarihi => $composableBuilder(
    column: $table.siparisTarihi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get toplamTutar => $composableBuilder(
    column: $table.toplamTutar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get durum => $composableBuilder(
    column: $table.durum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aciklama => $composableBuilder(
    column: $table.aciklama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get olusturanKullanici => $composableBuilder(
    column: $table.olusturanKullanici,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> siparisKalemleriRefs(
    Expression<bool> Function($$SiparisKalemleriTableFilterComposer f) f,
  ) {
    final $$SiparisKalemleriTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.siparisKalemleri,
      getReferencedColumn: (t) => t.siparisLocalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiparisKalemleriTableFilterComposer(
            $db: $db,
            $table: $db.siparisKalemleri,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SiparislerTableOrderingComposer
    extends Composer<_$AppDatabase, $SiparislerTable> {
  $$SiparislerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get musteriAdi => $composableBuilder(
    column: $table.musteriAdi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siparisTarihi => $composableBuilder(
    column: $table.siparisTarihi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get toplamTutar => $composableBuilder(
    column: $table.toplamTutar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get durum => $composableBuilder(
    column: $table.durum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aciklama => $composableBuilder(
    column: $table.aciklama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get olusturanKullanici => $composableBuilder(
    column: $table.olusturanKullanici,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SiparislerTableAnnotationComposer
    extends Composer<_$AppDatabase, $SiparislerTable> {
  $$SiparislerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get musteriAdi => $composableBuilder(
    column: $table.musteriAdi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get siparisTarihi => $composableBuilder(
    column: $table.siparisTarihi,
    builder: (column) => column,
  );

  GeneratedColumn<double> get toplamTutar => $composableBuilder(
    column: $table.toplamTutar,
    builder: (column) => column,
  );

  GeneratedColumn<String> get durum =>
      $composableBuilder(column: $table.durum, builder: (column) => column);

  GeneratedColumn<String> get aciklama =>
      $composableBuilder(column: $table.aciklama, builder: (column) => column);

  GeneratedColumn<String> get olusturanKullanici => $composableBuilder(
    column: $table.olusturanKullanici,
    builder: (column) => column,
  );

  Expression<T> siparisKalemleriRefs<T extends Object>(
    Expression<T> Function($$SiparisKalemleriTableAnnotationComposer a) f,
  ) {
    final $$SiparisKalemleriTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.siparisKalemleri,
      getReferencedColumn: (t) => t.siparisLocalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiparisKalemleriTableAnnotationComposer(
            $db: $db,
            $table: $db.siparisKalemleri,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SiparislerTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SiparislerTable,
          Siparis,
          $$SiparislerTableFilterComposer,
          $$SiparislerTableOrderingComposer,
          $$SiparislerTableAnnotationComposer,
          $$SiparislerTableCreateCompanionBuilder,
          $$SiparislerTableUpdateCompanionBuilder,
          (Siparis, $$SiparislerTableReferences),
          Siparis,
          PrefetchHooks Function({bool siparisKalemleriRefs})
        > {
  $$SiparislerTableTableManager(_$AppDatabase db, $SiparislerTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SiparislerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SiparislerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SiparislerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> musteriAdi = const Value.absent(),
                Value<String> siparisTarihi = const Value.absent(),
                Value<double> toplamTutar = const Value.absent(),
                Value<String> durum = const Value.absent(),
                Value<String?> aciklama = const Value.absent(),
                Value<String?> olusturanKullanici = const Value.absent(),
              }) => SiparislerCompanion(
                localId: localId,
                remoteId: remoteId,
                syncStatus: syncStatus,
                lastModified: lastModified,
                createdAt: createdAt,
                musteriAdi: musteriAdi,
                siparisTarihi: siparisTarihi,
                toplamTutar: toplamTutar,
                durum: durum,
                aciklama: aciklama,
                olusturanKullanici: olusturanKullanici,
              ),
          createCompanionCallback:
              ({
                Value<int> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                required String musteriAdi,
                required String siparisTarihi,
                Value<double> toplamTutar = const Value.absent(),
                Value<String> durum = const Value.absent(),
                Value<String?> aciklama = const Value.absent(),
                Value<String?> olusturanKullanici = const Value.absent(),
              }) => SiparislerCompanion.insert(
                localId: localId,
                remoteId: remoteId,
                syncStatus: syncStatus,
                lastModified: lastModified,
                createdAt: createdAt,
                musteriAdi: musteriAdi,
                siparisTarihi: siparisTarihi,
                toplamTutar: toplamTutar,
                durum: durum,
                aciklama: aciklama,
                olusturanKullanici: olusturanKullanici,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SiparislerTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({siparisKalemleriRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (siparisKalemleriRefs) db.siparisKalemleri,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (siparisKalemleriRefs)
                    await $_getPrefetchedData<
                      Siparis,
                      $SiparislerTable,
                      SiparisKalemi
                    >(
                      currentTable: table,
                      referencedTable: $$SiparislerTableReferences
                          ._siparisKalemleriRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SiparislerTableReferences(
                            db,
                            table,
                            p0,
                          ).siparisKalemleriRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.siparisLocalId == item.localId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SiparislerTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SiparislerTable,
      Siparis,
      $$SiparislerTableFilterComposer,
      $$SiparislerTableOrderingComposer,
      $$SiparislerTableAnnotationComposer,
      $$SiparislerTableCreateCompanionBuilder,
      $$SiparislerTableUpdateCompanionBuilder,
      (Siparis, $$SiparislerTableReferences),
      Siparis,
      PrefetchHooks Function({bool siparisKalemleriRefs})
    >;
typedef $$SiparisKalemleriTableCreateCompanionBuilder =
    SiparisKalemleriCompanion Function({
      Value<int> localId,
      Value<String?> remoteId,
      Value<String> syncStatus,
      Value<DateTime> lastModified,
      Value<DateTime> createdAt,
      required int siparisLocalId,
      Value<String?> siparisRemoteId,
      required String urunKodu,
      required String urunAdi,
      Value<int> miktar,
      Value<double> birimFiyat,
      Value<double> toplamFiyat,
    });
typedef $$SiparisKalemleriTableUpdateCompanionBuilder =
    SiparisKalemleriCompanion Function({
      Value<int> localId,
      Value<String?> remoteId,
      Value<String> syncStatus,
      Value<DateTime> lastModified,
      Value<DateTime> createdAt,
      Value<int> siparisLocalId,
      Value<String?> siparisRemoteId,
      Value<String> urunKodu,
      Value<String> urunAdi,
      Value<int> miktar,
      Value<double> birimFiyat,
      Value<double> toplamFiyat,
    });

final class $$SiparisKalemleriTableReferences
    extends
        BaseReferences<_$AppDatabase, $SiparisKalemleriTable, SiparisKalemi> {
  $$SiparisKalemleriTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SiparislerTable _siparisLocalIdTable(_$AppDatabase db) =>
      db.siparisler.createAlias(
        $_aliasNameGenerator(
          db.siparisKalemleri.siparisLocalId,
          db.siparisler.localId,
        ),
      );

  $$SiparislerTableProcessedTableManager get siparisLocalId {
    final $_column = $_itemColumn<int>('siparis_local_id')!;

    final manager = $$SiparislerTableTableManager(
      $_db,
      $_db.siparisler,
    ).filter((f) => f.localId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_siparisLocalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SiparisKalemleriTableFilterComposer
    extends Composer<_$AppDatabase, $SiparisKalemleriTable> {
  $$SiparisKalemleriTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siparisRemoteId => $composableBuilder(
    column: $table.siparisRemoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get urunKodu => $composableBuilder(
    column: $table.urunKodu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get urunAdi => $composableBuilder(
    column: $table.urunAdi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get miktar => $composableBuilder(
    column: $table.miktar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get birimFiyat => $composableBuilder(
    column: $table.birimFiyat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get toplamFiyat => $composableBuilder(
    column: $table.toplamFiyat,
    builder: (column) => ColumnFilters(column),
  );

  $$SiparislerTableFilterComposer get siparisLocalId {
    final $$SiparislerTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siparisLocalId,
      referencedTable: $db.siparisler,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiparislerTableFilterComposer(
            $db: $db,
            $table: $db.siparisler,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SiparisKalemleriTableOrderingComposer
    extends Composer<_$AppDatabase, $SiparisKalemleriTable> {
  $$SiparisKalemleriTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siparisRemoteId => $composableBuilder(
    column: $table.siparisRemoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get urunKodu => $composableBuilder(
    column: $table.urunKodu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get urunAdi => $composableBuilder(
    column: $table.urunAdi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get miktar => $composableBuilder(
    column: $table.miktar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get birimFiyat => $composableBuilder(
    column: $table.birimFiyat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get toplamFiyat => $composableBuilder(
    column: $table.toplamFiyat,
    builder: (column) => ColumnOrderings(column),
  );

  $$SiparislerTableOrderingComposer get siparisLocalId {
    final $$SiparislerTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siparisLocalId,
      referencedTable: $db.siparisler,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiparislerTableOrderingComposer(
            $db: $db,
            $table: $db.siparisler,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SiparisKalemleriTableAnnotationComposer
    extends Composer<_$AppDatabase, $SiparisKalemleriTable> {
  $$SiparisKalemleriTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get siparisRemoteId => $composableBuilder(
    column: $table.siparisRemoteId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get urunKodu =>
      $composableBuilder(column: $table.urunKodu, builder: (column) => column);

  GeneratedColumn<String> get urunAdi =>
      $composableBuilder(column: $table.urunAdi, builder: (column) => column);

  GeneratedColumn<int> get miktar =>
      $composableBuilder(column: $table.miktar, builder: (column) => column);

  GeneratedColumn<double> get birimFiyat => $composableBuilder(
    column: $table.birimFiyat,
    builder: (column) => column,
  );

  GeneratedColumn<double> get toplamFiyat => $composableBuilder(
    column: $table.toplamFiyat,
    builder: (column) => column,
  );

  $$SiparislerTableAnnotationComposer get siparisLocalId {
    final $$SiparislerTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siparisLocalId,
      referencedTable: $db.siparisler,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiparislerTableAnnotationComposer(
            $db: $db,
            $table: $db.siparisler,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SiparisKalemleriTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SiparisKalemleriTable,
          SiparisKalemi,
          $$SiparisKalemleriTableFilterComposer,
          $$SiparisKalemleriTableOrderingComposer,
          $$SiparisKalemleriTableAnnotationComposer,
          $$SiparisKalemleriTableCreateCompanionBuilder,
          $$SiparisKalemleriTableUpdateCompanionBuilder,
          (SiparisKalemi, $$SiparisKalemleriTableReferences),
          SiparisKalemi,
          PrefetchHooks Function({bool siparisLocalId})
        > {
  $$SiparisKalemleriTableTableManager(
    _$AppDatabase db,
    $SiparisKalemleriTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SiparisKalemleriTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SiparisKalemleriTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SiparisKalemleriTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> siparisLocalId = const Value.absent(),
                Value<String?> siparisRemoteId = const Value.absent(),
                Value<String> urunKodu = const Value.absent(),
                Value<String> urunAdi = const Value.absent(),
                Value<int> miktar = const Value.absent(),
                Value<double> birimFiyat = const Value.absent(),
                Value<double> toplamFiyat = const Value.absent(),
              }) => SiparisKalemleriCompanion(
                localId: localId,
                remoteId: remoteId,
                syncStatus: syncStatus,
                lastModified: lastModified,
                createdAt: createdAt,
                siparisLocalId: siparisLocalId,
                siparisRemoteId: siparisRemoteId,
                urunKodu: urunKodu,
                urunAdi: urunAdi,
                miktar: miktar,
                birimFiyat: birimFiyat,
                toplamFiyat: toplamFiyat,
              ),
          createCompanionCallback:
              ({
                Value<int> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                required int siparisLocalId,
                Value<String?> siparisRemoteId = const Value.absent(),
                required String urunKodu,
                required String urunAdi,
                Value<int> miktar = const Value.absent(),
                Value<double> birimFiyat = const Value.absent(),
                Value<double> toplamFiyat = const Value.absent(),
              }) => SiparisKalemleriCompanion.insert(
                localId: localId,
                remoteId: remoteId,
                syncStatus: syncStatus,
                lastModified: lastModified,
                createdAt: createdAt,
                siparisLocalId: siparisLocalId,
                siparisRemoteId: siparisRemoteId,
                urunKodu: urunKodu,
                urunAdi: urunAdi,
                miktar: miktar,
                birimFiyat: birimFiyat,
                toplamFiyat: toplamFiyat,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SiparisKalemleriTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({siparisLocalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (siparisLocalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.siparisLocalId,
                                referencedTable:
                                    $$SiparisKalemleriTableReferences
                                        ._siparisLocalIdTable(db),
                                referencedColumn:
                                    $$SiparisKalemleriTableReferences
                                        ._siparisLocalIdTable(db)
                                        .localId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SiparisKalemleriTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SiparisKalemleriTable,
      SiparisKalemi,
      $$SiparisKalemleriTableFilterComposer,
      $$SiparisKalemleriTableOrderingComposer,
      $$SiparisKalemleriTableAnnotationComposer,
      $$SiparisKalemleriTableCreateCompanionBuilder,
      $$SiparisKalemleriTableUpdateCompanionBuilder,
      (SiparisKalemi, $$SiparisKalemleriTableReferences),
      SiparisKalemi,
      PrefetchHooks Function({bool siparisLocalId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SiparislerTableTableManager get siparisler =>
      $$SiparislerTableTableManager(_db, _db.siparisler);
  $$SiparisKalemleriTableTableManager get siparisKalemleri =>
      $$SiparisKalemleriTableTableManager(_db, _db.siparisKalemleri);
}

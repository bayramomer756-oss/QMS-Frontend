import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Modeller ---

class ProductModel {
  final String id;
  final String code;
  final String name;
  final String type; // Enjeksiyon, Montaj vb.

  const ProductModel({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
  });
}

class SimpleDataModel {
  final String id;
  final String code;
  final String? description;

  const SimpleDataModel({
    required this.id,
    required this.code,
    this.description,
  });
}

// --- State ---

class MasterDataState {
  final List<ProductModel> products;
  final List<SimpleDataModel> machines;
  final List<SimpleDataModel> zones;
  final List<SimpleDataModel> defectCodes;
  final List<SimpleDataModel> reworkResults;

  const MasterDataState({
    this.products = const [],
    this.machines = const [],
    this.zones = const [],
    this.defectCodes = const [],
    this.reworkResults = const [],
  });

  MasterDataState copyWith({
    List<ProductModel>? products,
    List<SimpleDataModel>? machines,
    List<SimpleDataModel>? zones,
    List<SimpleDataModel>? defectCodes,
    List<SimpleDataModel>? reworkResults,
  }) {
    return MasterDataState(
      products: products ?? this.products,
      machines: machines ?? this.machines,
      zones: zones ?? this.zones,
      defectCodes: defectCodes ?? this.defectCodes,
      reworkResults: reworkResults ?? this.reworkResults,
    );
  }
}

// --- Notifier ---

class MasterDataNotifier extends Notifier<MasterDataState> {
  @override
  MasterDataState build() {
    return const MasterDataState(
      products: [
        ProductModel(
          id: '1',
          code: '101',
          name: 'Ön Tampon',
          type: 'Enjeksiyon',
        ),
        ProductModel(
          id: '2',
          code: '102',
          name: 'Arka Tampon',
          type: 'Enjeksiyon',
        ),
        ProductModel(id: '3', code: '201', name: 'Kapı Paneli', type: 'Montaj'),
      ],
      machines: [
        SimpleDataModel(id: '1', code: 'Enj-01'),
        SimpleDataModel(id: '2', code: 'Enj-02'),
        SimpleDataModel(id: '3', code: 'Mon-A1'),
      ],
      zones: [
        SimpleDataModel(id: '1', code: 'A1', description: 'Sol Üst'),
        SimpleDataModel(id: '2', code: 'A2', description: 'Sağ Üst'),
        SimpleDataModel(id: '3', code: 'B1', description: 'Merkez'),
      ],
      defectCodes: [
        SimpleDataModel(id: '1', code: 'H01', description: 'Çizik'),
        SimpleDataModel(id: '2', code: 'H02', description: 'Leke'),
        SimpleDataModel(id: '3', code: 'H03', description: 'Çapak'),
      ],
      reworkResults: [
        SimpleDataModel(id: '1', code: 'Tamir Edildi'),
        SimpleDataModel(id: '2', code: 'Hurda'),
        SimpleDataModel(id: '3', code: 'Şartlı Kabul'),
      ],
    );
  }

  // --- Actions ---

  // Product
  void addProduct(String code, String name, String type) {
    final newProduct = ProductModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      code: code,
      name: name,
      type: type,
    );
    state = state.copyWith(products: [...state.products, newProduct]);
  }

  void removeProduct(String id) {
    state = state.copyWith(
      products: state.products.where((p) => p.id != id).toList(),
    );
  }

  // Machine
  void addMachine(String code) {
    final newItem = SimpleDataModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      code: code,
    );
    state = state.copyWith(machines: [...state.machines, newItem]);
  }

  void removeMachine(String id) {
    state = state.copyWith(
      machines: state.machines.where((m) => m.id != id).toList(),
    );
  }

  // Zone
  void addZone(String code, String description) {
    final newItem = SimpleDataModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      code: code,
      description: description,
    );
    state = state.copyWith(zones: [...state.zones, newItem]);
  }

  void removeZone(String id) {
    state = state.copyWith(
      zones: state.zones.where((z) => z.id != id).toList(),
    );
  }

  // Defect
  void addDefect(String code, String description) {
    final newItem = SimpleDataModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      code: code,
      description: description,
    );
    state = state.copyWith(defectCodes: [...state.defectCodes, newItem]);
  }

  void removeDefect(String id) {
    state = state.copyWith(
      defectCodes: state.defectCodes.where((d) => d.id != id).toList(),
    );
  }

  // Rework Result
  void addReworkResult(String code) {
    final newItem = SimpleDataModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      code: code,
    );
    state = state.copyWith(reworkResults: [...state.reworkResults, newItem]);
  }

  void removeReworkResult(String id) {
    state = state.copyWith(
      reworkResults: state.reworkResults.where((r) => r.id != id).toList(),
    );
  }
}

// --- Provider ---

final masterDataProvider =
    NotifierProvider<MasterDataNotifier, MasterDataState>(() {
      return MasterDataNotifier();
    });

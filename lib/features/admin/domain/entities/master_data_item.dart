class MasterDataItem {
  final int id;
  final String category;
  final String code;
  final String? description;
  final bool isActive;
  final DateTime createdAt;

  MasterDataItem({
    required this.id,
    required this.category,
    required this.code,
    this.description,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  MasterDataItem copyWith({
    int? id,
    String? category,
    String? code,
    String? description,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return MasterDataItem(
      id: id ?? this.id,
      category: category ?? this.category,
      code: code ?? this.code,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SellerProduct {
  final String id;
  final String name;
  final String sku;
  final String imageUrl;
  final double price;
  final int stock;
  final String category;
  final String description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SellerProduct({
    required this.id,
    required this.name,
    required this.sku,
    required this.imageUrl,
    required this.price,
    required this.stock,
    required this.category,
    required this.description,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  SellerProduct copyWith({
    String? id,
    String? name,
    String? sku,
    String? imageUrl,
    double? price,
    int? stock,
    String? category,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SellerProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

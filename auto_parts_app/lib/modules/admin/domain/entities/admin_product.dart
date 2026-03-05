import 'product_category.dart';

enum ProductStatus { draft, active, inactive, discontinued }

extension ProductStatusExt on ProductStatus {
  String get label {
    switch (this) {
      case ProductStatus.draft:
        return 'Rascunho';
      case ProductStatus.active:
        return 'Ativo';
      case ProductStatus.inactive:
        return 'Inativo';
      case ProductStatus.discontinued:
        return 'Descontinuado';
    }
  }
}

class AdminProduct {
  final String id;
  final String name;
  final String code;
  final String description;
  final String longDescription;
  final double price;
  final double? promotionalPrice;
  final int stock;
  final int minStock;
  final String imageUrl;
  final List<String> additionalImages;
  final ProductCategory category;
  final ProductStatus status;
  final String supplierId;
  final String supplierName;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final Map<String, String> specifications;
  final bool isNewProduct;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? sku;
  final String? barcode;
  final double? weight;
  final String? dimensions;
  final int? guaranteeMonths;

  const AdminProduct({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.longDescription,
    required this.price,
    this.promotionalPrice,
    required this.stock,
    required this.minStock,
    required this.imageUrl,
    this.additionalImages = const [],
    required this.category,
    this.status = ProductStatus.draft,
    required this.supplierId,
    required this.supplierName,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.tags = const [],
    this.specifications = const {},
    this.isNewProduct = false,
    required this.createdAt,
    required this.updatedAt,
    this.sku,
    this.barcode,
    this.weight,
    this.dimensions,
    this.guaranteeMonths,
  });

  // Getters úteis
  bool get hasPromotion =>
      promotionalPrice != null && promotionalPrice! < price;
  double get discountPercentage {
    if (!hasPromotion) return 0;
    return ((price - promotionalPrice!) / price * 100);
  }

  double get finalPrice => promotionalPrice ?? price;

  bool get isLowStock => stock <= minStock;
  bool get outOfStock => stock == 0;

  factory AdminProduct.fromMap(Map<String, dynamic> map) {
    return AdminProduct(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      description: map['description'] as String,
      longDescription: map['longDescription'] as String? ?? '',
      price: (map['price'] as num).toDouble(),
      promotionalPrice: map['promotionalPrice'] != null
          ? (map['promotionalPrice'] as num).toDouble()
          : null,
      stock: map['stock'] as int,
      minStock: map['minStock'] as int? ?? 10,
      imageUrl: map['imageUrl'] as String,
      additionalImages:
          List<String>.from(map['additionalImages'] as List? ?? []),
      category: ProductCategory.values[map['category'] as int? ?? 0],
      status: ProductStatus.values[map['status'] as int? ?? 0],
      supplierId: map['supplierId'] as String,
      supplierName: map['supplierName'] as String,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] as int? ?? 0,
      tags: List<String>.from(map['tags'] as List? ?? []),
      specifications:
          Map<String, String>.from(map['specifications'] as Map? ?? {}),
      isNewProduct: map['isNewProduct'] as bool? ?? false,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      sku: map['sku'] as String?,
      barcode: map['barcode'] as String?,
      weight: map['weight'] != null ? (map['weight'] as num).toDouble() : null,
      dimensions: map['dimensions'] as String?,
      guaranteeMonths: map['guaranteeMonths'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'longDescription': longDescription,
      'price': price,
      'promotionalPrice': promotionalPrice,
      'stock': stock,
      'minStock': minStock,
      'imageUrl': imageUrl,
      'additionalImages': additionalImages,
      'category': category.index,
      'status': status.index,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'rating': rating,
      'reviewCount': reviewCount,
      'tags': tags,
      'specifications': specifications,
      'isNewProduct': isNewProduct,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sku': sku,
      'barcode': barcode,
      'weight': weight,
      'dimensions': dimensions,
      'guaranteeMonths': guaranteeMonths,
    };
  }

  AdminProduct copyWith({
    String? id,
    String? name,
    String? code,
    String? description,
    String? longDescription,
    double? price,
    double? promotionalPrice,
    int? stock,
    int? minStock,
    String? imageUrl,
    List<String>? additionalImages,
    ProductCategory? category,
    ProductStatus? status,
    String? supplierId,
    String? supplierName,
    double? rating,
    int? reviewCount,
    List<String>? tags,
    Map<String, String>? specifications,
    bool? isNewProduct,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? sku,
    String? barcode,
    double? weight,
    String? dimensions,
    int? guaranteeMonths,
  }) {
    return AdminProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      longDescription: longDescription ?? this.longDescription,
      price: price ?? this.price,
      promotionalPrice: promotionalPrice ?? this.promotionalPrice,
      stock: stock ?? this.stock,
      minStock: minStock ?? this.minStock,
      imageUrl: imageUrl ?? this.imageUrl,
      additionalImages: additionalImages ?? this.additionalImages,
      category: category ?? this.category,
      status: status ?? this.status,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      tags: tags ?? this.tags,
      specifications: specifications ?? this.specifications,
      isNewProduct: isNewProduct ?? this.isNewProduct,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      weight: weight ?? this.weight,
      dimensions: dimensions ?? this.dimensions,
      guaranteeMonths: guaranteeMonths ?? this.guaranteeMonths,
    );
  }
}

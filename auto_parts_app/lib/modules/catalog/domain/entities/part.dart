class Compatibility {
  final String brand;
  final String model;
  final int yearFrom;
  final int yearTo;

  const Compatibility({
    required this.brand,
    required this.model,
    required this.yearFrom,
    required this.yearTo,
  });

  factory Compatibility.fromMap(Map<String, dynamic> map) {
    return Compatibility(
      brand: map['brand'] as String,
      model: map['model'] as String,
      yearFrom: map['yearFrom'] as int,
      yearTo: map['yearTo'] as int,
    );
  }

  bool isCompatibleWith(String brand, String model, int year) {
    return this.brand.toLowerCase() == brand.toLowerCase() &&
        this.model.toLowerCase() == model.toLowerCase() &&
        year >= yearFrom &&
        year <= yearTo;
  }
}

class Review {
  final String author;
  final double rating;
  final String comment;
  final String date;

  const Review({
    required this.author,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      author: map['author'] as String,
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'] as String,
      date: map['date'] as String,
    );
  }
}

class Part {
  final String id;
  final String name;
  final String code;
  final String description;
  final double price;
  final int stock;
  final String imageUrl;
  final String category;
  final String supplierId;
  final String supplierName;
  final List<Compatibility> compatibilities;
  final List<Review> reviews;
  final double rating;

  const Part({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.category,
    required this.supplierId,
    required this.supplierName,
    required this.compatibilities,
    required this.reviews,
    required this.rating,
  });

  factory Part.fromMap(Map<String, dynamic> map) {
    return Part(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      stock: map['stock'] as int,
      imageUrl: map['imageUrl'] as String,
      category: map['category'] as String,
      supplierId: map['supplierId'] as String,
      supplierName: map['supplierName'] as String,
      compatibilities: (map['compatibilities'] as List)
          .map((e) => Compatibility.fromMap(e as Map<String, dynamic>))
          .toList(),
      reviews: (map['reviews'] as List)
          .map((e) => Review.fromMap(e as Map<String, dynamic>))
          .toList(),
      rating: (map['rating'] as num).toDouble(),
    );
  }

  bool get isAvailable => stock > 0;

  String get compatibilityText {
    if (compatibilities.isEmpty) return 'Universal';
    final first = compatibilities.first;
    final years = first.yearFrom == first.yearTo
        ? '${first.yearFrom}'
        : '${first.yearFrom}-${first.yearTo}';
    return '${first.brand} ${first.model} $years';
  }
}

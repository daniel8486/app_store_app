class Review {
  final String id;
  final String userId;
  final String userName;
  final String productId;
  final String productName;
  final double rating; // 1-5
  final String comment;
  final DateTime createdAt;
  final int helpfulCount;
  final List<String> images; // URLs de imagens do review

  const Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.productId,
    required this.productName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.helpfulCount = 0,
    this.images = const [],
  });

  Review copyWith({
    String? id,
    String? userId,
    String? userName,
    String? productId,
    String? productName,
    double? rating,
    String? comment,
    DateTime? createdAt,
    int? helpfulCount,
    List<String>? images,
  }) {
    return Review(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      images: images ?? this.images,
    );
  }
}

class SellerCoupon {
  final String id;
  final String code;
  final String description;
  final double discountValue;
  final DiscountType discountType; // percentage or fixed
  final double minOrderValue;
  final DateTime expiryDate;
  final DateTime createdAt;
  final int usedCount;
  final bool isActive;

  const SellerCoupon({
    required this.id,
    required this.code,
    required this.description,
    required this.discountValue,
    required this.discountType,
    this.minOrderValue = 0,
    required this.expiryDate,
    required this.createdAt,
    this.usedCount = 0,
    this.isActive = true,
  });

  bool get isExpired => DateTime.now().isAfter(expiryDate);

  SellerCoupon copyWith({
    String? id,
    String? code,
    String? description,
    double? discountValue,
    DiscountType? discountType,
    double? minOrderValue,
    DateTime? expiryDate,
    DateTime? createdAt,
    int? usedCount,
    bool? isActive,
  }) {
    return SellerCoupon(
      id: id ?? this.id,
      code: code ?? this.code,
      description: description ?? this.description,
      discountValue: discountValue ?? this.discountValue,
      discountType: discountType ?? this.discountType,
      minOrderValue: minOrderValue ?? this.minOrderValue,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
      usedCount: usedCount ?? this.usedCount,
      isActive: isActive ?? this.isActive,
    );
  }
}

enum DiscountType { percentage, fixed }

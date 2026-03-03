class Coupon {
  final String id;
  final String code;
  final String description;
  final double discountValue; // Valor do desconto
  final DiscountType discountType; // Percentual ou fixo
  final double minOrderValue; // Valor mínimo do pedido
  final int maxUses; // Máximo de usos totais
  final int usedCount; // Quantas vezes foi usado
  final DateTime expiryDate;
  final DateTime createdAt;
  final List<String> applicableProductIds; // Vazio = aplica a tudo
  final bool isActive;

  const Coupon({
    required this.id,
    required this.code,
    required this.description,
    required this.discountValue,
    required this.discountType,
    this.minOrderValue = 0,
    this.maxUses = 999,
    this.usedCount = 0,
    required this.expiryDate,
    required this.createdAt,
    this.applicableProductIds = const [],
    this.isActive = true,
  });

  bool get isExpired => DateTime.now().isAfter(expiryDate);
  bool get isMaxUsesReached => usedCount >= maxUses;
  bool get isValid => isActive && !isExpired && !isMaxUsesReached;

  bool isApplicableToProduct(String productId) {
    if (applicableProductIds.isEmpty) return true;
    return applicableProductIds.contains(productId);
  }

  double getDiscountAmount(double subtotal) {
    if (subtotal < minOrderValue) return 0;

    switch (discountType) {
      case DiscountType.percentage:
        return (subtotal * discountValue) / 100;
      case DiscountType.fixed:
        return discountValue;
    }
  }

  Coupon copyWith({
    String? id,
    String? code,
    String? description,
    double? discountValue,
    DiscountType? discountType,
    double? minOrderValue,
    int? maxUses,
    int? usedCount,
    DateTime? expiryDate,
    DateTime? createdAt,
    List<String>? applicableProductIds,
    bool? isActive,
  }) {
    return Coupon(
      id: id ?? this.id,
      code: code ?? this.code,
      description: description ?? this.description,
      discountValue: discountValue ?? this.discountValue,
      discountType: discountType ?? this.discountType,
      minOrderValue: minOrderValue ?? this.minOrderValue,
      maxUses: maxUses ?? this.maxUses,
      usedCount: usedCount ?? this.usedCount,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
      applicableProductIds: applicableProductIds ?? this.applicableProductIds,
      isActive: isActive ?? this.isActive,
    );
  }
}

enum DiscountType { percentage, fixed }

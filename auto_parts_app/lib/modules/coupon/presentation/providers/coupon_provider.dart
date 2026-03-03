import 'package:riverpod/riverpod.dart';
import '../../../coupon/domain/entities/coupon.dart';

// Mock coupons data
final _mockCoupons = <Coupon>[
  Coupon(
    id: '1',
    code: 'WELCOME10',
    description: 'Desconto de 10% na primeira compra',
    discountValue: 10,
    discountType: DiscountType.percentage,
    minOrderValue: 50,
    expiryDate: DateTime.now().add(Duration(days: 30)),
    createdAt: DateTime.now().subtract(Duration(days: 5)),
    isActive: true,
  ),
  Coupon(
    id: '2',
    code: 'BLACKFRIDAY20',
    description: 'Black Friday: 20% OFF em produtos selecionados',
    discountValue: 20,
    discountType: DiscountType.percentage,
    minOrderValue: 100,
    expiryDate: DateTime.now().add(Duration(days: 15)),
    createdAt: DateTime.now().subtract(Duration(days: 10)),
    isActive: true,
  ),
  Coupon(
    id: '3',
    code: 'FRETE50',
    description: 'R\$ 50 de desconto no frete',
    discountValue: 50,
    discountType: DiscountType.fixed,
    minOrderValue: 200,
    expiryDate: DateTime.now().add(Duration(days: 7)),
    createdAt: DateTime.now().subtract(Duration(days: 1)),
    isActive: true,
  ),
  Coupon(
    id: '4',
    code: 'SAVE25',
    description: '25% desconto em óleos e filtros',
    discountValue: 25,
    discountType: DiscountType.percentage,
    minOrderValue: 80,
    applicableProductIds: ['2', '6'], // Óleo e Filtro
    expiryDate: DateTime.now().add(Duration(days: 20)),
    createdAt: DateTime.now().subtract(Duration(days: 3)),
    isActive: true,
  ),
];

// Todos os cupons disponíveis
final availableCouponsProvider = FutureProvider<List<Coupon>>((ref) async {
  await Future.delayed(Duration(milliseconds: 500));
  return _mockCoupons.where((coupon) => coupon.isValid).toList();
});

// Validar um cupom específico
final validateCouponProvider =
    FutureProvider.family<Coupon?, String>((ref, code) async {
  await Future.delayed(Duration(milliseconds: 300));

  final coupon = _mockCoupons.firstWhere(
    (c) => c.code.toUpperCase() == code.toUpperCase() && c.isValid,
    orElse: () => throw Exception('Cupom inválido ou expirado'),
  );

  return coupon;
});

// Aplicar cupom (retorna o desconto)
final applyCouponProvider =
    FutureProvider.family<double, ({String code, double subtotal})>(
        (ref, params) async {
  final coupon = await ref.watch(validateCouponProvider(params.code).future);

  if (coupon == null) {
    throw Exception('Cupom não encontrado');
  }

  return coupon.getDiscountAmount(params.subtotal);
});

// Provider mutável para cupom selecionado
final selectedCouponProvider = StateProvider<Coupon?>((ref) {
  return null;
});

// Listar cupons por categoria (aplicáveis a um produto específico)
final couponsByProductProvider =
    FutureProvider.family<List<Coupon>, String>((ref, productId) async {
  await Future.delayed(Duration(milliseconds: 500));
  return _mockCoupons
      .where(
          (coupon) => coupon.isValid && coupon.isApplicableToProduct(productId))
      .toList();
});

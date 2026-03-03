import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/seller_repository.dart';
import '../../domain/entities/seller_product.dart';
import '../../domain/entities/seller_coupon.dart';
import '../../../order/presentation/providers/order_provider.dart';
import '../../../order/domain/entities/order.dart';

final sellerRepositoryProvider = Provider<SellerRepository>((ref) {
  final orderRepo = ref.read(orderRepositoryProvider);
  return SellerRepository(orderRepo);
});

final sellerOrdersProvider =
    FutureProvider.autoDispose<List<AppOrder>>((ref) async {
  final repo = ref.read(sellerRepositoryProvider);
  return repo.getAllOrders();
});

final sellerDashboardProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final repo = ref.read(sellerRepositoryProvider);
  return repo.getDashboardStats();
});

final sellerInventoryProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.read(sellerRepositoryProvider);
  return repo.getInventory();
});

final sellerProfileProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final repo = ref.read(sellerRepositoryProvider);
  return repo.getSellerProfile();
});

final sellerIsLoggedInProvider = StateProvider<bool>((ref) => false);

final updateOrderStatusProvider = Provider<UpdateOrderStatusService>((ref) {
  return UpdateOrderStatusService(ref);
});

class UpdateOrderStatusService {
  final Ref _ref;

  UpdateOrderStatusService(this._ref);

  Future<void> update(String orderId, OrderStatus status) async {
    final repo = _ref.read(sellerRepositoryProvider);
    await repo.updateOrderStatus(orderId, status);
    _ref.invalidate(sellerOrdersProvider);
    _ref.invalidate(allOrdersProvider);
  }
}

// ── Providers de Produtos ──────────────────────────────
final sellerProductByIdProvider = FutureProvider.autoDispose
    .family<SellerProduct?, String>((ref, productId) async {
  final repo = ref.read(sellerRepositoryProvider);
  return repo.getProductById(productId);
});

final createSellerProductProvider = FutureProvider.autoDispose
    .family<SellerProduct, SellerProduct>((ref, product) async {
  final repo = ref.read(sellerRepositoryProvider);
  final created = await repo.createProduct(product);
  ref.invalidate(sellerInventoryProvider);
  return created;
});

final updateSellerProductProvider = FutureProvider.autoDispose
    .family<SellerProduct, SellerProduct>((ref, product) async {
  final repo = ref.read(sellerRepositoryProvider);
  final updated = await repo.updateProduct(product);
  ref.invalidate(sellerInventoryProvider);
  return updated;
});

final deleteSellerProductProvider =
    FutureProvider.autoDispose.family<void, String>((ref, productId) async {
  final repo = ref.read(sellerRepositoryProvider);
  await repo.deleteProduct(productId);
  ref.invalidate(sellerInventoryProvider);
});

final updateStockProvider =
    FutureProvider.autoDispose.family<void, (String, int)>((ref, params) async {
  final repo = ref.read(sellerRepositoryProvider);
  await repo.updateStock(params.$1, params.$2);
  ref.invalidate(sellerInventoryProvider);
});

// ── Providers de Cupons ────────────────────────────────
final sellerCouponsProvider =
    FutureProvider.autoDispose<List<SellerCoupon>>((ref) async {
  final repo = ref.read(sellerRepositoryProvider);
  return repo.getSellerCoupons();
});

final createSellerCouponProvider = FutureProvider.autoDispose
    .family<SellerCoupon, SellerCoupon>((ref, coupon) async {
  final repo = ref.read(sellerRepositoryProvider);
  final created = await repo.createCoupon(coupon);
  ref.invalidate(sellerCouponsProvider);
  return created;
});

final updateSellerCouponProvider = FutureProvider.autoDispose
    .family<SellerCoupon, SellerCoupon>((ref, coupon) async {
  final repo = ref.read(sellerRepositoryProvider);
  final updated = await repo.updateCoupon(coupon);
  ref.invalidate(sellerCouponsProvider);
  return updated;
});

final deleteSellerCouponProvider =
    FutureProvider.autoDispose.family<void, String>((ref, couponId) async {
  final repo = ref.read(sellerRepositoryProvider);
  await repo.deleteCoupon(couponId);
  ref.invalidate(sellerCouponsProvider);
});

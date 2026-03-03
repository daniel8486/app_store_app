import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/repositories/order_repository.dart';
import '../../domain/entities/order.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../delivery/data/repositories/delivery_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});

final _uuid = const Uuid();

final userOrdersProvider =
    FutureProvider.autoDispose<List<AppOrder>>((ref) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return [];
  final repo = ref.read(orderRepositoryProvider);
  return repo.getOrdersByUser(user.id);
});

final allOrdersProvider = FutureProvider.autoDispose<List<AppOrder>>((ref) async {
  final repo = ref.read(orderRepositoryProvider);
  return repo.getAllOrders();
});

final orderByIdProvider =
    FutureProvider.autoDispose.family<AppOrder?, String>((ref, id) async {
  final repo = ref.read(orderRepositoryProvider);
  return repo.getOrderById(id);
});

final createOrderProvider = Provider<CreateOrderService>((ref) {
  return CreateOrderService(ref);
});

class CreateOrderService {
  final Ref _ref;

  CreateOrderService(this._ref);

  Future<AppOrder> createOrder({
    required List<CartItem> items,
    required String paymentMethod,
    required String city,
  }) async {
    final user = _ref.read(currentUserProvider).value;
    if (user == null) throw Exception('Usuário não autenticado');

    final repo = _ref.read(orderRepositoryProvider);
    final shipping = DeliveryRepository.shippingCost(city);
    final subtotal = items.fold<double>(0, (sum, i) => sum + i.total);
    final total = subtotal + shipping;

    final order = AppOrder(
      id: _uuid.v4(),
      userId: user.id,
      items: items.map((i) => OrderItem.fromPart(i.part, i.quantity)).toList(),
      subtotal: subtotal,
      shipping: shipping,
      total: total,
      status: OrderStatus.received,
      paymentMethod: paymentMethod,
      city: city,
      createdAt: DateTime.now(),
    );

    await repo.saveOrder(order);
    return order;
  }
}

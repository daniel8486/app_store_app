import '../../domain/entities/delivery.dart';
import '../../../order/data/repositories/order_repository.dart';

class DeliveryRepository {
  final OrderRepository _orderRepository;

  DeliveryRepository(this._orderRepository);

  Stream<DeliveryTracking> trackOrder(String orderId) async* {
    while (true) {
      final order = await _orderRepository.getOrderById(orderId);
      if (order == null) return;
      yield DeliveryTracking.fromOrder(orderId, order.status);
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  static double shippingCost(String city) {
    const costs = {
      'São Paulo': 15.00,
      'Rio de Janeiro': 20.00,
      'Belo Horizonte': 18.00,
      'Brasília': 25.00,
      'Porto Alegre': 22.00,
      'Curitiba': 20.00,
      'Salvador': 28.00,
      'Fortaleza': 30.00,
    };
    return costs[city] ?? 30.00;
  }

  static List<String> availableCities() {
    return [
      'São Paulo',
      'Rio de Janeiro',
      'Belo Horizonte',
      'Brasília',
      'Porto Alegre',
      'Curitiba',
      'Salvador',
      'Fortaleza',
      'Outro',
    ];
  }
}

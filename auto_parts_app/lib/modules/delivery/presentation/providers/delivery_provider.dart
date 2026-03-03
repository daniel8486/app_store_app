import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/delivery_repository.dart';
import '../../domain/entities/delivery.dart';
import '../../../order/presentation/providers/order_provider.dart';

final deliveryRepositoryProvider = Provider<DeliveryRepository>((ref) {
  final orderRepo = ref.read(orderRepositoryProvider);
  return DeliveryRepository(orderRepo);
});

final trackingProvider =
    StreamProvider.autoDispose.family<DeliveryTracking, String>((ref, orderId) {
  final repo = ref.read(deliveryRepositoryProvider);
  return repo.trackOrder(orderId);
});

final citiesProvider = Provider<List<String>>((ref) {
  return DeliveryRepository.availableCities();
});

final selectedCityProvider = StateProvider<String>((ref) => 'São Paulo');

final shippingCostProvider = Provider<double>((ref) {
  final city = ref.watch(selectedCityProvider);
  return DeliveryRepository.shippingCost(city);
});

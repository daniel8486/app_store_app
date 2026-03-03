import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/cart_repository.dart';
import '../../domain/entities/cart_item.dart';
import '../../../catalog/domain/entities/part.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository();
});

final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier(ref.read(cartRepositoryProvider));
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  final CartRepository _repo;

  CartNotifier(this._repo) : super([]);

  void addItem(Part part, {int quantity = 1}) {
    _repo.addItem(part, quantity: quantity);
    state = List.from(_repo.getItems());
  }

  void updateQuantity(String itemId, int quantity) {
    _repo.updateQuantity(itemId, quantity);
    state = List.from(_repo.getItems());
  }

  void removeItem(String itemId) {
    _repo.removeItem(itemId);
    state = List.from(_repo.getItems());
  }

  void clearCart() {
    _repo.clearCart();
    state = [];
  }

  double get subtotal => state.fold(0, (sum, i) => sum + i.total);
  int get itemCount => state.fold(0, (sum, i) => sum + i.quantity);
}

final cartSubtotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0, (sum, i) => sum + i.total);
});

final cartItemCountProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0, (sum, i) => sum + i.quantity);
});

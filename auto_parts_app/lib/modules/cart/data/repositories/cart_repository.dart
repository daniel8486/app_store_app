import '../../domain/entities/cart_item.dart';
import '../../../catalog/domain/entities/part.dart';
import 'package:uuid/uuid.dart';

class CartRepository {
  final _items = <CartItem>[];
  final _uuid = const Uuid();

  List<CartItem> getItems() => List.unmodifiable(_items);

  void addItem(Part part, {int quantity = 1}) {
    final existing = _findByPartId(part.id);
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _items.add(CartItem(
        id: _uuid.v4(),
        part: part,
        quantity: quantity,
      ));
    }
  }

  void updateQuantity(String itemId, int quantity) {
    final item = _findById(itemId);
    if (item != null) {
      if (quantity <= 0) {
        _items.removeWhere((i) => i.id == itemId);
      } else {
        item.quantity = quantity;
      }
    }
  }

  void removeItem(String itemId) {
    _items.removeWhere((i) => i.id == itemId);
  }

  void clearCart() {
    _items.clear();
  }

  double get subtotal => _items.fold(0, (sum, i) => sum + i.total);

  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);

  CartItem? _findById(String id) {
    try {
      return _items.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  CartItem? _findByPartId(String partId) {
    try {
      return _items.firstWhere((i) => i.part.id == partId);
    } catch (_) {
      return null;
    }
  }
}

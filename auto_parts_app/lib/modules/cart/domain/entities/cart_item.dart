import '../../../catalog/domain/entities/part.dart';

class CartItem {
  final String id;
  final Part part;
  int quantity;

  CartItem({
    required this.id,
    required this.part,
    required this.quantity,
  });

  double get total => part.price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      part: part,
      quantity: quantity ?? this.quantity,
    );
  }
}

import '../../../catalog/domain/entities/part.dart';

enum OrderStatus {
  received,
  preparing,
  shipped,
  outForDelivery,
  delivered,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.received:
        return 'Pedido recebido';
      case OrderStatus.preparing:
        return 'Separando';
      case OrderStatus.shipped:
        return 'Enviado';
      case OrderStatus.outForDelivery:
        return 'Saiu para entrega';
      case OrderStatus.delivered:
        return 'Entregue';
    }
  }

  int get step => index;
}

class OrderItem {
  final String partId;
  final String partName;
  final String partCode;
  final double unitPrice;
  final int quantity;
  final String supplierId;
  final String supplierName;

  const OrderItem({
    required this.partId,
    required this.partName,
    required this.partCode,
    required this.unitPrice,
    required this.quantity,
    required this.supplierId,
    required this.supplierName,
  });

  double get total => unitPrice * quantity;

  factory OrderItem.fromPart(Part part, int quantity) {
    return OrderItem(
      partId: part.id,
      partName: part.name,
      partCode: part.code,
      unitPrice: part.price,
      quantity: quantity,
      supplierId: part.supplierId,
      supplierName: part.supplierName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'partId': partId,
      'partName': partName,
      'partCode': partCode,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'supplierId': supplierId,
      'supplierName': supplierName,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      partId: map['partId'] as String,
      partName: map['partName'] as String,
      partCode: map['partCode'] as String,
      unitPrice: (map['unitPrice'] as num).toDouble(),
      quantity: map['quantity'] as int,
      supplierId: map['supplierId'] as String,
      supplierName: map['supplierName'] as String,
    );
  }
}

class AppOrder {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double subtotal;
  final double shipping;
  final double total;
  final OrderStatus status;
  final String paymentMethod;
  final String city;
  final DateTime createdAt;

  const AppOrder({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.city,
    required this.createdAt,
  });

  AppOrder copyWith({OrderStatus? status}) {
    return AppOrder(
      id: id,
      userId: userId,
      items: items,
      subtotal: subtotal,
      shipping: shipping,
      total: total,
      status: status ?? this.status,
      paymentMethod: paymentMethod,
      city: city,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((e) => e.toMap()).toList(),
      'subtotal': subtotal,
      'shipping': shipping,
      'total': total,
      'status': status.index,
      'paymentMethod': paymentMethod,
      'city': city,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AppOrder.fromMap(Map<String, dynamic> map) {
    return AppOrder(
      id: map['id'] as String,
      userId: map['userId'] as String,
      items: (map['items'] as List)
          .map((e) => OrderItem.fromMap(e as Map<String, dynamic>))
          .toList(),
      subtotal: (map['subtotal'] as num).toDouble(),
      shipping: (map['shipping'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
      status: OrderStatus.values[map['status'] as int],
      paymentMethod: map['paymentMethod'] as String,
      city: map['city'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}

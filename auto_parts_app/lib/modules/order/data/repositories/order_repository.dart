import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/order.dart';

class OrderRepository {
  static const _ordersKey = 'orders';

  Future<List<AppOrder>> getOrdersByUser(String userId) async {
    final all = await _getAllOrders();
    return all.where((o) => o.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<List<AppOrder>> getAllOrders() async {
    final all = await _getAllOrders();
    return all..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<AppOrder?> getOrderById(String id) async {
    final all = await _getAllOrders();
    try {
      return all.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveOrder(AppOrder order) async {
    final all = await _getAllOrders();
    final idx = all.indexWhere((o) => o.id == order.id);
    if (idx >= 0) {
      all[idx] = order;
    } else {
      all.add(order);
    }
    await _persist(all);
  }

  Future<void> updateStatus(String orderId, OrderStatus status) async {
    final all = await _getAllOrders();
    final idx = all.indexWhere((o) => o.id == orderId);
    if (idx >= 0) {
      all[idx] = all[idx].copyWith(status: status);
      await _persist(all);
    }
  }

  Future<List<AppOrder>> _getAllOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_ordersKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => AppOrder.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<void> _persist(List<AppOrder> orders) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _ordersKey,
      jsonEncode(orders.map((o) => o.toMap()).toList()),
    );
  }
}

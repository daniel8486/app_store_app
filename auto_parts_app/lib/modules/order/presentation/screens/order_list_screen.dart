import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/order_provider.dart';
import '../../domain/entities/order.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class OrderListScreen extends ConsumerWidget {
  final bool embedded;
  const OrderListScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final ordersAsync = ref.watch(userOrdersProvider);

    // Se não logado
    if (userAsync.value == null) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: embedded ? null : AppBar(title: const Text('Meus pedidos')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.receipt_long_outlined,
                      size: 64, color: AppTheme.primaryColor),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Faça login para ver seus pedidos',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('ENTRAR'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: embedded ? null : AppBar(title: const Text('Meus pedidos')),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.receipt_long_outlined,
                      size: 40,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhum pedido ainda',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Seus pedidos aparecerão aqui',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppTheme.accentColor,
            onRefresh: () async => ref.invalidate(userOrdersProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (_, i) => _OrderCard(order: orders[i]),
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final AppOrder order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => context.push('/orders/${order.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${order.id.substring(0, 8).toUpperCase()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppTheme.primaryColor,
                      fontFamily: 'monospace',
                    ),
                  ),
                  _StatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.shopping_bag_outlined,
                      size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    '${order.items.length} iten(s)',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.attach_money,
                      size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 2),
                  Text(
                    Formatters.currency(order.total),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                Formatters.dateTime(order.createdAt),
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.local_shipping_outlined,
                      size: 15, color: AppTheme.accentColor),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => context.push('/tracking/${order.id}'),
                    child: const Text(
                      'Rastrear pedido',
                      style: TextStyle(
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right,
                      size: 16, color: AppTheme.accentColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final OrderStatus status;

  const _StatusChip({required this.status});

  Color get _color {
    switch (status) {
      case OrderStatus.received:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.shipped:
        return Colors.purple;
      case OrderStatus.outForDelivery:
        return Colors.teal;
      case OrderStatus.delivered:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.4)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 11,
          color: _color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

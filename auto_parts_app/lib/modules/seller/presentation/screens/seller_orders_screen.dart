import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/seller_provider.dart';
import '../../../order/domain/entities/order.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';

class SellerOrdersScreen extends ConsumerWidget {
  final bool embedded;

  const SellerOrdersScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(sellerOrdersProvider);

    final body = ordersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erro: $e')),
      data: (orders) {
        if (orders.isEmpty) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.inbox_outlined,
                      size: 40, color: AppTheme.primaryColor),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nenhum pedido encontrado',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppTheme.accentColor,
          onRefresh: () async => ref.invalidate(sellerOrdersProvider),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (_, i) => _SellerOrderCard(order: orders[i]),
          ),
        );
      },
    );

    if (embedded) return body;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Gerenciar pedidos')),
      body: body,
    );
  }
}

class _SellerOrderCard extends StatelessWidget {
  final AppOrder order;

  const _SellerOrderCard({required this.order});

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
        onTap: () => context.push('/seller/orders/${order.id}'),
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
                      fontFamily: 'monospace',
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  _StatusBadge(status: order.status),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.shopping_bag_outlined,
                      size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    '${order.items.length} iten(s) · ${Formatters.currency(order.total)}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    '${order.city} · ${order.paymentMethod}',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                Formatters.dateTime(order.createdAt),
                style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Ver detalhes',
                    style: TextStyle(
                      color: AppTheme.accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
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

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const _StatusBadge({required this.status});

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

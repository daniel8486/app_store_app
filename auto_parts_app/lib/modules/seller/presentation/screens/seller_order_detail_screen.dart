import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/seller_provider.dart';
import '../../../order/presentation/providers/order_provider.dart';
import '../../../order/domain/entities/order.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';

class SellerOrderDetailScreen extends ConsumerWidget {
  final String orderId;

  const SellerOrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderByIdProvider(orderId));

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Detalhes do pedido')),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (order) {
          if (order == null) {
            return const Center(child: Text('Pedido não encontrado'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '#${order.id.substring(0, 8).toUpperCase()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'monospace',
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            Formatters.dateTime(order.createdAt),
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 12),
                          ),
                        ],
                      ),
                      _StatusBadge(status: order.status),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Status update
                const Text(
                  'Alterar status',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
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
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: OrderStatus.values.map((status) {
                      final isActive = order.status == status;
                      return GestureDetector(
                        onTap: isActive
                            ? null
                            : () async {
                                await ref
                                    .read(updateOrderStatusProvider)
                                    .update(orderId, status);
                                ref.invalidate(orderByIdProvider(orderId));
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Status: ${status.label}'),
                                      backgroundColor: Colors.green.shade700,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                  );
                                }
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppTheme.primaryColor
                                : AppTheme.primaryColor.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? Colors.white
                                  : AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Items
                const Text(
                  'Itens do pedido',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                ...order.items.map(
                  (item) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${item.quantity}x',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: AppTheme.accentColor,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        item.partName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      subtitle: Text(
                        '${item.partCode} · ${item.supplierName}',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 11),
                      ),
                      trailing: Text(
                        Formatters.currency(item.total),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Order info
                Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informações do pedido',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _InfoRow('Cidade', order.city),
                      const SizedBox(height: 4),
                      _InfoRow('Pagamento', order.paymentMethod),
                      const SizedBox(height: 4),
                      _InfoRow('Frete', Formatters.currency(order.shipping)),
                      const SizedBox(height: 4),
                      _InfoRow('Subtotal', Formatters.currency(order.subtotal)),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          Text(
                            Formatters.currency(order.total),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        Text(value,
            style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 13)),
      ],
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

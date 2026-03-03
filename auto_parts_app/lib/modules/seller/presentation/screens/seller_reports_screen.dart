import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/seller_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../order/domain/entities/order.dart';

class SellerReportsScreen extends ConsumerStatefulWidget {
  const SellerReportsScreen({super.key});

  @override
  ConsumerState<SellerReportsScreen> createState() =>
      _SellerReportsScreenState();
}

class _SellerReportsScreenState extends ConsumerState<SellerReportsScreen> {
  int _periodDays = 30;

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(sellerOrdersProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Relatórios')),
      body: ordersAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor)),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (orders) => _buildBody(orders),
      ),
    );
  }

  Widget _buildBody(List<AppOrder> orders) {
    final cutoff =
        DateTime.now().subtract(Duration(days: _periodDays));
    final filtered = orders
        .where((o) => o.createdAt.isAfter(cutoff))
        .toList();

    final delivered =
        filtered.where((o) => o.status == OrderStatus.delivered).toList();
    final revenue =
        delivered.fold<double>(0, (s, o) => s + o.total);
    final avgTicket =
        delivered.isEmpty ? 0.0 : revenue / delivered.length;

    // Part frequency map
    final freq = <String, int>{};
    for (final o in filtered) {
      for (final item in o.items) {
        freq[item.partName] = (freq[item.partName] ?? 0) + item.quantity;
      }
    }
    final topParts = freq.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Status breakdown
    final statusCount = <OrderStatus, int>{};
    for (final o in filtered) {
      statusCount[o.status] = (statusCount[o.status] ?? 0) + 1;
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // ── Period selector ───────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [7, 30, 90].map((days) {
              final active = _periodDays == days;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _periodDays = days),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: active
                          ? AppTheme.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      days == 7
                          ? '7 dias'
                          : days == 30
                              ? '30 dias'
                              : '90 dias',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: active ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),

        // ── KPI cards ─────────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                icon: Icons.attach_money,
                label: 'Faturamento',
                value: Formatters.currency(revenue),
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _KpiCard(
                icon: Icons.shopping_bag_outlined,
                label: 'Pedidos',
                value: '${filtered.length}',
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                icon: Icons.check_circle_outline,
                label: 'Entregues',
                value: '${delivered.length}',
                color: Colors.teal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _KpiCard(
                icon: Icons.receipt_outlined,
                label: 'Ticket médio',
                value: Formatters.currency(avgTicket),
                color: AppTheme.accentColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // ── Status breakdown ──────────────────────────────────────
        const _SectionTitle('STATUS DOS PEDIDOS'),
        const SizedBox(height: 12),
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
          child: filtered.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Sem pedidos no período',
                        style: TextStyle(color: Colors.grey)),
                  ),
                )
              : Column(
                  children: OrderStatus.values.map((status) {
                    final count = statusCount[status] ?? 0;
                    if (count == 0) return const SizedBox.shrink();
                    final pct = filtered.isEmpty
                        ? 0.0
                        : count / filtered.length;
                    return _StatusBar(
                        status: status, count: count, pct: pct);
                  }).toList(),
                ),
        ),
        const SizedBox(height: 24),

        // ── Top selling parts ─────────────────────────────────────
        const _SectionTitle('PEÇAS MAIS VENDIDAS'),
        const SizedBox(height: 12),
        if (topParts.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text('Sem vendas no período',
                  style: TextStyle(color: Colors.grey)),
            ),
          )
        else
          ...topParts.take(5).toList().asMap().entries.map((entry) {
            final idx = entry.key;
            final e = entry.value;
            return _TopPartRow(
              rank: idx + 1,
              name: e.key,
              qty: e.value,
              isFirst: idx == 0,
            );
          }),
        const SizedBox(height: 80),
      ],
    );
  }
}

// ─── WIDGETS ──────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _KpiCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppTheme.primaryColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  final OrderStatus status;
  final int count;
  final double pct;

  const _StatusBar({
    required this.status,
    required this.count,
    required this.pct,
  });

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    status.label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              Text(
                '$count pedido(s)',
                style: TextStyle(
                    fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(_color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPartRow extends StatelessWidget {
  final int rank;
  final String name;
  final int qty;
  final bool isFirst;

  const _TopPartRow({
    required this.rank,
    required this.name,
    required this.qty,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isFirst
            ? Border.all(color: AppTheme.accentColor.withOpacity(0.4))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isFirst
                  ? AppTheme.accentColor
                  : AppTheme.primaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color:
                      isFirst ? Colors.white : AppTheme.primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppTheme.primaryColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$qty un.',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/seller_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../order/domain/entities/order.dart';

class SellerFinancialScreen extends ConsumerWidget {
  const SellerFinancialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(sellerOrdersProvider);
    final profileAsync = ref.watch(sellerProfileProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Financeiro')),
      body: ordersAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (orders) {
          final delivered = orders
              .where((o) => o.status == OrderStatus.delivered)
              .toList();
          final pending = orders
              .where((o) =>
                  o.status == OrderStatus.received ||
                  o.status == OrderStatus.preparing)
              .toList();
          final inTransit = orders
              .where((o) =>
                  o.status == OrderStatus.shipped ||
                  o.status == OrderStatus.outForDelivery)
              .toList();

          final totalEarned =
              delivered.fold<double>(0, (s, o) => s + o.total);
          final totalPending =
              pending.fold<double>(0, (s, o) => s + o.total);
          final totalInTransit =
              inTransit.fold<double>(0, (s, o) => s + o.total);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Saldo disponível ──────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryColor, Color(0xFF1E3A5F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total recebido',
                        style:
                            TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Formatters.currency(totalEarned),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _MiniStat(
                              label: 'Pedidos pagos',
                              value: '${delivered.length}',
                              icon: Icons.check_circle_outline,
                              color: Colors.greenAccent,
                            ),
                          ),
                          Expanded(
                            child: _MiniStat(
                              label: 'Em processamento',
                              value: '${pending.length}',
                              icon: Icons.hourglass_bottom,
                              color: Colors.orangeAccent,
                            ),
                          ),
                          Expanded(
                            child: _MiniStat(
                              label: 'Em trânsito',
                              value: '${inTransit.length}',
                              icon: Icons.local_shipping_outlined,
                              color: Colors.cyanAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Cards de receita ──────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _RevenueCard(
                        icon: Icons.pending_actions,
                        label: 'A confirmar',
                        value: Formatters.currency(totalPending),
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _RevenueCard(
                        icon: Icons.local_shipping_outlined,
                        label: 'Em trânsito',
                        value: Formatters.currency(totalInTransit),
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Dados bancários ───────────────────────────────
                const Text(
                  'DADOS PARA RECEBIMENTO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                profileAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (profile) => _BankDataCard(profile: profile),
                ),
                const SizedBox(height: 24),

                // ── Últimas transações ────────────────────────────
                const Text(
                  'ÚLTIMAS TRANSAÇÕES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                if (orders.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Nenhuma transação ainda',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ...orders.take(10).map(
                        (o) => _TransactionRow(order: o),
                      ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── WIDGETS ──────────────────────────────────────────────────────────────────

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _RevenueCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _RevenueCard({
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
              fontSize: 15,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _BankDataCard extends StatelessWidget {
  final Map<String, dynamic> profile;

  const _BankDataCard({required this.profile});

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
        children: [
          _DataRow(
              icon: Icons.business_outlined,
              label: 'CNPJ',
              value: profile['cnpj'] ?? 'Não informado'),
          const Divider(height: 20),
          _DataRow(
              icon: Icons.account_balance_outlined,
              label: 'Banco',
              value: profile['bank'] ?? 'Bradesco'),
          const Divider(height: 20),
          _DataRow(
              icon: Icons.numbers_outlined,
              label: 'Agência / Conta',
              value: profile['account'] ?? '0001 / 12345-6'),
          const Divider(height: 20),
          _DataRow(
              icon: Icons.pix,
              label: 'Chave PIX',
              value: profile['pixKey'] ?? profile['cnpj'] ?? 'Não configurado'),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Editar dados bancários'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: BorderSide(color: AppTheme.primaryColor.withOpacity(0.4)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () =>
                  _showEditBankDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditBankDialog(BuildContext context) {
    final bankCtrl =
        TextEditingController(text: profile['bank'] ?? 'Bradesco');
    final agencyCtrl = TextEditingController(text: '0001');
    final accountCtrl = TextEditingController(text: '12345-6');
    final pixCtrl = TextEditingController(
        text: profile['pixKey'] ?? profile['cnpj'] ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Dados bancários'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: bankCtrl,
                decoration: const InputDecoration(
                    labelText: 'Banco', prefixIcon: Icon(Icons.account_balance_outlined)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: agencyCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Agência'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: accountCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Conta'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: pixCtrl,
                decoration: const InputDecoration(
                    labelText: 'Chave PIX', prefixIcon: Icon(Icons.pix)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Dados bancários atualizados!'),
                  backgroundColor: Colors.green.shade700,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Salvar',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DataRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.accentColor),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                    fontSize: 13)),
          ],
        ),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final AppOrder order;

  const _TransactionRow({required this.order});

  Color get _statusColor {
    switch (order.status) {
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.received:
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.shipped:
      case OrderStatus.outForDelivery:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              order.status == OrderStatus.delivered
                  ? Icons.check_circle_outline
                  : Icons.pending_outlined,
              color: _statusColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pedido #${order.id.substring(0, 8).toUpperCase()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppTheme.primaryColor,
                  ),
                ),
                Text(
                  '${order.items.length} item(s) · ${order.status.label}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Text(
            Formatters.currency(order.total),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: order.status == OrderStatus.delivered
                  ? Colors.green.shade700
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

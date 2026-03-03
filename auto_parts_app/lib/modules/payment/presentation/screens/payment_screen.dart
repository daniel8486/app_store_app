import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/payment_provider.dart';
import '../../domain/entities/payment.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../delivery/presentation/providers/delivery_provider.dart';
import '../../../order/presentation/providers/order_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentStateProvider);
    final selectedMethod = ref.watch(selectedPaymentMethodProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final shipping = ref.watch(shippingCostProvider);
    final city = ref.watch(selectedCityProvider);
    final total = subtotal + shipping;

    if (paymentState == PaymentState.processing) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppTheme.accentColor),
              SizedBox(height: 24),
              Text(
                'Processando pagamento...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.primaryColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Aguarde um momento',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Pagamento')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Summary card
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
                    'Resumo do pedido',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SummaryRow('Subtotal', Formatters.currency(subtotal)),
                  const SizedBox(height: 4),
                  _SummaryRow('Frete ($city)', Formatters.currency(shipping)),
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
                          fontSize: 16,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      Text(
                        Formatters.currency(total),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Forma de pagamento',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 12),

            _PaymentMethodTile(
              icon: Icons.qr_code_2,
              title: 'Pix',
              subtitle: 'Aprovação imediata',
              selected: selectedMethod == PaymentMethod.pix,
              onTap: () => ref
                  .read(selectedPaymentMethodProvider.notifier)
                  .state = PaymentMethod.pix,
            ),
            const SizedBox(height: 10),
            _PaymentMethodTile(
              icon: Icons.credit_card,
              title: 'Cartão de crédito',
              subtitle: 'Aprovação em até 2 segundos',
              selected: selectedMethod == PaymentMethod.creditCard,
              onTap: () => ref
                  .read(selectedPaymentMethodProvider.notifier)
                  .state = PaymentMethod.creditCard,
            ),
            const SizedBox(height: 10),
            _PaymentMethodTile(
              icon: Icons.receipt_long,
              title: 'Boleto',
              subtitle: 'Vencimento em 3 dias úteis',
              selected: selectedMethod == PaymentMethod.boleto,
              onTap: () => ref
                  .read(selectedPaymentMethodProvider.notifier)
                  .state = PaymentMethod.boleto,
            ),
            const SizedBox(height: 32),

            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.lock_outline, color: Colors.white),
                label: Text(
                  'PAGAR ${Formatters.currency(total)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () =>
                    _processPayment(context, ref, selectedMethod, total, city),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processPayment(
    BuildContext context,
    WidgetRef ref,
    PaymentMethod method,
    double total,
    String city,
  ) async {
    try {
      final payment = await ref.read(paymentStateProvider.notifier).process(
            method: method,
            amount: total,
          );

      final items = ref.read(cartProvider);
      final order = await ref.read(createOrderProvider).createOrder(
            items: items,
            paymentMethod: payment.method.label,
            city: city,
          );

      ref.read(cartProvider.notifier).clearCart();
      ref.read(paymentStateProvider.notifier).reset();

      if (context.mounted) {
        context.go('/payment/success', extra: order.id);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryColor.withOpacity(0.06)
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected ? AppTheme.primaryColor : Colors.grey.shade200,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? []
              : [
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
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primaryColor.withOpacity(0.12)
                    : const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color:
                    selected ? AppTheme.primaryColor : Colors.grey.shade500,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          selected ? AppTheme.primaryColor : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? AppTheme.primaryColor : Colors.grey.shade300,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        Text(value,
            style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String orderId;

  const PaymentSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Success icon
              Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 64,
                    color: Colors.green.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              const Text(
                'Pagamento aprovado!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Seu pedido foi recebido e está sendo processado.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),

              // Order number box
              Container(
                padding: const EdgeInsets.all(20),
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
                    Text(
                      'Número do pedido',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '#${orderId.substring(0, 8).toUpperCase()}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        fontFamily: 'monospace',
                        letterSpacing: 3,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Rastrear button
              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.local_shipping_outlined,
                      color: Colors.white),
                  label: const Text(
                    'ACOMPANHAR PEDIDO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () => context.go('/tracking/$orderId'),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 55,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () => context.go('/home'),
                  child: const Text(
                    'CONTINUAR COMPRANDO',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

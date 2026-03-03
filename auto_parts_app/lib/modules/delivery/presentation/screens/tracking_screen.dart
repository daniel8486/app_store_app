import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/delivery_provider.dart';
import '../../domain/entities/delivery.dart';
import '../../../order/domain/entities/order.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';

class TrackingScreen extends ConsumerWidget {
  final String orderId;

  const TrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackingAsync = ref.watch(trackingProvider(orderId));

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Rastreamento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(trackingProvider(orderId)),
          ),
        ],
      ),
      body: trackingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (tracking) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status header card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.local_shipping,
                          size: 26,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tracking.currentStatus.label,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Pedido #${orderId.substring(0, 8).toUpperCase()}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Histórico de eventos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),

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
                    children: tracking.steps.asMap().entries.map((entry) {
                      final i = entry.key;
                      final step = entry.value;
                      final isLast = i == tracking.steps.length - 1;
                      return _TrackingStep(step: step, isLast: isLast);
                    }).toList(),
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

class _TrackingStep extends StatelessWidget {
  final DeliveryStep step;
  final bool isLast;

  const _TrackingStep({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final completed = step.isCompleted;
    final activeColor = completed ? Colors.green.shade600 : Colors.grey.shade300;

    return IntrinsicHeight(
      child: Row(
        children: [
          // Timeline column
          Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completed ? Colors.green.shade600 : Colors.grey.shade100,
                  border: Border.all(color: activeColor, width: 2),
                ),
                child: completed
                    ? const Icon(Icons.check, size: 15, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: completed
                        ? Colors.green.shade300
                        : Colors.grey.shade200,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: completed
                          ? AppTheme.primaryColor
                          : Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    step.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: completed
                          ? Colors.grey.shade600
                          : Colors.grey.shade400,
                    ),
                  ),
                  if (step.completedAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      Formatters.dateTime(step.completedAt!),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

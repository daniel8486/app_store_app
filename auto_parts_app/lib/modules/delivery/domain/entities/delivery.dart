import '../../../order/domain/entities/order.dart';

class DeliveryStep {
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? completedAt;

  const DeliveryStep({
    required this.title,
    required this.description,
    required this.isCompleted,
    this.completedAt,
  });
}

class DeliveryTracking {
  final String orderId;
  final List<DeliveryStep> steps;
  final OrderStatus currentStatus;

  const DeliveryTracking({
    required this.orderId,
    required this.steps,
    required this.currentStatus,
  });

  static DeliveryTracking fromOrder(String orderId, OrderStatus status) {
    final now = DateTime.now();
    final steps = [
      DeliveryStep(
        title: 'Pedido recebido',
        description: 'Seu pedido foi recebido e está sendo processado.',
        isCompleted: status.index >= OrderStatus.received.index,
        completedAt: status.index >= OrderStatus.received.index ? now.subtract(const Duration(hours: 4)) : null,
      ),
      DeliveryStep(
        title: 'Separando',
        description: 'O lojista está separando seus produtos.',
        isCompleted: status.index >= OrderStatus.preparing.index,
        completedAt: status.index >= OrderStatus.preparing.index ? now.subtract(const Duration(hours: 2)) : null,
      ),
      DeliveryStep(
        title: 'Enviado',
        description: 'Seu pedido foi entregue à transportadora.',
        isCompleted: status.index >= OrderStatus.shipped.index,
        completedAt: status.index >= OrderStatus.shipped.index ? now.subtract(const Duration(hours: 1)) : null,
      ),
      DeliveryStep(
        title: 'Saiu para entrega',
        description: 'O entregador está a caminho com o seu pedido.',
        isCompleted: status.index >= OrderStatus.outForDelivery.index,
        completedAt: status.index >= OrderStatus.outForDelivery.index ? now.subtract(const Duration(minutes: 30)) : null,
      ),
      DeliveryStep(
        title: 'Entregue',
        description: 'Pedido entregue com sucesso. Aproveite!',
        isCompleted: status == OrderStatus.delivered,
        completedAt: status == OrderStatus.delivered ? now : null,
      ),
    ];

    return DeliveryTracking(
      orderId: orderId,
      steps: steps,
      currentStatus: status,
    );
  }
}

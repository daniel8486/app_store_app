import 'package:uuid/uuid.dart';
import '../../domain/entities/payment.dart';

class PaymentRepository {
  final _uuid = const Uuid();

  Future<Payment> processPayment({
    required PaymentMethod method,
    required double amount,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate always-approved payment
    return Payment(
      id: _uuid.v4(),
      method: method,
      status: PaymentStatus.approved,
      amount: amount,
    );
  }
}

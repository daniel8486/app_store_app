import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/payment_repository.dart';
import '../../domain/entities/payment.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository();
});

final selectedPaymentMethodProvider =
    StateProvider<PaymentMethod>((ref) => PaymentMethod.pix);

enum PaymentState { idle, processing, approved, rejected }

final paymentStateProvider =
    StateNotifierProvider<PaymentNotifier, PaymentState>(
  (ref) => PaymentNotifier(ref.read(paymentRepositoryProvider)),
);

class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentRepository _repo;
  Payment? lastPayment;

  PaymentNotifier(this._repo) : super(PaymentState.idle);

  Future<Payment> process({
    required PaymentMethod method,
    required double amount,
  }) async {
    state = PaymentState.processing;
    try {
      final payment = await _repo.processPayment(method: method, amount: amount);
      lastPayment = payment;
      state = payment.status == PaymentStatus.approved
          ? PaymentState.approved
          : PaymentState.rejected;
      return payment;
    } catch (e) {
      state = PaymentState.rejected;
      rethrow;
    }
  }

  void reset() {
    state = PaymentState.idle;
    lastPayment = null;
  }
}

enum PaymentMethod { creditCard, pix, boleto }

extension PaymentMethodExtension on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.creditCard:
        return 'Cartão de crédito';
      case PaymentMethod.pix:
        return 'Pix';
      case PaymentMethod.boleto:
        return 'Boleto';
    }
  }
}

enum PaymentStatus { pending, approved, rejected }

class Payment {
  final String id;
  final PaymentMethod method;
  final PaymentStatus status;
  final double amount;

  const Payment({
    required this.id,
    required this.method,
    required this.status,
    required this.amount,
  });

  Payment copyWith({PaymentStatus? status}) {
    return Payment(
      id: id,
      method: method,
      status: status ?? this.status,
      amount: amount,
    );
  }
}

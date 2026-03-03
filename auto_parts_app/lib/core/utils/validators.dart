class Validators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) return 'E-mail inválido';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
    if (value.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  static String? cpf(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11) return 'CPF deve ter 11 dígitos';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) return 'Telefone inválido';
    return null;
  }

  static String? Function(String?) confirmPassword(String password) {
    return (String? value) {
      if (value == null || value.isEmpty) return 'Campo obrigatório';
      if (value != password) return 'Senhas não conferem';
      return null;
    };
  }
}

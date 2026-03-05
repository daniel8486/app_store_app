class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String cpf;
  final bool isSeller;
  final bool isAdmin;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.cpf,
    this.isSeller = false,
    this.isAdmin = false,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? cpf,
    bool? isSeller,
    bool? isAdmin,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      cpf: cpf ?? this.cpf,
      isSeller: isSeller ?? this.isSeller,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}

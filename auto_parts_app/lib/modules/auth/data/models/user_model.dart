import '../../domain/entities/user.dart';

class UserModel extends User {
  final String password;

  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.cpf,
    super.isSeller,
    super.isAdmin,
    required this.password,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      cpf: map['cpf'] as String,
      isSeller: (map['isSeller'] as bool?) ?? false,
      isAdmin: (map['isAdmin'] as bool?) ?? false,
      password: map['password'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'cpf': cpf,
      'isSeller': isSeller,
      'isAdmin': isAdmin,
      'password': password,
    };
  }
}

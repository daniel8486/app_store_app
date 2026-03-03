import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../../shared/mock_data/mock_data.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

class AuthRepository {
  static const _usersKey = 'users';
  static const _currentUserKey = 'current_user';
  final _uuid = const Uuid();

  Future<void> _seedDefaultUsers() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_usersKey)) {
      final users = [
        MockData.defaultUser,
        MockData.defaultSeller,
      ];
      await prefs.setString(_usersKey, jsonEncode(users));
    }
  }

  Future<List<UserModel>> _getUsers() async {
    await _seedDefaultUsers();
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => UserModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<void> _saveUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users.map((u) => u.toMap()).toList()));
  }

  Future<User> login(String email, String password) async {
    final users = await _getUsers();
    final user = users.firstWhere(
      (u) => u.email.toLowerCase() == email.toLowerCase() && u.password == password,
      orElse: () => throw Exception('E-mail ou senha incorretos'),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(user.toMap()));
    return user;
  }

  Future<User> register({
    required String name,
    required String email,
    required String phone,
    required String cpf,
    required String password,
  }) async {
    final users = await _getUsers();
    final exists = users.any((u) => u.email.toLowerCase() == email.toLowerCase());
    if (exists) throw Exception('E-mail já cadastrado');

    final newUser = UserModel(
      id: _uuid.v4(),
      name: name,
      email: email,
      phone: phone.replaceAll(RegExp(r'\D'), ''),
      cpf: cpf.replaceAll(RegExp(r'\D'), ''),
      password: password,
    );

    users.add(newUser);
    await _saveUsers(users);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(newUser.toMap()));
    return newUser;
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_currentUserKey);
    if (raw == null) return null;
    return UserModel.fromMap(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<User> updateProfile({
    required String id,
    required String name,
    required String phone,
  }) async {
    final users = await _getUsers();
    final index = users.indexWhere((u) => u.id == id);
    if (index == -1) throw Exception('Usuário não encontrado');

    final updated = UserModel(
      id: users[index].id,
      name: name,
      email: users[index].email,
      phone: phone.replaceAll(RegExp(r'\D'), ''),
      cpf: users[index].cpf,
      isSeller: users[index].isSeller,
      password: users[index].password,
    );

    users[index] = updated;
    await _saveUsers(users);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(updated.toMap()));
    return updated;
  }

  Future<void> changePassword({
    required String id,
    required String currentPassword,
    required String newPassword,
  }) async {
    final users = await _getUsers();
    final index = users.indexWhere((u) => u.id == id);
    if (index == -1) throw Exception('Usuário não encontrado');
    if (users[index].password != currentPassword) {
      throw Exception('Senha atual incorreta');
    }

    final updated = UserModel(
      id: users[index].id,
      name: users[index].name,
      email: users[index].email,
      phone: users[index].phone,
      cpf: users[index].cpf,
      isSeller: users[index].isSeller,
      password: newPassword,
    );

    users[index] = updated;
    await _saveUsers(users);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(updated.toMap()));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }
}

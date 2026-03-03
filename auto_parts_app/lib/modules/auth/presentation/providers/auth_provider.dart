import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final currentUserProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>(
  (ref) => AuthNotifier(ref.read(authRepositoryProvider)),
);

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final user = await _repo.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.data(null);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.login(email, password);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.data(null);
      rethrow;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String cpf,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.register(
        name: name,
        email: email,
        phone: phone,
        cpf: cpf,
        password: password,
      );
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.data(null);
      rethrow;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
  }) async {
    final user = state.value;
    if (user == null) throw Exception('Não autorizado');
    final updated = await _repo.updateProfile(
      id: user.id,
      name: name,
      phone: phone,
    );
    state = AsyncValue.data(updated);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = state.value;
    if (user == null) throw Exception('Não autorizado');
    await _repo.changePassword(
      id: user.id,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AsyncValue.data(null);
  }
}

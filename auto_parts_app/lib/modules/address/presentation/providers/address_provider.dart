import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/address_repository.dart';
import '../../domain/entities/address.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository();
});

class AddressNotifier extends StateNotifier<AsyncValue<List<Address>>> {
  final AddressRepository _repo;
  final String _userId;

  AddressNotifier(this._repo, this._userId)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final addresses = await _repo.getAddresses(_userId);
      state = AsyncValue.data(addresses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(Address address) async {
    final updated = await _repo.addAddress(_userId, address);
    state = AsyncValue.data(updated);
  }

  Future<void> update(Address address) async {
    final updated = await _repo.updateAddress(_userId, address);
    state = AsyncValue.data(updated);
  }

  Future<void> delete(String addressId) async {
    final updated = await _repo.deleteAddress(_userId, addressId);
    state = AsyncValue.data(updated);
  }
}

final addressProvider =
    StateNotifierProvider<AddressNotifier, AsyncValue<List<Address>>>((ref) {
  final repo = ref.read(addressRepositoryProvider);
  final user = ref.watch(currentUserProvider).value;
  return AddressNotifier(repo, user?.id ?? 'guest');
});

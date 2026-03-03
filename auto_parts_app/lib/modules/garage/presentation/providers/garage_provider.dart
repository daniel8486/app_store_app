import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/garage_repository.dart';
import '../../domain/entities/vehicle.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final garageRepositoryProvider = Provider<GarageRepository>((ref) {
  return GarageRepository();
});

class GarageNotifier extends StateNotifier<AsyncValue<List<Vehicle>>> {
  final GarageRepository _repo;
  final String _userId;

  GarageNotifier(this._repo, this._userId)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final vehicles = await _repo.getVehicles(_userId);
      state = AsyncValue.data(vehicles);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(Vehicle vehicle) async {
    final updated = await _repo.addVehicle(_userId, vehicle);
    state = AsyncValue.data(updated);
  }

  Future<void> delete(String vehicleId) async {
    final updated = await _repo.deleteVehicle(_userId, vehicleId);
    state = AsyncValue.data(updated);
  }
}

final garageProvider =
    StateNotifierProvider<GarageNotifier, AsyncValue<List<Vehicle>>>((ref) {
  final repo = ref.read(garageRepositoryProvider);
  final user = ref.watch(currentUserProvider).value;
  return GarageNotifier(repo, user?.id ?? 'guest');
});

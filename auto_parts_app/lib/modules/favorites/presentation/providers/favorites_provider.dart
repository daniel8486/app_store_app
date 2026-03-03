import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/favorites_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository();
});

class FavoritesNotifier extends StateNotifier<List<String>> {
  final FavoritesRepository _repo;
  final String _userId;

  FavoritesNotifier(this._repo, this._userId) : super([]) {
    _load();
  }

  Future<void> _load() async {
    state = await _repo.getFavorites(_userId);
  }

  Future<void> toggle(String partId) async {
    state = await _repo.toggleFavorite(_userId, partId);
  }

  bool isFavorite(String partId) => state.contains(partId);
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  final repo = ref.read(favoritesRepositoryProvider);
  final user = ref.watch(currentUserProvider).value;
  return FavoritesNotifier(repo, user?.id ?? 'guest');
});

final isFavoriteProvider = Provider.family<bool, String>((ref, partId) {
  return ref.watch(favoritesProvider).contains(partId);
});

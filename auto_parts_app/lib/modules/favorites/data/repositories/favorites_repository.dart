import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesRepository {
  String _key(String userId) => 'favorites_$userId';

  Future<List<String>> getFavorites(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(userId));
    if (raw == null) return [];
    return List<String>.from(jsonDecode(raw) as List);
  }

  Future<List<String>> toggleFavorite(String userId, String partId) async {
    final favorites = await getFavorites(userId);
    final updated = List<String>.from(favorites);
    if (updated.contains(partId)) {
      updated.remove(partId);
    } else {
      updated.add(partId);
    }
    await _save(userId, updated);
    return updated;
  }

  Future<void> _save(String userId, List<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(userId), jsonEncode(favorites));
  }
}

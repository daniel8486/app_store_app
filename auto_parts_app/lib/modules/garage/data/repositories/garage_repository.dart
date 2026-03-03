import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/vehicle.dart';

class GarageRepository {
  final _uuid = const Uuid();
  String _key(String userId) => 'garage_$userId';

  Future<List<Vehicle>> getVehicles(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(userId));
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => Vehicle.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<List<Vehicle>> addVehicle(String userId, Vehicle vehicle) async {
    final vehicles = await getVehicles(userId);
    final newVehicle = Vehicle(
      id: _uuid.v4(),
      brand: vehicle.brand,
      model: vehicle.model,
      year: vehicle.year,
      nickname: vehicle.nickname,
      color: vehicle.color,
    );
    final updated = [...vehicles, newVehicle];
    await _save(userId, updated);
    return updated;
  }

  Future<List<Vehicle>> deleteVehicle(String userId, String vehicleId) async {
    final vehicles = await getVehicles(userId);
    final updated = vehicles.where((v) => v.id != vehicleId).toList();
    await _save(userId, updated);
    return updated;
  }

  Future<void> _save(String userId, List<Vehicle> vehicles) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _key(userId), jsonEncode(vehicles.map((v) => v.toMap()).toList()));
  }
}

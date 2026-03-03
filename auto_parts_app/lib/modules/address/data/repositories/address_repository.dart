import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/address.dart';

class AddressRepository {
  final _uuid = const Uuid();

  String _key(String userId) => 'addresses_$userId';

  Future<List<Address>> getAddresses(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(userId));
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => Address.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<List<Address>> addAddress(String userId, Address address) async {
    final addresses = await getAddresses(userId);
    final newAddress = Address(
      id: _uuid.v4(),
      label: address.label,
      zipCode: address.zipCode,
      street: address.street,
      number: address.number,
      complement: address.complement,
      neighborhood: address.neighborhood,
      city: address.city,
      state: address.state,
      isDefault: addresses.isEmpty ? true : address.isDefault,
    );

    List<Address> updated;
    if (newAddress.isDefault) {
      updated = addresses.map((a) => a.copyWith(isDefault: false)).toList();
    } else {
      updated = List.from(addresses);
    }
    updated.add(newAddress);
    await _save(userId, updated);
    return updated;
  }

  Future<List<Address>> updateAddress(String userId, Address address) async {
    final addresses = await getAddresses(userId);
    List<Address> updated;
    if (address.isDefault) {
      updated = addresses
          .map((a) => a.id == address.id ? address : a.copyWith(isDefault: false))
          .toList();
    } else {
      updated = addresses.map((a) => a.id == address.id ? address : a).toList();
    }
    await _save(userId, updated);
    return updated;
  }

  Future<List<Address>> deleteAddress(String userId, String addressId) async {
    final addresses = await getAddresses(userId);
    final updated = addresses.where((a) => a.id != addressId).toList();
    // Se removeu o padrão e ainda há endereços, coloca o primeiro como padrão
    if (updated.isNotEmpty && !updated.any((a) => a.isDefault)) {
      updated[0] = updated[0].copyWith(isDefault: true);
    }
    await _save(userId, updated);
    return updated;
  }

  Future<void> _save(String userId, List<Address> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(userId), jsonEncode(addresses.map((a) => a.toMap()).toList()));
  }
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/address_model.dart';

class AddressService {
  static const String _storageKey = 'cartly_saved_addresses';

  /// Get all saved addresses.
  Future<List<AddressModel>> getAddresses() async {
    final preferences = await SharedPreferences.getInstance();
    final savedData = preferences.getString(_storageKey);

    if (savedData == null || savedData.isEmpty) {
      return [];
    }

    try {
      final decodedData = jsonDecode(savedData);

      if (decodedData is! List) {
        return [];
      }

      return decodedData
          .whereType<Map>()
          .map((item) => AddressModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (error) {
      throw FormatException('Unable to read saved addresses: $error');
    }
  }

  /// Save the address list.
  Future<void> _saveAddresses(List<AddressModel> addresses) async {
    final preferences = await SharedPreferences.getInstance();

    final encodedData = jsonEncode(
      addresses.map((address) => address.toJson()).toList(),
    );

    final saved = await preferences.setString(_storageKey, encodedData);

    if (!saved) {
      throw Exception('Unable to save addresses.');
    }
  }

  /// Add a new address.
  Future<void> addAddress(AddressModel address) async {
    final addresses = await getAddresses();

    if (addresses.any((item) => item.id == address.id)) {
      throw Exception('This address already exists.');
    }

    if (address.isDefault) {
      final updatedAddresses =
          addresses.map((item) => item.copyWith(isDefault: false)).toList();

      updatedAddresses.add(address);
      await _saveAddresses(updatedAddresses);
      return;
    }

    addresses.add(address);
    await _saveAddresses(addresses);
  }

  /// Update an existing address.
  Future<void> updateAddress(AddressModel address) async {
    final addresses = await getAddresses();

    final index = addresses.indexWhere((item) => item.id == address.id);

    if (index == -1) {
      throw Exception('Address not found.');
    }

    if (address.isDefault) {
      for (var i = 0; i < addresses.length; i++) {
        addresses[i] = addresses[i].copyWith(isDefault: false);
      }
    }

    addresses[index] = address;
    await _saveAddresses(addresses);
  }

  /// Delete an address.
  Future<void> deleteAddress(String addressId) async {
    final addresses = await getAddresses();

    addresses.removeWhere((item) => item.id == addressId);

    await _saveAddresses(addresses);
  }

  /// Set an address as the default address.
  Future<void> setDefaultAddress(String addressId) async {
    final addresses = await getAddresses();

    final exists = addresses.any((item) => item.id == addressId);

    if (!exists) {
      throw Exception('Address not found.');
    }

    final updatedAddresses =
        addresses.map((address) {
          return address.copyWith(isDefault: address.id == addressId);
        }).toList();

    await _saveAddresses(updatedAddresses);
  }

  /// Get the default address.
  Future<AddressModel?> getDefaultAddress() async {
    final addresses = await getAddresses();

    for (final address in addresses) {
      if (address.isDefault) {
        return address;
      }
    }

    return addresses.isNotEmpty ? addresses.first : null;
  }

  /// Clear all saved addresses.
  Future<void> clearAddresses() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_storageKey);
  }
}

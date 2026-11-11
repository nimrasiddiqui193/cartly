import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';

class CartService {
  CartService._();

  static final CartService instance = CartService._();

  static const String _cartKey = 'cartly_cart_items';

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final preferences = await SharedPreferences.getInstance();
    final savedItems = preferences.getString(_cartKey);

    if (savedItems == null || savedItems.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(savedItems);

      if (decoded is! List) {
        return [];
      }

      final validItems = <Map<String, dynamic>>[];

      for (final item in decoded) {
        if (item is! Map) continue;

        final productData = item['product'];

        if (productData is! Map) continue;

        final product = Product.fromJson(
          Map<String, dynamic>.from(productData),
        );

        final quantity = _toInt(item['quantity']);

        if (product.id <= 0 || quantity <= 0) continue;

        validItems.add({'product': product.toJson(), 'quantity': quantity});
      }

      return validItems;
    } catch (_) {
      return [];
    }
  }

  Future<void> addToCart(Product product) async {
    if (!product.isInStock) {
      throw Exception('This product is currently out of stock.');
    }

    final items = await getCartItems();

    final existingIndex = items.indexWhere(
      (item) => _productId(item) == product.id,
    );

    if (existingIndex != -1) {
      final currentQuantity = _toInt(items[existingIndex]['quantity']);

      if (currentQuantity >= product.stock) {
        throw Exception(
          'You cannot add more than ${product.stock} units of this product.',
        );
      }

      items[existingIndex]['quantity'] = currentQuantity + 1;
      items[existingIndex]['product'] = product.toJson();
    } else {
      items.add({'product': product.toJson(), 'quantity': 1});
    }

    await _saveCart(items);
  }

  Future<void> removeFromCart(int productId) async {
    final items = await getCartItems();

    items.removeWhere((item) => _productId(item) == productId);

    await _saveCart(items);
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    final items = await getCartItems();

    final index = items.indexWhere((item) => _productId(item) == productId);

    if (index == -1) return;

    if (quantity <= 0) {
      items.removeAt(index);
    } else {
      final productData = Map<String, dynamic>.from(
        items[index]['product'] as Map,
      );

      final product = Product.fromJson(productData);

      if (quantity > product.stock) {
        throw Exception('Only ${product.stock} units are available.');
      }

      items[index]['quantity'] = quantity;
    }

    await _saveCart(items);
  }

  Future<void> clearCart() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_cartKey);
  }

  Future<int> getItemCount() async {
    final items = await getCartItems();

    return items.fold<int>(
      0,
      (total, item) => total + _toInt(item['quantity']),
    );
  }

  Future<double> getCartTotal() async {
    final items = await getCartItems();

    return items.fold<double>(0, (total, item) {
      final product = Product.fromJson(
        Map<String, dynamic>.from(item['product'] as Map),
      );

      final quantity = _toInt(item['quantity']);

      return total + (product.discountedPrice * quantity);
    });
  }

  Future<double> getOriginalCartTotal() async {
    final items = await getCartItems();

    return items.fold<double>(0, (total, item) {
      final product = Product.fromJson(
        Map<String, dynamic>.from(item['product'] as Map),
      );

      final quantity = _toInt(item['quantity']);

      return total + (product.price * quantity);
    });
  }

  Future<double> getTotalSavings() async {
    final originalTotal = await getOriginalCartTotal();
    final discountedTotal = await getCartTotal();

    return originalTotal - discountedTotal;
  }

  int _productId(Map<String, dynamic> item) {
    final product = item['product'];

    if (product is! Map) return -1;

    return _toInt(product['id']);
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  Future<void> _saveCart(List<Map<String, dynamic>> items) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_cartKey, jsonEncode(items));
  }
}

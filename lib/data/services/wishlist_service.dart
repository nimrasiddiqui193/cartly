import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';

class WishlistService {
  WishlistService._();

  static final WishlistService instance = WishlistService._();

  static const String _wishlistKey = 'cartly_wishlist_items';

  Future<List<Product>> getWishlist() async {
    final preferences = await SharedPreferences.getInstance();
    final savedItems = preferences.getString(_wishlistKey);

    if (savedItems == null || savedItems.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(savedItems);

      if (decoded is! List) {
        return [];
      }

      final products = <Product>[];
      final seenIds = <int>{};

      for (final item in decoded) {
        if (item is! Map) continue;

        try {
          final product = Product.fromJson(Map<String, dynamic>.from(item));

          if (product.id <= 0 || !seenIds.add(product.id)) {
            continue;
          }

          products.add(product);
        } catch (_) {
          continue;
        }
      }

      return products;
    } catch (_) {
      return [];
    }
  }

  Future<void> addToWishlist(Product product) async {
    if (product.id <= 0) return;

    final products = await getWishlist();

    final alreadyExists = products.any((item) => item.id == product.id);

    if (alreadyExists) return;

    products.add(product);

    await _saveWishlist(products);
  }

  Future<void> removeFromWishlist(int productId) async {
    final products = await getWishlist();

    products.removeWhere((product) => product.id == productId);

    await _saveWishlist(products);
  }

  Future<void> toggleWishlist(Product product) async {
    if (product.id <= 0) return;

    final products = await getWishlist();

    final index = products.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      products.removeAt(index);
    } else {
      products.add(product);
    }

    await _saveWishlist(products);
  }

  Future<bool> isWishlisted(int productId) async {
    final products = await getWishlist();

    return products.any((product) => product.id == productId);
  }

  Future<void> clearWishlist() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_wishlistKey);
  }

  Future<int> getWishlistCount() async {
    final products = await getWishlist();

    return products.length;
  }

  Future<void> _saveWishlist(List<Product> products) async {
    final preferences = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      products.map((product) => product.toJson()).toList(),
    );

    await preferences.setString(_wishlistKey, encoded);
  }
}

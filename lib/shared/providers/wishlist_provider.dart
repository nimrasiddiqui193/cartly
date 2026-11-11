import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/product_model.dart';
import '../../data/services/wishlist_service.dart';

final wishlistServiceProvider = Provider<WishlistService>((ref) {
  return WishlistService.instance;
});

final wishlistProvider = AsyncNotifierProvider<WishlistNotifier, List<Product>>(
  WishlistNotifier.new,
);

class WishlistNotifier extends AsyncNotifier<List<Product>> {
  WishlistService get _service => ref.read(wishlistServiceProvider);

  @override
  Future<List<Product>> build() {
    return _service.getWishlist();
  }

  void _invalidateWishlistCount() {
    ref.invalidate(wishlistCountProvider);
  }

  Future<void> refreshWishlist() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _service.getWishlist());

    _invalidateWishlistCount();
  }

  Future<void> addProduct(Product product) async {
    await _service.addToWishlist(product);
    await refreshWishlist();
  }

  Future<void> removeProduct(int productId) async {
    await _service.removeFromWishlist(productId);
    await refreshWishlist();
  }

  Future<void> toggleProduct(Product product) async {
    await _service.toggleWishlist(product);
    await refreshWishlist();
  }

  Future<void> clearWishlist() async {
    await _service.clearWishlist();

    state = const AsyncData([]);

    _invalidateWishlistCount();
  }

  Future<bool> isWishlisted(int productId) {
    return _service.isWishlisted(productId);
  }
}

final wishlistCountProvider = FutureProvider<int>((ref) {
  return ref.watch(wishlistServiceProvider).getWishlistCount();
});

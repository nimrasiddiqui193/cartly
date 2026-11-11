import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/product_model.dart';
import '../../data/repositories/cart_repository.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository();
});

final cartProvider =
    AsyncNotifierProvider<CartNotifier, List<Map<String, dynamic>>>(
      CartNotifier.new,
    );

class CartNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  CartRepository get _repository => ref.read(cartRepositoryProvider);

  @override
  Future<List<Map<String, dynamic>>> build() {
    return _repository.getCartItems();
  }

  void _invalidateCartSummary() {
    ref.invalidate(cartItemCountProvider);
    ref.invalidate(cartTotalProvider);
    ref.invalidate(cartOriginalTotalProvider);
    ref.invalidate(cartSavingsProvider);
  }

  Future<void> refreshCart() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _repository.getCartItems());

    _invalidateCartSummary();
  }

  Future<void> addProduct(Product product) async {
    await _repository.addToCart(product);
    await refreshCart();
  }

  Future<void> removeProduct(int productId) async {
    await _repository.removeFromCart(productId);
    await refreshCart();
  }

  Future<void> updateProductQuantity(int productId, int quantity) async {
    await _repository.updateQuantity(productId, quantity);
    await refreshCart();
  }

  Future<void> clearCart() async {
    await _repository.clearCart();

    state = const AsyncData([]);
    _invalidateCartSummary();
  }
}

final cartItemCountProvider = FutureProvider<int>((ref) {
  return ref.watch(cartRepositoryProvider).getItemCount();
});

final cartTotalProvider = FutureProvider<double>((ref) {
  return ref.watch(cartRepositoryProvider).getCartTotal();
});

final cartOriginalTotalProvider = FutureProvider<double>((ref) {
  return ref.watch(cartRepositoryProvider).getOriginalCartTotal();
});

final cartSavingsProvider = FutureProvider<double>((ref) {
  return ref.watch(cartRepositoryProvider).getTotalSavings();
});

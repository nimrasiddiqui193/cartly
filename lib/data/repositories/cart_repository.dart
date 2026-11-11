import '../models/product_model.dart';
import '../services/cart_service.dart';

class CartRepository {
  CartRepository({CartService? cartService})
    : _cartService = cartService ?? CartService.instance;

  final CartService _cartService;

  Future<List<Map<String, dynamic>>> getCartItems() {
    return _cartService.getCartItems();
  }

  Future<void> addToCart(Product product) {
    return _cartService.addToCart(product);
  }

  Future<void> removeFromCart(int productId) {
    return _cartService.removeFromCart(productId);
  }

  Future<void> updateQuantity(int productId, int quantity) {
    return _cartService.updateQuantity(productId, quantity);
  }

  Future<void> clearCart() {
    return _cartService.clearCart();
  }

  Future<int> getItemCount() {
    return _cartService.getItemCount();
  }

  Future<double> getCartTotal() {
    return _cartService.getCartTotal();
  }

  Future<double> getOriginalCartTotal() {
    return _cartService.getOriginalCartTotal();
  }

  Future<double> getTotalSavings() {
    return _cartService.getTotalSavings();
  }
}

import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderRepository {
  OrderRepository({OrderService? orderService})
    : _orderService = orderService ?? OrderService();

  final OrderService _orderService;

  /// Create and save a new order.
  Future<void> createOrder(OrderModel order) {
    return _orderService.saveOrder(order);
  }

  /// Get all orders belonging to a user.
  Future<List<OrderModel>> getOrders(String userId) {
    return _orderService.getOrders(userId);
  }

  /// Get an order by its ID.
  Future<OrderModel?> getOrderById(String orderId) {
    return _orderService.getOrderById(orderId);
  }

  /// Update an existing order.
  Future<void> updateOrder(OrderModel order) {
    return _orderService.updateOrder(order);
  }

  /// Cancel an order.
  Future<void> cancelOrder(String orderId) async {
    final order = await _orderService.getOrderById(orderId);

    if (order == null) {
      throw Exception('Order not found.');
    }

    if (order.status.toLowerCase() == 'cancelled') {
      return;
    }

    await _orderService.updateOrder(
      order.copyWith(status: 'Cancelled', updatedAt: DateTime.now()),
    );
  }

  /// Delete an order by its ID.
  Future<void> deleteOrder(String orderId) {
    return _orderService.deleteOrder(orderId);
  }

  /// Clear all orders belonging to a user.
  Future<void> clearOrders(String userId) {
    return _orderService.clearOrders(userId);
  }
}

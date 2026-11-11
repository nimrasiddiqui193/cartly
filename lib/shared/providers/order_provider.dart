import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/order_model.dart';
import '../../data/services/order_service.dart';

// Order service provider.
final orderServiceProvider = Provider<OrderService>((ref) {
  return OrderService();
});

// Current user's order history.
final orderProvider = AsyncNotifierProvider<OrderNotifier, List<OrderModel>>(
  OrderNotifier.new,
);

class OrderNotifier extends AsyncNotifier<List<OrderModel>> {
  OrderService get _service => ref.read(orderServiceProvider);

  String? _userId;

  @override
  Future<List<OrderModel>> build() async {
    return [];
  }

  // Load orders for a specific user.
  Future<void> loadOrders(String userId) async {
    if (userId.trim().isEmpty) {
      state = AsyncError(
        ArgumentError('A valid user ID is required.'),
        StackTrace.current,
      );
      return;
    }

    _userId = userId;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _service.getOrders(userId));
  }

  // Refresh the current user's orders.
  Future<void> refreshOrders() async {
    final userId = _userId;

    if (userId == null || userId.isEmpty) return;

    state = await AsyncValue.guard(() => _service.getOrders(userId));
  }

  // Save a newly placed order.
  Future<void> addOrder(OrderModel order) async {
    if (order.userId.trim().isEmpty) {
      throw ArgumentError('The order must belong to a valid user.');
    }

    if (order.userId != _userId) {
      await loadOrders(order.userId);
    }

    await _service.saveOrder(order);
    await refreshOrders();
  }

  // Update an existing order.
  Future<void> updateOrder(OrderModel order) async {
    if (_userId == null || order.userId != _userId) {
      throw StateError('You cannot update another user\'s order.');
    }

    await _service.updateOrder(order);
    await refreshOrders();
  }

  // Delete an order.
  Future<void> deleteOrder(String orderId) async {
    if (_userId == null || _userId!.isEmpty) return;

    final order = await _service.getOrderById(orderId);

    if (order == null || order.userId != _userId) {
      return;
    }

    await _service.deleteOrder(orderId);
    await refreshOrders();
  }

  // Clear orders belonging to the current user.
  Future<void> clearOrders() async {
    final userId = _userId;

    if (userId == null || userId.isEmpty) return;

    await _service.clearOrders(userId);

    state = const AsyncData([]);
  }

  // Find an order belonging to the current user.
  Future<OrderModel?> getOrderById(String orderId) async {
    final userId = _userId;

    if (userId == null || userId.isEmpty) return null;

    final order = await _service.getOrderById(orderId);

    if (order == null || order.userId != userId) {
      return null;
    }

    return order;
  }
}

// Total number of orders.
final orderCountProvider = Provider<int>((ref) {
  final orders = ref.watch(orderProvider);

  return orders.asData?.value.length ?? 0;
});

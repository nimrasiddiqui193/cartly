import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';

class OrderService {
  static const String _storageKey = 'cartly_orders';

  // Get orders belonging to a specific user.
  Future<List<OrderModel>> getOrders(String userId) async {
    if (userId.trim().isEmpty) return [];

    final orders = await _readOrders();

    final userOrders = orders.where((order) => order.userId == userId).toList();

    userOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return userOrders;
  }

  // Save a new order.
  Future<void> saveOrder(OrderModel order) async {
    if (order.id.trim().isEmpty) {
      throw ArgumentError('Order ID cannot be empty.');
    }

    if (order.userId.trim().isEmpty) {
      throw ArgumentError('Order user ID cannot be empty.');
    }

    final orders = await _readOrders();

    // Prevent duplicate order IDs.
    orders.removeWhere((existingOrder) => existingOrder.id == order.id);

    orders.add(order);

    await _saveOrders(orders);
  }

  // Find an order by its ID.
  Future<OrderModel?> getOrderById(String orderId) async {
    if (orderId.trim().isEmpty) return null;

    final orders = await _readOrders();

    for (final order in orders) {
      if (order.id == orderId) {
        return order;
      }
    }

    return null;
  }

  // Update an existing order without changing its owner.
  Future<void> updateOrder(OrderModel updatedOrder) async {
    final orders = await _readOrders();

    final index = orders.indexWhere((order) => order.id == updatedOrder.id);

    if (index == -1) {
      throw StateError('Order not found.');
    }

    final existingOrder = orders[index];

    if (existingOrder.userId != updatedOrder.userId) {
      throw StateError('An order cannot be transferred to another user.');
    }

    orders[index] = updatedOrder;

    await _saveOrders(orders);
  }

  // Delete an order by its ID.
  Future<void> deleteOrder(String orderId) async {
    if (orderId.trim().isEmpty) return;

    final orders = await _readOrders();

    orders.removeWhere((order) => order.id == orderId);

    await _saveOrders(orders);
  }

  // Clear orders belonging to one user only.
  Future<void> clearOrders(String userId) async {
    if (userId.trim().isEmpty) return;

    final orders = await _readOrders();

    orders.removeWhere((order) => order.userId == userId);

    await _saveOrders(orders);
  }

  // Read and decode all locally stored orders.
  Future<List<OrderModel>> _readOrders() async {
    final preferences = await SharedPreferences.getInstance();

    final storedData = preferences.getString(_storageKey);

    if (storedData == null || storedData.isEmpty) {
      return [];
    }

    final decodedData = jsonDecode(storedData);

    if (decodedData is! List) {
      throw const FormatException('Stored order data has an invalid format.');
    }

    return decodedData
        .where((item) => item is Map)
        .map(
          (item) => OrderModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  // Encode and save all orders.
  Future<void> _saveOrders(List<OrderModel> orders) async {
    final preferences = await SharedPreferences.getInstance();

    final encodedData = jsonEncode(
      orders.map((order) => order.toJson()).toList(),
    );

    final saved = await preferences.setString(_storageKey, encodedData);

    if (!saved) {
      throw StateError('Unable to save orders on this device.');
    }
  }
}

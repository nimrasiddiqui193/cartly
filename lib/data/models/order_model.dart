import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;

  // Price values remain in the original API currency (USD).
  final double subtotal;
  final double shippingFee;
  final double discount;
  final double total;

  // Delivery information saved as an order-time snapshot.
  final Map<String, dynamic> shippingAddress;

  // Payment information.
  final String paymentMethod;
  final String paymentStatus;

  // Order progress.
  final String status;

  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
    required this.shippingAddress,
    required this.paymentMethod,
    this.paymentStatus = 'Pending',
    this.status = 'Placed',
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final rawAddress = json['shippingAddress'];

    final parsedItems =
        rawItems is List
            ? rawItems
                .where((item) => item is Map)
                .map(
                  (item) => CartItemModel.fromJson(
                    Map<String, dynamic>.from(item as Map),
                  ),
                )
                .toList()
            : <CartItemModel>[];

    return OrderModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      items: parsedItems,
      subtotal: _toDouble(json['subtotal']),
      shippingFee: _toDouble(json['shippingFee']),
      discount: _toDouble(json['discount']),
      total: _toDouble(json['total']),
      shippingAddress:
          rawAddress is Map
              ? Map<String, dynamic>.from(rawAddress)
              : <String, dynamic>{},
      paymentMethod: json['paymentMethod']?.toString() ?? 'Cash on Delivery',
      paymentStatus: json['paymentStatus']?.toString() ?? 'Pending',
      status: json['status']?.toString() ?? 'Placed',
      notes: json['notes']?.toString(),
      createdAt: _toDateTime(json['createdAt']),
      updatedAt: _toDateTime(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'discount': discount,
      'total': total,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'status': status,
      'notes': notes,

      // Store dates as ISO 8601 strings for JSON compatibility.
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  OrderModel copyWith({
    String? status,
    String? paymentStatus,
    String? paymentMethod,
    Map<String, dynamic>? shippingAddress,
    String? notes,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id,
      userId: userId,
      items: items,
      subtotal: subtotal,
      shippingFee: shippingFee,
      discount: discount,
      total: total,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();

    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static DateTime _toDateTime(dynamic value) {
    if (value is DateTime) return value;

    // Supports Firestore Timestamp values.
    if (value != null) {
      try {
        return (value as dynamic).toDate() as DateTime;
      } catch (_) {
        return DateTime.tryParse(value.toString()) ??
            DateTime.fromMillisecondsSinceEpoch(0);
      }
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}

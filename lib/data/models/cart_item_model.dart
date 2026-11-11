import 'product_model.dart';

class CartItemModel {
  final Product product;
  final int quantity;

  const CartItemModel({required this.product, required this.quantity});

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final productData = json['product'];

    if (productData is! Map) {
      throw const FormatException(
        'Invalid cart item: product information is missing.',
      );
    }

    return CartItemModel(
      product: Product.fromJson(Map<String, dynamic>.from(productData)),
      quantity: _toInt(json['quantity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'product': product.toJson(), 'quantity': quantity};
  }

  // Total discounted price before currency formatting.
  double get totalPrice {
    return product.discountedPrice * quantity;
  }

  // Original price before discount.
  double get originalTotalPrice {
    return product.price * quantity;
  }

  // Total amount saved through discounts.
  double get totalSavings {
    return originalTotalPrice - totalPrice;
  }

  // Checks product stock availability.
  bool get isAvailable {
    return product.isInStock && quantity <= product.stock;
  }

  // Creates an updated copy of the cart item.
  CartItemModel copyWith({Product? product, int? quantity}) {
    return CartItemModel(
      product: product ?? this.product,
      quantity:
          quantity != null ? (quantity < 1 ? 1 : quantity) : this.quantity,
    );
  }

  // Safely parses quantity and prevents zero or negative values.
  static int _toInt(dynamic value) {
    int parsedValue;

    if (value is int) {
      parsedValue = value;
    } else if (value is num) {
      parsedValue = value.toInt();
    } else {
      parsedValue = int.tryParse(value?.toString() ?? '') ?? 1;
    }

    return parsedValue < 1 ? 1 : parsedValue;
  }
}

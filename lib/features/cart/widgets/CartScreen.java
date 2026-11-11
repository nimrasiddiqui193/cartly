
import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../data/models/cart_item_model.dart';

class CartScreen extends StatelessWidget {
  final List<CartItemModel> cartItems;
  final ValueChanged<CartItemModel>? onIncrease;
  final ValueChanged<CartItemModel>? onDecrease;
  final ValueChanged<CartItemModel>? onRemove;
  final VoidCallback? onCheckout;

  const CartScreen({
    super.key,
    this.cartItems = const [],
    this.onIncrease,
    this.onDecrease,
    this.onRemove,
    this.onCheckout,
  });

  double get subtotal => cartItems.fold(
        0,
        (total, item) => total + (item.product.discountedPrice * item.quantity),
      );

  int get totalItems => cartItems.fold(
        0,
        (total, item) => total + item.quantity,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart ($totalItems)'),
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart(context)
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];

                      return _CartItemCard(
                        item: item,
                        onIncrease: () => onIncrease?.call(item),
                        onDecrease: () => onDecrease?.call(item),
                        onRemove: () => onRemove?.call(item),
                      );
                    },
                  ),
                ),
                _CartSummary(
                  subtotal: subtotal,
                  totalItems: totalItems,
                  onCheckout: onCheckout,
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 85,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Looks like you haven’t added anything yet.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? onRemove;

  const _CartItemCard({
    required this.item,
    this.onIncrease,
    this.onDecrease,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: 95,
            width: 85,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F1ED),
              borderRadius: BorderRadius.circular(12),
            ),
            child: product.thumbnail.isEmpty
                ? const Icon(Icons.image_not_supported_outlined)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.thumbnail,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported_outlined,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  AppFormatters.formatPrice(product.discountedPrice),
                  style: const TextStyle(
                    color: Color(0xFFC96B2C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onTap: onDecrease,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add,
                      onTap: onIncrease,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                      ),
                      tooltip: 'Remove item',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QuantityButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 29,
        width: 29,
        decoration: BoxDecoration(
          color: const Color(0xFFE68A45).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 17,
          color: const Color(0xFFE68A45),
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final double subtotal;
  final int totalItems;
  final VoidCallback? onCheckout;

  const _CartSummary({
    required this.subtotal,
    required this.totalItems,
    this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Items'),
              Text('$totalItems'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                AppFormatters.formatPrice(subtotal),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                'Calculated at checkout',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE68A45),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Proceed to Checkout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

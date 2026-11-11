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

  double get subtotal =>
      cartItems.fold(0.0, (total, item) => total + item.totalPrice);

  double get originalSubtotal =>
      cartItems.fold(0.0, (total, item) => total + item.originalTotalPrice);

  double get totalSavings => originalSubtotal - subtotal;

  int get totalItems =>
      cartItems.fold(0, (total, item) => total + item.quantity);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          if (totalItems > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$totalItems items',
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body:
          cartItems.isEmpty
              ? _buildEmptyCart(context)
              : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                      itemCount: cartItems.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
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
                    totalSavings: totalSavings,
                    totalItems: totalItems,
                    onCheckout: onCheckout,
                  ),
                ],
              ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 125,
              width: 125,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.09),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 58,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              'Looks like you haven’t added anything yet. '
              'Explore our products and find something you love.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withValues(alpha: 0.65),
                fontSize: 14,
                height: 1.5,
              ),
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
    final colors = Theme.of(context).colorScheme;
    final product = item.product;
    final canIncrease = product.isInStock && item.quantity < product.stock;

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 112,
            width: 94,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(13),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child:
                  product.thumbnail.isEmpty
                      ? Icon(
                        Icons.image_not_supported_outlined,
                        color: colors.onSurfaceVariant,
                        size: 30,
                      )
                      : Image.network(
                        product.thumbnail,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (_, _, _) => Icon(
                              Icons.image_not_supported_outlined,
                              color: colors.onSurfaceVariant,
                              size: 30,
                            ),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;

                          return Center(
                            child: SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.primary,
                              ),
                            ),
                          );
                        },
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
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  AppFormatters.formatPrice(product.discountedPrice),
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (product.discountPercentage > 0) ...[
                  const SizedBox(height: 3),
                  Text(
                    'Regular: ${AppFormatters.formatPrice(product.price)}',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 11,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onTap: item.quantity > 1 ? onDecrease : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add,
                      onTap: canIncrease ? onIncrease : null,
                    ),
                    const Spacer(),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Remove item',
                      onPressed: onRemove,
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: colors.error,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                if (!product.isInStock) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Currently out of stock',
                    style: TextStyle(
                      color: colors.error,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else if (!canIncrease) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Maximum available quantity reached',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                ],
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

  const _QuantityButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final enabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color:
              enabled
                  ? colors.primary.withValues(alpha: 0.10)
                  : colors.onSurface.withValues(alpha: 0.045),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(
          icon,
          size: 17,
          color:
              enabled
                  ? colors.primary
                  : colors.onSurface.withValues(alpha: 0.25),
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final double subtotal;
  final double totalSavings;
  final int totalItems;
  final VoidCallback? onCheckout;

  const _CartSummary({
    required this.subtotal,
    required this.totalSavings,
    required this.totalItems,
    this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 19, 20, 22),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order summary',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '$totalItems items',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 17),
            _SummaryRow(
              label: 'Subtotal',
              value: AppFormatters.formatPrice(subtotal),
            ),
            const SizedBox(height: 11),
            _SummaryRow(
              label: 'Shipping',
              value: 'Calculated at checkout',
              valueColor: colors.onSurfaceVariant,
            ),
            if (totalSavings > 0) ...[
              const SizedBox(height: 11),
              _SummaryRow(
                label: 'You save',
                value: AppFormatters.formatPrice(totalSavings),
                valueColor: Colors.green.shade600,
              ),
            ],
            const SizedBox(height: 15),
            Divider(color: colors.outlineVariant.withValues(alpha: 0.6)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Estimated total',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                Text(
                  AppFormatters.formatPrice(subtotal),
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 53,
              child: ElevatedButton(
                onPressed: onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Proceed to Checkout',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(width: 9),
                    Icon(Icons.arrow_forward_rounded, size: 19),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: mutedColor, fontSize: 13)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: valueColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

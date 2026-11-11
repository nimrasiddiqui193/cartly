import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../data/models/cart_item_model.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? onRemove;

  const CartItemCard({
    super.key,
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
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 108,
            width: 90,
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
                      )
                      : Image.network(
                        product.thumbnail,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (_, __, ___) => Icon(
                              Icons.image_not_supported_outlined,
                              color: colors.onSurfaceVariant,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
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
                    AppFormatters.formatPrice(product.price),
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
                if (!product.isInStock)
                  Text(
                    'Currently out of stock',
                    style: TextStyle(
                      color: colors.error,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
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

  const _QuantityButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final enabled = onTap != null;

    return Material(
      color:
          enabled
              ? colors.primary.withValues(alpha: 0.10)
              : colors.onSurface.withValues(alpha: 0.045),
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(
          height: 30,
          width: 30,
          child: Icon(
            icon,
            size: 17,
            color:
                enabled
                    ? colors.primary
                    : colors.onSurface.withValues(alpha: 0.25),
          ),
        ),
      ),
    );
  }
}

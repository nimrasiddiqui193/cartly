import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onWishlistTap;
  final bool isWishlisted;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.onWishlistTap,
    this.isWishlisted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final hasDiscount = product.hasDiscount;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: colors.surfaceContainerHighest.withValues(
                          alpha: 0.45,
                        ),
                        padding: const EdgeInsets.all(12),
                        child:
                            product.thumbnail.isNotEmpty
                                ? Image.network(
                                  product.thumbnail,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _imagePlaceholder(colors);
                                  },
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }

                                    return Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: colors.primary,
                                      ),
                                    );
                                  },
                                )
                                : _imagePlaceholder(colors),
                      ),
                    ),
                    if (hasDiscount)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${product.discountPercentageRounded}% OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: colors.surface.withValues(alpha: 0.95),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: onWishlistTap,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              isWishlisted
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 19,
                              color:
                                  isWishlisted
                                      ? Colors.redAccent
                                      : colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.category.isEmpty ? 'Product' : product.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFB547),
                            size: 15,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Flexible(
                            child: Text(
                              product.isInStock ? 'In Stock' : 'Out of Stock',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color:
                                    product.isInStock
                                        ? Colors.green.shade600
                                        : colors.error,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppFormatters.formatPrice(
                                    product.discountedPrice,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: colors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                if (hasDiscount)
                                  Text(
                                    AppFormatters.formatPrice(product.price),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: colors.onSurfaceVariant,
                                      fontSize: 9,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Material(
                            color:
                                product.isInStock
                                    ? colors.primary
                                    : colors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(9),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(9),
                              onTap: product.isInStock ? onAddToCart : null,
                              child: Padding(
                                padding: const EdgeInsets.all(7),
                                child: Icon(
                                  Icons.add_shopping_cart_rounded,
                                  color:
                                      product.isInStock
                                          ? Colors.white
                                          : colors.onSurfaceVariant,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder(ColorScheme colors) {
    return Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 42,
        color: colors.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }
}

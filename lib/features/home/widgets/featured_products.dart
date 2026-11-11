import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../data/models/product_model.dart';

class FeaturedProducts extends StatelessWidget {
  final String title;
  final List<Product> products;
  final ValueChanged<Product>? onProductTap;
  final ValueChanged<Product>? onAddToCart;
  final ValueChanged<Product>? onWishlistTap;
  final VoidCallback? onSeeAllTap;

  const FeaturedProducts({
    super.key,
    this.title = 'Featured Products',
    required this.products,
    this.onProductTap,
    this.onAddToCart,
    this.onWishlistTap,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: onSeeAllTap,
              style: TextButton.styleFrom(foregroundColor: colors.primary),
              child: const Text(
                'See All',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (products.isEmpty)
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 35,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(height: 9),
                Text(
                  'No featured products available',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: 305,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final product = products[index];

                return SizedBox(
                  width: 185,
                  child: _ProductCard(
                    product: product,
                    onTap: () => onProductTap?.call(product),
                    onAddToCart: () => onAddToCart?.call(product),
                    onWishlistTap: () => onWishlistTap?.call(product),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onWishlistTap;

  const _ProductCard({
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.onWishlistTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: colors.surface,
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 155,
                  width: double.infinity,
                  color: colors.surfaceContainerHighest.withValues(alpha: 0.45),
                  child:
                      product.thumbnail.isEmpty
                          ? Icon(
                            Icons.image_not_supported_outlined,
                            size: 45,
                            color: colors.onSurfaceVariant,
                          )
                          : Image.network(
                            product.thumbnail,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
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
                            errorBuilder:
                                (_, __, ___) => Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 45,
                                  color: colors.onSurfaceVariant,
                                ),
                          ),
                ),
                if (product.hasDiscount)
                  Positioned(
                    top: 9,
                    left: 9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
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
                    color: colors.surface,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: onWishlistTap,
                      customBorder: const CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.favorite_border_rounded,
                          color: colors.primary,
                          size: 19,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFF0B44D),
                          size: 17,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        if (!product.isInStock)
                          Text(
                            'Out of stock',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppFormatters.formatPrice(
                                  product.discountedPrice,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: colors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              if (product.hasDiscount)
                                Text(
                                  AppFormatters.formatPrice(product.price),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colors.onSurfaceVariant,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Material(
                          color:
                              product.isInStock
                                  ? colors.primary
                                  : colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(9),
                          child: InkWell(
                            onTap: product.isInStock ? onAddToCart : null,
                            borderRadius: BorderRadius.circular(9),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.add_shopping_cart_rounded,
                                color:
                                    product.isInStock
                                        ? Colors.white
                                        : colors.onSurfaceVariant,
                                size: 18,
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
    );
  }
}

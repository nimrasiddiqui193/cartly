import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../data/models/product_model.dart';

class WishlistScreen extends StatelessWidget {
  final List<Product> products;
  final ValueChanged<Product>? onRemove;
  final ValueChanged<Product>? onAddToCart;
  final ValueChanged<Product>? onProductTap;

  const WishlistScreen({
    super.key,
    this.products = const [],
    this.onRemove,
    this.onAddToCart,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          if (products.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${products.length} saved',
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body:
          products.isEmpty
              ? _buildEmptyWishlist(context)
              : GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.61,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];

                  return _WishlistProductCard(
                    product: product,
                    onRemove: () => onRemove?.call(product),
                    onAddToCart: () => onAddToCart?.call(product),
                    onTap: () => onProductTap?.call(product),
                  );
                },
              ),
    );
  }

  Widget _buildEmptyWishlist(BuildContext context) {
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
                Icons.favorite_border_rounded,
                size: 58,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Your wishlist is empty',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              'Save the products you love and keep them '
              'all in one place.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.onSurfaceVariant,
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

class _WishlistProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onRemove;
  final VoidCallback? onAddToCart;
  final VoidCallback? onTap;

  const _WishlistProductCard({
    required this.product,
    this.onRemove,
    this.onAddToCart,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      color: colors.surfaceContainerHighest.withValues(
                        alpha: 0.45,
                      ),
                      child:
                          product.thumbnail.isEmpty
                              ? Icon(
                                Icons.image_not_supported_outlined,
                                size: 40,
                                color: colors.onSurfaceVariant,
                              )
                              : Image.network(
                                product.thumbnail,
                                fit: BoxFit.contain,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;

                                  return Center(
                                    child: SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: colors.primary,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder:
                                    (_, __, ___) => Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 40,
                                      color: colors.onSurfaceVariant,
                                    ),
                              ),
                    ),
                    Positioned(
                      top: 9,
                      right: 9,
                      child: Material(
                        color: Theme.of(context).cardColor,
                        shape: const CircleBorder(),
                        elevation: 2,
                        child: InkWell(
                          onTap: onRemove,
                          customBorder: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.favorite_rounded,
                              color: colors.error,
                              size: 19,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!product.isInStock)
                      Positioned(
                        left: 8,
                        top: 9,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: colors.error,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: const Text(
                            'Out of stock',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
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
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        AppFormatters.formatPrice(product.discountedPrice),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 9),
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: product.isInStock ? onAddToCart : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: colors.onPrimary,
                            disabledBackgroundColor: colors.onSurface
                                .withValues(alpha: 0.12),
                            disabledForegroundColor: colors.onSurfaceVariant,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            product.isInStock ? 'Add to Cart' : 'Unavailable',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
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
}


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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            TextButton(
              onPressed: onSeeAllTap,
              child: const Text(
                'See All',
                style: TextStyle(
                  color: Color(0xFFE68A45),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (products.isEmpty)
          const SizedBox(
            height: 120,
            child: Center(
              child: Text('No products available'),
            ),
          )
        else
          SizedBox(
            height: 300,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final product = products[index];

                return SizedBox(
                  width: 180,
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
    return Material(
      color: Theme.of(context).cardColor,
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
                  color: const Color(0xFFF4F1ED),
                  child: product.thumbnail.isEmpty
                      ? const Icon(
                          Icons.image_not_supported_outlined,
                          size: 45,
                          color: Colors.grey,
                        )
                      : Image.network(
                          product.thumbnail,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported_outlined,
                            size: 45,
                            color: Colors.grey,
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
                        color: const Color(0xFFE68A45),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 7,
                  right: 7,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: onWishlistTap,
                      customBorder: const CircleBorder(),
                      child: const Padding(
                        padding: EdgeInsets.all(7),
                        child: Icon(
                          Icons.favorite_border_rounded,
                          color: Color(0xFFE68A45),
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
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFF0B44D),
                          size: 16,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppFormatters.formatPrice(
                              product.discountedPrice,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFC96B2C),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: onAddToCart,
                          borderRadius: BorderRadius.circular(9),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE68A45),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart_rounded,
                              color: Colors.white,
                              size: 17,
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

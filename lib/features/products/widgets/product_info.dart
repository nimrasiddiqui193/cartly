import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../data/models/product_model.dart';

class ProductInfo extends StatelessWidget {
  final Product product;

  const ProductInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.brand.isNotEmpty) ...[
          Text(
            product.brand.toUpperCase(),
            style: textTheme.labelLarge?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
        ],

        Text(
          product.title,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),

        const SizedBox(height: 14),

        Row(
          children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFFB547), size: 22),
            const SizedBox(width: 5),
            Text(
              product.rating.toStringAsFixed(1),
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: colors.onSurfaceVariant,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${product.stock} available',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),

        const SizedBox(height: 22),

        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 8,
          children: [
            Text(
              AppFormatters.formatPrice(product.discountedPrice),
              style: textTheme.headlineMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (product.hasDiscount)
              Text(
                AppFormatters.formatPrice(product.price),
                style: textTheme.titleMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            if (product.hasDiscount)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${product.discountPercentageRounded}% OFF',
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
          decoration: BoxDecoration(
            color:
                product.isInStock
                    ? Colors.green.withValues(alpha: 0.08)
                    : colors.error.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                product.isInStock
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                color: product.isInStock ? Colors.green.shade600 : colors.error,
                size: 19,
              ),
              const SizedBox(width: 9),
              Text(
                product.isInStock ? 'In Stock' : 'Out of Stock',
                style: TextStyle(
                  color:
                      product.isInStock ? Colors.green.shade600 : colors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        Text(
          'Product Description',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 10),

        Text(
          product.description.isNotEmpty
              ? product.description
              : 'No product description is available.',
          style: textTheme.bodyMedium?.copyWith(
            height: 1.7,
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../data/models/category_model.dart';

class CategorySection extends StatelessWidget {
  final List<CategoryModel> categories;
  final ValueChanged<CategoryModel>? onCategoryTap;
  final VoidCallback? onSeeAllTap;

  const CategorySection({
    super.key,
    required this.categories,
    this.onCategoryTap,
    this.onSeeAllTap,
  });

  IconData _getCategoryIcon(String category) {
    final value = category.toLowerCase();

    if (value.contains('beauty') ||
        value.contains('skin') ||
        value.contains('fragrance')) {
      return Icons.spa_rounded;
    }

    if (value.contains('furniture') ||
        value.contains('home') ||
        value.contains('decor')) {
      return Icons.chair_alt_rounded;
    }

    if (value.contains('laptop') ||
        value.contains('computer') ||
        value.contains('electronic')) {
      return Icons.devices_rounded;
    }

    if (value.contains('phone') || value.contains('mobile')) {
      return Icons.phone_android_rounded;
    }

    if (value.contains('shirt') ||
        value.contains('fashion') ||
        value.contains('dress') ||
        value.contains('tops')) {
      return Icons.checkroom_rounded;
    }

    if (value.contains('vehicle') ||
        value.contains('car') ||
        value.contains('motorcycle')) {
      return Icons.directions_car_rounded;
    }

    if (value.contains('watch')) {
      return Icons.watch_rounded;
    }

    if (value.contains('jewel')) {
      return Icons.diamond_rounded;
    }

    if (value.contains('shoe') || value.contains('footwear')) {
      return Icons.shopping_bag_rounded;
    }

    if (value.contains('bag')) {
      return Icons.shopping_bag_rounded;
    }

    if (value.contains('food') || value.contains('grocery')) {
      return Icons.restaurant_rounded;
    }

    if (value.contains('book')) {
      return Icons.menu_book_rounded;
    }

    return Icons.category_rounded;
  }

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
                'Shop by Category',
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
        if (categories.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 22),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 32,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(height: 8),
                Text(
                  'No categories available',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: 108,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final category = categories[index];

                return InkWell(
                  onTap: () => onCategoryTap?.call(category),
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 76,
                    child: Column(
                      children: [
                        Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(19),
                          ),
                          child: Icon(
                            _getCategoryIcon(category.name),
                            color: colors.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          category.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

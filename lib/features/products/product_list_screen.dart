import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/product_model.dart';
import '../../shared/providers/wishlist_provider.dart';
import 'widgets/product_card.dart';

enum ProductSortOption { recommended, priceLowToHigh, priceHighToLow, topRated }

class ProductListScreen extends ConsumerStatefulWidget {
  final List<Product> products;
  final String title;
  final ValueChanged<Product>? onProductTap;
  final ValueChanged<Product>? onAddToCart;
  final ValueChanged<Product>? onWishlistTap;

  const ProductListScreen({
    super.key,
    required this.products,
    this.title = 'All Products',
    this.onProductTap,
    this.onAddToCart,
    this.onWishlistTap,
  });

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  ProductSortOption _selectedSort = ProductSortOption.recommended;

  List<Product> get _sortedProducts {
    final products = List<Product>.from(widget.products);

    switch (_selectedSort) {
      case ProductSortOption.priceLowToHigh:
        products.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
        break;

      case ProductSortOption.priceHighToLow:
        products.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
        break;

      case ProductSortOption.topRated:
      case ProductSortOption.recommended:
        products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return products;
  }

  String get _sortLabel {
    switch (_selectedSort) {
      case ProductSortOption.recommended:
        return 'Recommended';
      case ProductSortOption.priceLowToHigh:
        return 'Price: Low to High';
      case ProductSortOption.priceHighToLow:
        return 'Price: High to Low';
      case ProductSortOption.topRated:
        return 'Top Rated';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final products = _sortedProducts;

    final wishlistState = ref.watch(wishlistProvider);

    final wishlistedIds =
        wishlistState.asData?.value.map((product) => product.id).toSet() ??
        <int>{};

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
      ),
      body:
          widget.products.isEmpty
              ? _buildEmptyState(context)
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${products.length} products found',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        PopupMenuButton<ProductSortOption>(
                          tooltip: 'Sort products',
                          initialValue: _selectedSort,
                          onSelected: (value) {
                            setState(() {
                              _selectedSort = value;
                            });
                          },
                          itemBuilder:
                              (context) => [
                                _sortItem(
                                  ProductSortOption.recommended,
                                  'Recommended',
                                ),
                                _sortItem(
                                  ProductSortOption.priceLowToHigh,
                                  'Price: Low to High',
                                ),
                                _sortItem(
                                  ProductSortOption.priceHighToLow,
                                  'Price: High to Low',
                                ),
                                _sortItem(
                                  ProductSortOption.topRated,
                                  'Top Rated',
                                ),
                              ],
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colors.primary.withValues(alpha: 0.15),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.sort_rounded,
                                  size: 19,
                                  color: colors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _sortLabel,
                                  style: TextStyle(
                                    color: colors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: colors.primary,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.59,
                          ),
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return ProductCard(
                          product: product,
                          isWishlisted: wishlistedIds.contains(product.id),
                          onTap:
                              widget.onProductTap == null
                                  ? null
                                  : () => widget.onProductTap!(product),
                          onAddToCart:
                              widget.onAddToCart == null
                                  ? null
                                  : () => widget.onAddToCart!(product),
                          onWishlistTap:
                              widget.onWishlistTap == null
                                  ? null
                                  : () => widget.onWishlistTap!(product),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }

  PopupMenuItem<ProductSortOption> _sortItem(
    ProductSortOption value,
    String label,
  ) {
    return PopupMenuItem<ProductSortOption>(
      value: value,
      child: Row(
        children: [
          if (_selectedSort == value)
            Icon(
              Icons.check_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 18,
            )
          else
            const SizedBox(width: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 76,
              color: colors.primary.withValues(alpha: 0.55),
            ),
            const SizedBox(height: 18),
            const Text(
              'No Products Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'There are no products available in this section right now.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.onSurfaceVariant, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

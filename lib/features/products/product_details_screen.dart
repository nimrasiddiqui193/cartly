import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/product_model.dart';
import '../../shared/providers/cart_provider.dart';
import '../../shared/providers/wishlist_provider.dart';
import 'widgets/product_image_gallery.dart';
import 'widgets/product_info.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Product product;
  final VoidCallback? onAddToCart;
  final VoidCallback? onWishlistTap;
  final bool isWishlisted;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    this.onAddToCart,
    this.onWishlistTap,
    this.isWishlisted = false,
  });

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int quantity = 1;
  bool _isAddingToCart = false;
  bool _isUpdatingWishlist = false;

  void _increaseQuantity() {
    if (quantity < widget.product.stock) {
      setState(() {
        quantity++;
      });
    }
  }

  void _decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  void didUpdateWidget(covariant ProductDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.product.id != widget.product.id) {
      quantity = 1;
    }
  }

  Future<void> _addToCart() async {
    if (_isAddingToCart || !widget.product.isInStock) return;

    // Use the parent's callback when one has been provided.
    if (widget.onAddToCart != null) {
      widget.onAddToCart!.call();
      return;
    }

    setState(() {
      _isAddingToCart = true;
    });

    try {
      for (int i = 0; i < quantity; i++) {
        await ref.read(cartProvider.notifier).addProduct(widget.product);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              quantity == 1
                  ? 'Product added to cart.'
                  : '$quantity items added to cart.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Could not add product to cart: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }

  Future<void> _toggleWishlist() async {
    if (_isUpdatingWishlist) return;

    // Use the parent's callback when one has been provided.
    if (widget.onWishlistTap != null) {
      widget.onWishlistTap!.call();
      return;
    }

    setState(() {
      _isUpdatingWishlist = true;
    });

    try {
      await ref.read(wishlistProvider.notifier).toggleProduct(widget.product);

      if (!mounted) return;

      final updatedWishlist = ref.read(wishlistProvider).asData?.value ?? [];

      final isNowWishlisted = updatedWishlist.any(
        (product) => product.id == widget.product.id,
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              isNowWishlisted
                  ? 'Added to your wishlist.'
                  : 'Removed from your wishlist.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Could not update wishlist: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingWishlist = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final wishlistState = ref.watch(wishlistProvider);

    final isWishlisted =
        wishlistState.asData?.value.any((item) => item.id == product.id) ??
        widget.isWishlisted;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: isWishlisted ? 'Remove from wishlist' : 'Add to wishlist',
            onPressed: _isUpdatingWishlist ? null : _toggleWishlist,
            icon:
                _isUpdatingWishlist
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : Icon(
                      isWishlisted
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isWishlisted ? Colors.redAccent : colors.primary,
                    ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageGallery(
              images:
                  product.images.isNotEmpty
                      ? product.images
                      : [product.thumbnail],
            ),
            const SizedBox(height: 25),
            ProductInfo(product: product),
            const SizedBox(height: 26),

            if (product.isInStock) ...[
              Text(
                'Select Quantity',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 13),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: colors.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove_rounded,
                      onTap: _decreaseQuantity,
                      enabled: quantity > 1,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '$quantity',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add_rounded,
                      onTap: _increaseQuantity,
                      enabled: quantity < product.stock,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      '${product.stock} available',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 25),

            if (product.hasDiscount)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_offer_rounded, color: colors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'You save ${product.discountPercentageRounded}% on this product.',
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            onPressed:
                product.isInStock && !_isAddingToCart ? _addToCart : null,
            icon:
                _isAddingToCart
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Icon(Icons.shopping_cart_outlined),
            label: Text(
              _isAddingToCart
                  ? 'Adding to Cart...'
                  : product.isInStock
                  ? 'Add $quantity to Cart'
                  : 'Out of Stock',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: colors.surfaceContainerHighest,
              disabledForegroundColor: colors.onSurfaceVariant,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color:
          enabled
              ? colors.primary.withValues(alpha: 0.10)
              : colors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(11),
        child: SizedBox(
          height: 42,
          width: 42,
          child: Icon(
            icon,
            color:
                enabled
                    ? colors.primary
                    : colors.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}

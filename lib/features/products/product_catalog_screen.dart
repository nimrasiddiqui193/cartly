import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../shared/providers/cart_provider.dart';
import '../../shared/providers/wishlist_provider.dart';
import 'product_list_screen.dart';

class ProductCatalogScreen extends ConsumerStatefulWidget {
  final String? categorySlug;
  final String title;

  const ProductCatalogScreen({
    super.key,
    this.categorySlug,
    this.title = 'All Products',
  });

  @override
  ConsumerState<ProductCatalogScreen> createState() =>
      _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends ConsumerState<ProductCatalogScreen> {
  final ProductRepository _repository = ProductRepository();

  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() {
    final category = widget.categorySlug;

    if (category == null || category.isEmpty) {
      return _repository.getAllProducts();
    }

    return _repository.getProductsByCategory(category);
  }

  void _reloadProducts() {
    setState(() {
      _productsFuture = _fetchProducts();
    });
  }

  Future<void> _refresh() async {
    final newFuture = _fetchProducts();

    setState(() {
      _productsFuture = newFuture;
    });

    try {
      await newFuture;
    } catch (_) {
      // FutureBuilder displays the error state.
    }
  }

  Future<void> _addToCart(Product product) async {
    try {
      await ref.read(cartProvider.notifier).addProduct(product);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.title} added to cart'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not add product to cart: $error'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _toggleWishlist(Product product) async {
    try {
      await ref.read(wishlistProvider.notifier).toggleProduct(product);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.title} wishlist updated'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not update wishlist: $error'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.title)),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.title)),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      size: 55,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Unable to load products',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please check your internet connection and try again.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: _reloadProducts,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final products = snapshot.data ?? [];

        return Scaffold(
          appBar: AppBar(title: Text(widget.title)),
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: ProductListScreen(
              products: products,
              title: widget.title,
              onProductTap: (product) {
                context.push('/product-details', extra: product);
              },
              onAddToCart: _addToCart,
              onWishlistTap: _toggleWishlist,
            ),
          ),
        );
      },
    );
  }
}

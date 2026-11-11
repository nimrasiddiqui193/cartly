import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../shared/providers/cart_provider.dart';
import '../../shared/providers/wishlist_provider.dart';
import '../products/widgets/product_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final List<Product> products;
  final ValueChanged<String>? onSearch;
  final ValueChanged<Product>? onProductTap;

  const SearchScreen({
    super.key,
    this.products = const [],
    this.onSearch,
    this.onProductTap,
  });

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final ProductRepository _repository = ProductRepository();

  Timer? _debounce;

  String searchQuery = '';
  List<Product> _results = [];

  bool _isLoading = false;
  String? _errorMessage;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();

    if (widget.products.isNotEmpty) {
      _results = widget.products;
    } else {
      _loadInitialProducts();
    }
  }

  Future<void> _loadInitialProducts() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final products = await _repository.getProducts();

      if (!mounted || searchQuery.isNotEmpty) return;

      setState(() {
        _results = products;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  void _handleSearch(String value) {
    setState(() {
      searchQuery = value;
      _errorMessage = null;
    });

    widget.onSearch?.call(value);

    _debounce?.cancel();

    if (value.trim().isEmpty) {
      _requestId++;

      if (widget.products.isNotEmpty) {
        setState(() {
          _results = widget.products;
          _isLoading = false;
        });
      } else {
        _loadInitialProducts();
      }

      return;
    }

    _debounce = Timer(
      const Duration(milliseconds: 350),
      () => _performSearch(value),
    );
  }

  Future<void> _performSearch(String query) async {
    final currentRequest = ++_requestId;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final products = await _repository.searchProducts(query);

      if (!mounted || currentRequest != _requestId) return;

      setState(() {
        _results = products;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted || currentRequest != _requestId) return;

      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  void _clearSearch() {
    searchController.clear();
    _handleSearch('');
  }

  Future<void> _addToCart(Product product) async {
    try {
      await ref.read(cartProvider.notifier).addProduct(product);

      if (!mounted) return;

      _showMessage('${product.title} added to your cart.');
    } catch (error) {
      if (!mounted) return;

      _showMessage('Could not add product to cart. Please try again.');
    }
  }

  Future<void> _toggleWishlist(Product product) async {
    try {
      final currentWishlist =
          ref.read(wishlistProvider).asData?.value ?? <Product>[];

      final alreadyWishlisted = currentWishlist.any(
        (item) => item.id == product.id,
      );

      await ref.read(wishlistProvider.notifier).toggleProduct(product);

      if (!mounted) return;

      _showMessage(
        alreadyWishlisted
            ? '${product.title} removed from wishlist.'
            : '${product.title} added to wishlist.',
      );
    } catch (error) {
      if (!mounted) return;

      _showMessage('Could not update wishlist. Please try again.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final wishlistState = ref.watch(wishlistProvider);
    final wishlistedIds =
        wishlistState.asData?.value.map((product) => product.id).toSet() ??
        <int>{};

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Search Products',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: TextField(
              controller: searchController,
              onChanged: _handleSearch,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search products, brands...',
                prefixIcon: Icon(Icons.search_rounded, color: colors.primary),
                suffixIcon:
                    searchQuery.isNotEmpty
                        ? IconButton(
                          tooltip: 'Clear search',
                          onPressed: _clearSearch,
                          icon: const Icon(Icons.close_rounded),
                        )
                        : null,
                filled: true,
                fillColor: colors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: colors.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: colors.primary, width: 1.5),
                ),
              ),
            ),
          ),
          if (searchQuery.isNotEmpty && !_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_results.length} results found',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (_isLoading)
            LinearProgressIndicator(
              color: colors.primary,
              backgroundColor: colors.primary.withValues(alpha: 0.08),
              minHeight: 2,
            ),
          Expanded(child: _buildSearchContent(context, wishlistedIds)),
        ],
      ),
    );
  }

  Widget _buildSearchContent(BuildContext context, Set<int> wishlistedIds) {
    final colors = Theme.of(context).colorScheme;

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                size: 60,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(height: 15),
              const Text(
                'Unable to load products',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed:
                    searchQuery.isEmpty
                        ? _loadInitialProducts
                        : () => _performSearch(searchQuery),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (_isLoading && _results.isEmpty) {
      return Center(child: CircularProgressIndicator(color: colors.primary));
    }

    if (_results.isEmpty) {
      return _buildEmptyState(context);
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _results.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.59,
      ),
      itemBuilder: (context, index) {
        final product = _results[index];

        return ProductCard(
          product: product,
          onTap: () => widget.onProductTap?.call(product),
          isWishlisted: wishlistedIds.contains(product.id),
          onAddToCart: () => _addToCart(product),
          onWishlistTap: () => _toggleWishlist(product),
        );
      },
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
              searchQuery.isEmpty
                  ? Icons.search_rounded
                  : Icons.search_off_rounded,
              size: 70,
              color: colors.primary.withValues(alpha: 0.55),
            ),
            const SizedBox(height: 16),
            Text(
              searchQuery.isEmpty ? 'Discover Products' : 'No Products Found',
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              searchQuery.isEmpty
                  ? 'Search for your favorite products and brands.'
                  : 'Try another product name or keyword.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.onSurfaceVariant, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

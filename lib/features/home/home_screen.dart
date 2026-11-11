import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_router.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../shared/providers/cart_provider.dart';
import '../../shared/providers/wishlist_provider.dart';
import '../products/widgets/product_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ProductRepository _repository = ProductRepository();

  List<Product> _products = [];
  List<CategoryModel> _categories = [];

  String? _selectedCategory;

  bool _isLoading = true;
  String? _productsError;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _productsError = null;
      });
    }

    try {
      final results = await Future.wait([
        _repository.getAllProducts(),
        _repository.getCategories(),
      ]);

      if (!mounted) return;

      setState(() {
        _products = results[0] as List<Product>;
        _categories = results[1] as List<CategoryModel>;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _productsError = error.toString();
        _isLoading = false;
      });
    }
  }

  List<Product> get _filteredProducts {
    if (_selectedCategory == null) {
      return _products;
    }

    return _products.where((product) {
      return product.category.toLowerCase() == _selectedCategory!.toLowerCase();
    }).toList();
  }

  Color _primaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  void _openSearch() {
    context.push(AppRouter.search);
  }

  void _openCart() {
    context.push(AppRouter.cart);
  }

  void _openProfile() {
    context.push(AppRouter.profile);
  }

  void _openProduct(Product product) {
    context.push(AppRouter.productDetails, extra: product);
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final primary = _primaryColor(context);

    final wishlistState = ref.watch(wishlistProvider);
    final wishlistedIds =
        wishlistState.asData?.value.map((product) => product.id).toSet() ??
        <int>{};

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadHomeData,
          color: primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: _buildHeader(
                    primary,
                    colors.onSurface,
                    colors.onSurfaceVariant,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                sliver: SliverToBoxAdapter(child: _buildSearchBar(isDark)),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                sliver: SliverToBoxAdapter(child: _buildBanner(primary)),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: _buildSectionHeading(
                    'Shop by Category',
                    'Explore collections',
                    colors.onSurface,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                sliver: SliverToBoxAdapter(child: _buildCategories(primary)),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 15),
                sliver: SliverToBoxAdapter(
                  child: _buildSectionHeading(
                    'Popular Products',
                    'Discover our best picks',
                    colors.onSurface,
                    showAction: true,
                  ),
                ),
              ),
              ..._buildProductContent(wishlistedIds),
              const SliverToBoxAdapter(child: SizedBox(height: 28)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color primary, Color textColor, Color secondaryText) {
    return Row(
      children: [
        Container(
          height: 47,
          width: 47,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.22),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.shopping_bag_rounded,
            color: Colors.white,
            size: 25,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cartly',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.6,
                  color: textColor,
                ),
              ),
              Text(
                'Your everyday shopping place',
                style: TextStyle(fontSize: 11, color: secondaryText),
              ),
            ],
          ),
        ),
        _HeaderAction(icon: Icons.shopping_cart_outlined, onTap: _openCart),
        const SizedBox(width: 9),
        _HeaderAction(icon: Icons.person_outline_rounded, onTap: _openProfile),
      ],
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Material(
      color: isDark ? const Color(0xFF242938) : const Color(0xFFF2F3F7),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _openSearch,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: isDark ? Colors.white60 : Colors.black45,
                size: 22,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  'Search products, brands and more',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
              ),
              Icon(
                Icons.tune_rounded,
                color: isDark ? Colors.white70 : Colors.black54,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(Color primary) {
    const orange = Color(0xFFE98743);
    const deepOrange = Color(0xFFB95325);
    const gold = Color(0xFFFFC477);
    const darkBrown = Color(0xFF713817);

    return Container(
      height: 185,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF7B16F), orange, deepOrange],
        ),
        boxShadow: [
          BoxShadow(
            color: deepOrange.withValues(alpha: 0.30),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Stack(
          children: [
            Positioned(
              top: -75,
              right: 40,
              child: Container(
                height: 185,
                width: 185,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.09),
                ),
              ),
            ),
            Positioned(
              right: -45,
              bottom: -105,
              child: Container(
                height: 230,
                width: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.13),
                    width: 2,
                  ),
                ),
              ),
            ),
            Positioned(
              right: -20,
              bottom: -38,
              child: Icon(
                Icons.shopping_bag_rounded,
                size: 190,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            Positioned(
              right: 65,
              top: 24,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 23,
                color: gold.withValues(alpha: 0.85),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: gold.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: gold.withValues(alpha: 0.30)),
                    ),
                    child: const Text(
                      'SPECIAL COLLECTION',
                      style: TextStyle(
                        color: Color(0xFFFFE3B5),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Upgrade Your\nEveryday Style',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Discover something you will love.',
                    style: TextStyle(color: Color(0xFFFFE8D4), fontSize: 11),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 18,
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD28D), gold],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: darkBrown.withValues(alpha: 0.20),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: darkBrown,
                  size: 21,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeading(
    String title,
    String subtitle,
    Color textColor, {
    bool showAction = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: textColor.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ),
        if (showAction)
          TextButton(
            onPressed: _openSearch,
            child: Text(
              'See all',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategories(Color primary) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 43,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final category = isAll ? null : _categories[index - 1];

          final selected =
              isAll
                  ? _selectedCategory == null
                  : _selectedCategory == category!.slug;

          final label = isAll ? 'All' : category!.displayName;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category?.slug;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 17),
              decoration: BoxDecoration(
                color: selected ? primary : colors.surface,
                borderRadius: BorderRadius.circular(13),
                boxShadow:
                    selected
                        ? [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.18),
                            blurRadius: 9,
                            offset: const Offset(0, 4),
                          ),
                        ]
                        : null,
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : colors.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildProductContent(Set<int> wishlistedIds) {
    if (_isLoading && _products.isEmpty) {
      return [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 55),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ];
    }

    if (_productsError != null && _products.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
            child: _buildErrorState(),
          ),
        ),
      ];
    }

    final products = _filteredProducts;

    if (products.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 45),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No products in this category.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate((context, index) {
            final product = products[index];

            return ProductCard(
              product: product,
              onTap: () => _openProduct(product),
              isWishlisted: wishlistedIds.contains(product.id),
              onAddToCart: () => _addToCart(product),
              onWishlistTap: () => _toggleWishlist(product),
            );
          }, childCount: products.length),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 14,
            childAspectRatio: 0.59,
          ),
        ),
      ),
    ];
  }

  Widget _buildErrorState() {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(Icons.wifi_off_rounded, size: 48, color: colors.onSurfaceVariant),
        const SizedBox(height: 12),
        const Text(
          'Unable to load products',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          _productsError ?? 'Please try again.',
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _loadHomeData,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Try Again'),
        ),
      ],
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: SizedBox(
          height: 43,
          width: 43,
          child: Icon(icon, size: 21, color: colors.onSurface),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/theme_controller.dart';
import '../../data/models/address_model.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/order_model.dart';
import '../../data/models/payment_method_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/checkout/address_screen.dart';
import '../../features/checkout/checkout_screen.dart';
import '../../features/checkout/payment_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/orders/order_details_screen.dart';
import '../../features/orders/order_success_screen.dart';
import '../../features/orders/orders_screen.dart';
import '../../features/products/product_catalog_screen.dart';
import '../../features/products/product_details_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/settings_route_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/wishlist/wishlist_screen.dart';
import '../../shared/providers/cart_provider.dart';
import '../../shared/providers/checkout_provider.dart';
import '../../shared/providers/order_provider.dart';
import '../../shared/providers/wishlist_provider.dart';
import '../../shared/widgets/bottom_navigation_bar.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String products = '/products';
  static const String productDetails = '/product-details';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String wishlist = '/wishlist';
  static const String checkout = '/checkout';
  static const String address = '/address';
  static const String payment = '/payment';
  static const String orders = '/orders';
  static const String orderDetails = '/order-details';
  static const String orderSuccess = '/order-success';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';

  static final AuthRepository _authRepository = AuthRepository();

  static late ThemeController _themeController;

  static void configure({required ThemeController themeController}) {
    _themeController = themeController;
  }

  static int _selectedIndexForPath(String path) {
    switch (path) {
      case search:
        return 1;
      case wishlist:
        return 2;
      case cart:
        return 3;
      case profile:
        return 4;
      case home:
      default:
        return 0;
    }
  }

  static void _onNavigationTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(home);
        break;
      case 1:
        context.go(search);
        break;
      case 2:
        context.go(wishlist);
        break;
      case 3:
        context.go(cart);
        break;
      case 4:
        context.go(profile);
        break;
    }
  }

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),

      GoRoute(
        path: login,
        builder: (context, state) {
          return LoginScreen(
            onLogin: (email, password) async {
              await _authRepository.login(email: email, password: password);

              if (context.mounted) {
                context.go(home);
              }
            },
            onSignup: () => context.push(signup),
            onForgotPassword: () => context.push(forgotPassword),
          );
        },
      ),

      GoRoute(
        path: signup,
        builder: (context, state) {
          return SignupScreen(
            onSignup: ({
              required String name,
              required String email,
              required String password,
            }) async {
              await _authRepository.register(
                name: name,
                email: email,
                password: password,
              );

              if (context.mounted) {
                context.go(home);
              }
            },
            onLogin: () => context.go(login),
          );
        },
      ),

      // ---------------------------------------------------------------
      // MAIN NAVIGATION SHELL
      // ---------------------------------------------------------------
      ShellRoute(
        builder: (context, state, child) {
          return StreamBuilder<User?>(
            stream: _authRepository.authStateChanges,
            initialData: _authRepository.currentUser,
            builder: (context, snapshot) {
              final isAuthenticated = snapshot.data != null;
              final currentPath = state.uri.path;

              // Do not show the navigation bar on the login screen
              // displayed by the Home or Profile authentication checks.
              if (!isAuthenticated &&
                  (currentPath == home || currentPath == profile)) {
                return child;
              }

              return Scaffold(
                body: child,
                bottomNavigationBar: AppBottomNavigationBar(
                  currentIndex: _selectedIndexForPath(currentPath),
                  onTap: (index) => _onNavigationTap(context, index),
                ),
              );
            },
          );
        },
        routes: [
          GoRoute(
            path: home,
            builder: (context, state) {
              return StreamBuilder<User?>(
                stream: _authRepository.authStateChanges,
                initialData: _authRepository.currentUser,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const _LoadingScreen();
                  }

                  if (snapshot.data == null) {
                    return _buildLoginScreen(context);
                  }

                  return const HomeScreen();
                },
              );
            },
          ),

          GoRoute(
            path: search,
            builder: (context, state) {
              return SearchScreen(
                onProductTap: (product) {
                  context.push(productDetails, extra: product);
                },
              );
            },
          ),

          GoRoute(
            path: wishlist,
            builder: (context, state) {
              return const _WishlistRouteScreen();
            },
          ),

          GoRoute(
            path: cart,
            builder: (context, state) {
              return const _CartRouteScreen();
            },
          ),

          GoRoute(
            path: profile,
            builder: (context, state) {
              if (_authRepository.currentUser == null) {
                return _buildLoginScreen(context);
              }

              return const ProfileScreen();
            },
          ),
        ],
      ),

      // ---------------------------------------------------------------
      // AUTHENTICATION AND OTHER SCREENS
      // ---------------------------------------------------------------
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const _ForgotPasswordScreen(),
      ),

      GoRoute(
        path: products,
        builder: (context, state) {
          final extra = state.extra;

          if (extra is CategoryModel) {
            return ProductCatalogScreen(
              categorySlug: extra.slug,
              title: extra.displayName,
            );
          }

          if (extra is String) {
            return ProductCatalogScreen(
              categorySlug: extra,
              title: extra.isEmpty ? 'All Products' : extra,
            );
          }

          return const ProductCatalogScreen(title: 'All Products');
        },
      ),

      GoRoute(
        path: productDetails,
        builder: (context, state) {
          final product = state.extra;

          if (product is Product) {
            return ProductDetailsScreen(product: product);
          }

          return const _MissingProductScreen();
        },
      ),

      GoRoute(
        path: checkout,
        builder: (context, state) {
          if (_authRepository.currentUser == null) {
            return _buildLoginScreen(context);
          }

          return const _CheckoutRouteScreen();
        },
      ),

      GoRoute(
        path: address,
        builder: (context, state) {
          if (_authRepository.currentUser == null) {
            return _buildLoginScreen(context);
          }

          return const _AddressRouteScreen();
        },
      ),

      GoRoute(
        path: payment,
        builder: (context, state) {
          if (_authRepository.currentUser == null) {
            return _buildLoginScreen(context);
          }

          return const _PaymentRouteScreen();
        },
      ),

      GoRoute(
        path: orders,
        builder: (context, state) {
          if (_authRepository.currentUser == null) {
            return _buildLoginScreen(context);
          }

          return const _OrdersRouteScreen();
        },
      ),

      GoRoute(
        path: orderDetails,
        builder: (context, state) {
          final order = state.extra;

          if (order is! OrderModel) {
            return const _MissingOrderScreen();
          }

          final user = _authRepository.currentUser;

          if (user == null || order.userId != user.uid) {
            return _buildLoginScreen(context);
          }

          return _OrderDetailsRouteScreen(order: order);
        },
      ),

      GoRoute(
        path: orderSuccess,
        builder: (context, state) {
          final order = state.extra;

          if (order is! OrderModel) {
            return const _MissingOrderScreen();
          }

          return OrderSuccessScreen(
            orderId: order.id,
            totalAmount: order.total,
            onContinueShopping: () {
              context.go(home);
            },
            onViewOrder: () {
              context.go(orderDetails, extra: order);
            },
          );
        },
      ),

      GoRoute(
        path: onboarding,
        builder: (context, state) {
          return const _FeaturePlaceholderScreen(title: 'Onboarding');
        },
      ),

      GoRoute(
        path: editProfile,
        builder: (context, state) {
          return const _FeaturePlaceholderScreen(title: 'Edit Profile');
        },
      ),

      GoRoute(
        path: settings,
        builder: (context, state) {
          if (_authRepository.currentUser == null) {
            return _buildLoginScreen(context);
          }

          return SettingsRouteScreen(themeController: _themeController);
        },
      ),
    ],
    errorBuilder: (context, state) {
      return const Scaffold(body: Center(child: Text('Page not found.')));
    },
  );

  static Widget _buildLoginScreen(BuildContext context) {
    return LoginScreen(
      onLogin: (email, password) async {
        await _authRepository.login(email: email, password: password);

        if (context.mounted) {
          context.go(home);
        }
      },
      onSignup: () => context.push(signup),
      onForgotPassword: () => context.push(forgotPassword),
    );
  }
}

// -----------------------------------------------------------------------------
// CART ROUTE
// -----------------------------------------------------------------------------

class _CartRouteScreen extends ConsumerWidget {
  const _CartRouteScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);

    return cartAsync.when(
      loading: () => const _LoadingScreen(),
      error:
          (error, stackTrace) => _ErrorScreen(
            title: 'Unable to load your cart',
            onRetry: () {
              ref.read(cartProvider.notifier).refreshCart();
            },
          ),
      data: (savedItems) {
        final cartItems = <CartItemModel>[];

        for (final item in savedItems) {
          try {
            cartItems.add(CartItemModel.fromJson(item));
          } catch (_) {
            continue;
          }
        }

        return CartScreen(
          cartItems: cartItems,
          onIncrease: (item) async {
            try {
              await ref
                  .read(cartProvider.notifier)
                  .updateProductQuantity(item.product.id, item.quantity + 1);
            } catch (error) {
              if (context.mounted) {
                _showError(context, error);
              }
            }
          },
          onDecrease: (item) async {
            try {
              await ref
                  .read(cartProvider.notifier)
                  .updateProductQuantity(item.product.id, item.quantity - 1);
            } catch (error) {
              if (context.mounted) {
                _showError(context, error);
              }
            }
          },
          onRemove: (item) async {
            try {
              await ref
                  .read(cartProvider.notifier)
                  .removeProduct(item.product.id);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product removed from cart.')),
                );
              }
            } catch (error) {
              if (context.mounted) {
                _showError(context, error);
              }
            }
          },
          onCheckout: () {
            if (cartItems.isEmpty) {
              _showError(context, Exception('Your cart is empty.'));
              return;
            }

            context.push(AppRouter.checkout);
          },
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// WISHLIST ROUTE
// -----------------------------------------------------------------------------

class _WishlistRouteScreen extends ConsumerWidget {
  const _WishlistRouteScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistProvider);

    return wishlistAsync.when(
      loading: () => const _LoadingScreen(),
      error:
          (error, stackTrace) => _ErrorScreen(
            title: 'Unable to load your wishlist',
            onRetry: () {
              ref.read(wishlistProvider.notifier).refreshWishlist();
            },
          ),
      data: (products) {
        return WishlistScreen(
          products: products,
          onRemove: (product) async {
            try {
              await ref
                  .read(wishlistProvider.notifier)
                  .removeProduct(product.id);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product removed from wishlist.'),
                  ),
                );
              }
            } catch (error) {
              if (context.mounted) {
                _showError(context, error);
              }
            }
          },
          onAddToCart: (product) async {
            try {
              await ref.read(cartProvider.notifier).addProduct(product);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product added to cart.')),
                );
              }
            } catch (error) {
              if (context.mounted) {
                _showError(context, error);
              }
            }
          },
          onProductTap: (product) {
            context.push(AppRouter.productDetails, extra: product);
          },
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// CHECKOUT ROUTE
// -----------------------------------------------------------------------------

class _CheckoutRouteScreen extends ConsumerWidget {
  const _CheckoutRouteScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);
    final addressesAsync = ref.watch(savedAddressesProvider);

    final selectedAddress = ref.watch(selectedAddressProvider);
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);

    final subtotal = ref.watch(checkoutSubtotalProvider);
    final shipping = ref.watch(checkoutShippingFeeProvider);
    final discount = ref.watch(checkoutDiscountProvider);
    final total = ref.watch(checkoutTotalProvider);

    final savedAddresses = addressesAsync.asData?.value ?? [];

    AddressModel? defaultAddress;

    for (final address in savedAddresses) {
      if (address.isDefault) {
        defaultAddress = address;
        break;
      }
    }

    final effectiveAddress = selectedAddress ?? defaultAddress;

    final paymentTitle =
        selectedPayment == PaymentMethodType.creditDebitCard
            ? 'Credit / Debit Card'
            : 'Cash on Delivery';

    return cartAsync.when(
      loading: () => const _LoadingScreen(),
      error:
          (error, stackTrace) => _ErrorScreen(
            title: 'Unable to load checkout information',
            onRetry: () {
              ref.read(cartProvider.notifier).refreshCart();
            },
          ),
      data: (savedItems) {
        final cartItems = <CartItemModel>[];

        for (final item in savedItems) {
          try {
            cartItems.add(CartItemModel.fromJson(item));
          } catch (_) {
            continue;
          }
        }

        if (cartItems.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Checkout')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 65),
                  const SizedBox(height: 16),
                  const Text('Your cart is empty.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go(AppRouter.products),
                    child: const Text('Browse Products'),
                  ),
                ],
              ),
            ),
          );
        }

        return CheckoutScreen(
          subtotal: subtotal,
          shipping: shipping,
          discount: discount,
          selectedAddress: effectiveAddress?.formattedAddress,
          selectedPaymentMethod: paymentTitle,
          onSelectAddress: () {
            context.push(AppRouter.address);
          },
          onSelectPayment: () {
            context.push(AppRouter.payment);
          },
          onPlaceOrder: () async {
            if (effectiveAddress == null) {
              _showError(
                context,
                Exception('Please select a delivery address.'),
              );
              return;
            }

            if (cartItems.any(
              (item) =>
                  !item.product.isInStock || item.quantity > item.product.stock,
            )) {
              _showError(
                context,
                Exception(
                  'One or more products are unavailable in the selected quantity.',
                ),
              );
              return;
            }

            final user = FirebaseAuth.instance.currentUser;

            if (user == null) {
              context.go(AppRouter.login);
              return;
            }

            try {
              final now = DateTime.now();

              final order = OrderModel(
                id: 'ORD-${now.microsecondsSinceEpoch}',
                userId: user.uid,
                items: cartItems,
                subtotal: subtotal,
                shippingFee: shipping,
                discount: discount,
                total: total,
                shippingAddress: effectiveAddress.toJson(),
                paymentMethod: paymentTitle,
                paymentStatus: 'Pending',
                status: 'Placed',
                createdAt: now,
                updatedAt: now,
              );

              await ref.read(orderProvider.notifier).addOrder(order);
              await ref.read(cartProvider.notifier).clearCart();

              if (context.mounted) {
                context.go(AppRouter.orderSuccess, extra: order);
              }
            } catch (error) {
              if (context.mounted) {
                _showError(context, error);
              }
            }
          },
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// ADDRESS ROUTE
// -----------------------------------------------------------------------------

class _AddressRouteScreen extends ConsumerWidget {
  const _AddressRouteScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(savedAddressesProvider);

    return addressesAsync.when(
      loading: () => const _LoadingScreen(),
      error:
          (error, stackTrace) => _ErrorScreen(
            title: 'Unable to load saved addresses',
            onRetry: () {
              ref.read(savedAddressesProvider.notifier).refresh();
            },
          ),
      data: (addresses) {
        return AddressScreen(
          addresses: addresses,
          onSaveAddress: (address) async {
            try {
              await ref
                  .read(savedAddressesProvider.notifier)
                  .addAddress(address);

              ref.read(selectedAddressProvider.notifier).select(address);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Address saved successfully.')),
                );
              }
            } catch (error) {
              if (context.mounted) {
                _showError(context, error);
              }
            }
          },
          onSelectAddress: (address) {
            ref.read(selectedAddressProvider.notifier).select(address);
            context.pop();
          },
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// PAYMENT ROUTE
// -----------------------------------------------------------------------------

class _PaymentRouteScreen extends ConsumerWidget {
  const _PaymentRouteScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMethod = ref.watch(selectedPaymentMethodProvider);

    final selectedValue =
        selectedMethod == PaymentMethodType.creditDebitCard
            ? 'Credit / Debit Card'
            : 'Cash on Delivery';

    return PaymentScreen(
      selectedMethod: selectedValue,
      onPaymentSelected: (value) {
        if (value == 'Cash on Delivery') {
          ref
              .read(selectedPaymentMethodProvider.notifier)
              .select(PaymentMethodType.cashOnDelivery);
        } else if (value == 'Credit / Debit Card') {
          ref
              .read(selectedPaymentMethodProvider.notifier)
              .select(PaymentMethodType.creditDebitCard);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This payment method is not currently supported.'),
            ),
          );
        }
      },
      onContinue: () {
        context.pop();
      },
    );
  }
}

// -----------------------------------------------------------------------------
// ORDERS ROUTE
// -----------------------------------------------------------------------------

class _OrdersRouteScreen extends ConsumerStatefulWidget {
  const _OrdersRouteScreen();

  @override
  ConsumerState<_OrdersRouteScreen> createState() => _OrdersRouteScreenState();
}

class _OrdersRouteScreenState extends ConsumerState<_OrdersRouteScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        ref.read(orderProvider.notifier).loadOrders(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(orderProvider);

    return ordersAsync.when(
      loading: () => const _LoadingScreen(),
      error:
          (error, stackTrace) => _ErrorScreen(
            title: 'Unable to load your orders',
            onRetry: () {
              final user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                ref.read(orderProvider.notifier).loadOrders(user.uid);
              }
            },
          ),
      data: (orders) {
        return OrdersScreen(
          orders: orders,
          onOrderTap: (order) {
            context.push(AppRouter.orderDetails, extra: order);
          },
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// ORDER DETAILS ROUTE
// -----------------------------------------------------------------------------

class _OrderDetailsRouteScreen extends ConsumerWidget {
  const _OrderDetailsRouteScreen({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OrderDetailsScreen(
      order: order,
      onTrackOrder: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Order tracking will be available when delivery tracking is integrated.',
            ),
          ),
        );
      },
      onCancelOrder: () async {
        try {
          final updatedOrder = order.copyWith(
            status: 'Cancelled',
            updatedAt: DateTime.now(),
          );

          await ref.read(orderProvider.notifier).updateOrder(updatedOrder);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order cancelled successfully.')),
            );

            context.pop();
          }
        } catch (error) {
          if (context.mounted) {
            _showError(context, error);
          }
        }
      },
    );
  }
}

// -----------------------------------------------------------------------------
// COMMON ERROR HANDLING
// -----------------------------------------------------------------------------

void _showError(BuildContext context, Object error) {
  final message = error.toString().replaceFirst('Exception: ', '');

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  );
}

// -----------------------------------------------------------------------------
// LOADING SCREEN
// -----------------------------------------------------------------------------

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

// -----------------------------------------------------------------------------
// ERROR SCREEN
// -----------------------------------------------------------------------------

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.title, required this.onRetry});

  final String title;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Something went wrong')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 55, color: colors.error),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// MISSING PRODUCT SCREEN
// -----------------------------------------------------------------------------

class _MissingProductScreen extends StatelessWidget {
  const _MissingProductScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.inventory_2_outlined, size: 60),
              const SizedBox(height: 16),
              const Text(
                'Product information is unavailable.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(AppRouter.products),
                child: const Text('Browse Products'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// MISSING ORDER SCREEN
// -----------------------------------------------------------------------------

class _MissingOrderScreen extends StatelessWidget {
  const _MissingOrderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.receipt_long_outlined, size: 60),
              const SizedBox(height: 16),
              const Text(
                'Order information is unavailable.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(AppRouter.orders),
                child: const Text('View My Orders'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// FORGOT PASSWORD SCREEN
// -----------------------------------------------------------------------------

class _ForgotPasswordScreen extends StatefulWidget {
  const _ForgotPasswordScreen();

  @override
  State<_ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<_ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await AppRouter._authRepository.resetPassword(
        _emailController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent. Check your inbox.'),
        ),
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Unable to send reset email.')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_reset_rounded, size: 65),
              const SizedBox(height: 20),
              const Text(
                'Reset your password',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter your email address and we will send you a reset link.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email.';
                  }

                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _loading ? null : _sendResetEmail,
                  child:
                      _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Send Reset Link'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// PLACEHOLDER SCREEN
// -----------------------------------------------------------------------------

class _FeaturePlaceholderScreen extends StatelessWidget {
  const _FeaturePlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title screen is coming soon.')),
    );
  }
}

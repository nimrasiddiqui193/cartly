class AppConstants {
  AppConstants._();

  // Application information
  static const String appName = 'Cartly';
  static const String tagline = 'Everything you love, in one cart';

  // API configuration
  static const String baseUrl = 'https://dummyjson.com';
  static const int productsPerPage = 20;
  static const int apiTimeoutSeconds = 15;

  // API endpoints
  static const String productsEndpoint = '/products';
  static const String categoriesEndpoint = '/products/categories';
  static const String searchEndpoint = '/products/search';

  // Currency
  static const String currencyCode = 'PKR';
  static const String currencySymbol = 'Rs.';

  // Search
  static const int searchMinCharacters = 2;
  static const int searchDebounceMilliseconds = 350;

  // Pagination
  static const int initialPage = 0;
  static const int initialProductSkip = 0;

  // Cart
  static const int minimumQuantity = 1;
  static const int maximumQuantity = 99;

  // Spacing
  static const double spacingXS = 4;
  static const double spacingS = 8;
  static const double spacingM = 16;
  static const double spacingL = 24;
  static const double spacingXL = 32;

  // Border radius
  static const double radiusS = 8;
  static const double radiusM = 12;
  static const double radiusL = 16;
  static const double radiusXL = 24;

  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Storage keys
  static const String themePreferenceKey = 'cartly_theme_mode';
  static const String cartStorageKey = 'cartly_cart';
  static const String wishlistStorageKey = 'cartly_wishlist';
  static const String onboardingCompletedKey = 'cartly_onboarding_completed';

  // Firebase collections
  static const String usersCollection = 'users';
  static const String ordersCollection = 'orders';
  static const String addressesCollection = 'addresses';

  // Order statuses
  static const String orderPending = 'Pending';
  static const String orderConfirmed = 'Confirmed';
  static const String orderProcessing = 'Processing';
  static const String orderShipped = 'Shipped';
  static const String orderDelivered = 'Delivered';
  static const String orderCancelled = 'Cancelled';
}

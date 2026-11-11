import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

final productsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).getProducts();
});

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) {
  return ref.watch(productRepositoryProvider).getCategories();
});

final allProductsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).getAllProducts();
});

final productDetailsProvider = FutureProvider.family<Product, int>((
  ref,
  productId,
) {
  return ref.watch(productRepositoryProvider).getProductById(productId);
});

final categoryProductsProvider = FutureProvider.family<List<Product>, String>((
  ref,
  categorySlug,
) {
  return ref
      .watch(productRepositoryProvider)
      .getProductsByCategory(categorySlug);
});

final productSearchProvider = FutureProvider.family<List<Product>, String>((
  ref,
  query,
) {
  if (query.trim().isEmpty) {
    return Future.value([]);
  }

  return ref.watch(productRepositoryProvider).searchProducts(query.trim());
});

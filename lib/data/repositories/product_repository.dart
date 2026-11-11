import '../models/product_model.dart';
import '../models/category_model.dart';
import '../services/product_service.dart';

class ProductRepository {
  ProductRepository({ProductService? productService})
    : _productService = productService ?? ProductService();

  final ProductService _productService;

  /// Fetches products with pagination.
  Future<List<Product>> getProducts({int limit = 20, int skip = 0}) {
    return _productService.getProducts(limit: limit, skip: skip);
  }

  /// Fetches a product using its ID.
  Future<Product> getProductById(int id) {
    return _productService.getProductById(id);
  }

  /// Searches products by keyword.
  Future<List<Product>> searchProducts(String query) {
    return _productService.searchProducts(query);
  }

  /// Fetches all available categories.
  Future<List<CategoryModel>> getCategories() {
    return _productService.getCategories();
  }

  /// Fetches products belonging to a category.
  Future<List<Product>> getProductsByCategory(String categorySlug) {
    return _productService.getProductsByCategory(categorySlug);
  }

  /// Fetches all available products.
  Future<List<Product>> getAllProducts() {
    return _productService.getAllProducts();
  }
}

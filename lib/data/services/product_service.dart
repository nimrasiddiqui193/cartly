import '../models/product_model.dart';
import '../models/category_model.dart';
import 'api_service.dart';

class ProductService {
  ProductService({ApiService? apiService})
    : _apiService = apiService ?? ApiService.instance;

  final ApiService _apiService;

  List<Product> _parseProducts(dynamic response) {
    if (response is! Map || response['products'] is! List) {
      throw Exception('Invalid product response from server.');
    }

    return (response['products'] as List)
        .whereType<Map>()
        .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<List<Product>> getProducts({int limit = 20, int skip = 0}) async {
    final response = await _apiService.get(
      '/products',
      queryParameters: {'limit': limit, 'skip': skip},
    );

    return _parseProducts(response);
  }

  Future<Product> getProductById(int id) async {
    final response = await _apiService.get('/products/$id');

    if (response is! Map) {
      throw Exception('Invalid product details response.');
    }

    return Product.fromJson(Map<String, dynamic>.from(response));
  }

  Future<List<Product>> searchProducts(String query) async {
    final cleanedQuery = query.trim();

    if (cleanedQuery.isEmpty) {
      return getProducts();
    }

    final response = await _apiService.get(
      '/products/search',
      queryParameters: {'q': cleanedQuery},
    );

    return _parseProducts(response);
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiService.get('/products/categories');

    if (response is! List) {
      throw Exception('Invalid categories response from server.');
    }

    return response
        .whereType<Map>()
        .map((item) => CategoryModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<List<Product>> getProductsByCategory(String categorySlug) async {
    final slug = categorySlug.trim();

    if (slug.isEmpty) {
      return getProducts();
    }

    final response = await _apiService.get('/products/category/$slug');

    return _parseProducts(response);
  }

  Future<List<Product>> getAllProducts() async {
    // DummyJSON supports limit=0 to request all available products.
    final response = await _apiService.get(
      '/products',
      queryParameters: {'limit': 0},
    );

    return _parseProducts(response);
  }
}

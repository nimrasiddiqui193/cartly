class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String thumbnail;
  final List<String> images;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];

    final parsedImages =
        rawImages is List
            ? rawImages
                .where((image) => image != null)
                .map((image) => image.toString())
                .where((image) => image.isNotEmpty)
                .toList()
            : <String>[];

    return Product(
      id: _toInt(json['id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: _toDouble(json['price']),
      discountPercentage: _toDouble(json['discountPercentage']),
      rating: _toDouble(json['rating']),
      stock: _toInt(json['stock']),
      brand: json['brand']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      images: parsedImages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'thumbnail': thumbnail,
      'images': images,
    };
  }

  double get discountedPrice {
    return price * (1 - discountPercentage / 100);
  }

  bool get isInStock => stock > 0;

  bool get hasDiscount => discountPercentage > 0;

  double get savings => price - discountedPrice;

  int get discountPercentageRounded => discountPercentage.round();

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();

    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}

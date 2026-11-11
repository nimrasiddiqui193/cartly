class CategoryModel {
  final String slug;
  final String name;
  final String url;

  const CategoryModel({
    required this.slug,
    required this.name,
    required this.url,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      slug: json['slug']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'slug': slug, 'name': name, 'url': url};
  }

  String get displayName {
    if (name.isEmpty) return name;

    return name
        .split(RegExp(r'[-_\s]+'))
        .where((word) => word.isNotEmpty)
        .map(
          (word) =>
              '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}

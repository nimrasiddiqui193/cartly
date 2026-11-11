import 'package:flutter/material.dart';

class ProductImageGallery extends StatefulWidget {
  final List<String> images;

  const ProductImageGallery({super.key, required this.images});

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  int _selectedIndex = 0;

  List<String> get _validImages {
    return widget.images
        .where((image) => image.trim().isNotEmpty)
        .toSet()
        .toList();
  }

  @override
  void didUpdateWidget(covariant ProductImageGallery oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.images != widget.images) {
      _selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final images = _validImages;

    if (images.isEmpty) {
      return _buildPlaceholder(colors);
    }

    final safeIndex = _selectedIndex < images.length ? _selectedIndex : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 3,
                  child: Image.network(
                    images[safeIndex],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder(colors);
                    },
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;

                      return Center(
                        child: CircularProgressIndicator(
                          color: colors.primary,
                          strokeWidth: 2.5,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                right: 14,
                bottom: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${safeIndex + 1} / ${images.length}',
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (images.length > 1) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 76,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 11),
              itemBuilder: (context, index) {
                final isSelected = safeIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 76,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color:
                            isSelected
                                ? colors.primary
                                : colors.outlineVariant.withValues(alpha: 0.5),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        images[index],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported_outlined,
                            color: colors.onSurfaceVariant,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlaceholder(ColorScheme colors) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 65,
        color: colors.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }
}

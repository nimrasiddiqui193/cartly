import 'package:flutter/material.dart';

class SearchFilters extends StatefulWidget {
  final List<String> categories;
  final String? selectedCategory;
  final RangeValues initialPriceRange;
  final double minPrice;
  final double maxPrice;
  final String initialSortBy;
  final ValueChanged<String?>? onCategoryChanged;
  final ValueChanged<RangeValues>? onPriceChanged;
  final ValueChanged<String>? onSortChanged;
  final VoidCallback? onReset;

  const SearchFilters({
    super.key,
    this.categories = const [],
    this.selectedCategory,
    this.initialPriceRange = const RangeValues(0, 500000),
    this.minPrice = 0,
    this.maxPrice = 500000,
    this.initialSortBy = 'Recommended',
    this.onCategoryChanged,
    this.onPriceChanged,
    this.onSortChanged,
    this.onReset,
  });

  @override
  State<SearchFilters> createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  String? selectedCategory;
  late RangeValues priceRange;
  late String sortBy;

  final List<String> sortOptions = const [
    'Recommended',
    'Price: Low to High',
    'Price: High to Low',
    'Top Rated',
    'Newest',
  ];

  @override
  void initState() {
    super.initState();
    _syncValues();
  }

  void _syncValues() {
    selectedCategory =
        widget.categories.contains(widget.selectedCategory)
            ? widget.selectedCategory
            : null;

    priceRange = _safeRange(widget.initialPriceRange);

    sortBy =
        sortOptions.contains(widget.initialSortBy)
            ? widget.initialSortBy
            : 'Recommended';
  }

  RangeValues _safeRange(RangeValues range) {
    final min = widget.minPrice;
    final max = widget.maxPrice > min ? widget.maxPrice : min + 1;

    final start = range.start.clamp(min, max).toDouble();
    final end = range.end.clamp(min, max).toDouble();

    return RangeValues(start <= end ? start : end, end >= start ? end : start);
  }

  @override
  void didUpdateWidget(covariant SearchFilters oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedCategory != widget.selectedCategory ||
        oldWidget.initialPriceRange != widget.initialPriceRange ||
        oldWidget.initialSortBy != widget.initialSortBy ||
        oldWidget.minPrice != widget.minPrice ||
        oldWidget.maxPrice != widget.maxPrice ||
        oldWidget.categories != widget.categories) {
      _syncValues();
    }
  }

  void _resetFilters() {
    setState(() {
      selectedCategory = null;
      priceRange = RangeValues(
        widget.minPrice,
        widget.maxPrice > widget.minPrice
            ? widget.maxPrice
            : widget.minPrice + 1,
      );
      sortBy = 'Recommended';
    });

    widget.onCategoryChanged?.call(null);
    widget.onPriceChanged?.call(priceRange);
    widget.onSortChanged?.call(sortBy);
    widget.onReset?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final sliderMin = widget.minPrice;
    final sliderMax =
        widget.maxPrice > sliderMin ? widget.maxPrice : sliderMin + 1;

    final availableCategories = widget.categories.toSet().toList();

    final categoryValue =
        availableCategories.contains(selectedCategory)
            ? selectedCategory
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Filters',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _resetFilters,
              icon: Icon(
                Icons.refresh_rounded,
                size: 17,
                color: colors.primary,
              ),
              label: Text(
                'Reset',
                style: TextStyle(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          'Category',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String?>(
          value: categoryValue,
          isExpanded: true,
          decoration: _inputDecoration(context, 'All Categories'),
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('All Categories'),
            ),
            ...availableCategories.map(
              (category) => DropdownMenuItem<String?>(
                value: category,
                child: Text(category, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
          onChanged: (value) {
            setState(() {
              selectedCategory = value;
            });
            widget.onCategoryChanged?.call(value);
          },
        ),
        const SizedBox(height: 25),
        Text(
          'Price Range',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: _safeRange(priceRange),
          min: sliderMin,
          max: sliderMax,
          divisions: 100,
          activeColor: colors.primary,
          inactiveColor: colors.primary.withValues(alpha: 0.15),
          labels: RangeLabels(
            'Rs. ${priceRange.start.toStringAsFixed(0)}',
            'Rs. ${priceRange.end.toStringAsFixed(0)}',
          ),
          onChanged: (values) {
            setState(() {
              priceRange = values;
            });
            widget.onPriceChanged?.call(values);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _priceLabel(context, 'Rs. ${priceRange.start.toStringAsFixed(0)}'),
            _priceLabel(context, 'Rs. ${priceRange.end.toStringAsFixed(0)}'),
          ],
        ),
        const SizedBox(height: 25),
        Text(
          'Sort By',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: sortOptions.contains(sortBy) ? sortBy : 'Recommended',
          isExpanded: true,
          decoration: _inputDecoration(context, 'Select sorting'),
          items:
              sortOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              sortBy = value;
            });

            widget.onSortChanged?.call(value);
          },
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    final colors = Theme.of(context).colorScheme;

    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(
          color: colors.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(
          color: colors.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
    );
  }

  Widget _priceLabel(BuildContext context, String value) {
    return Text(
      value,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

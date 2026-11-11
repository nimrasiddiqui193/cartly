import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final String hintText;
  final bool showFilter;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onFilterTap,
    this.hintText = 'Search products...',
    this.showFilter = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon:
                  controller.text.isNotEmpty
                      ? IconButton(
                        onPressed: () {
                          controller.clear();
                          onChanged?.call('');
                        },
                        icon: const Icon(Icons.close_rounded),
                      )
                      : null,
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        if (showFilter) ...[
          const SizedBox(width: 10),
          Material(
            color: const Color(0xFFE68A45),
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: onFilterTap,
              borderRadius: BorderRadius.circular(14),
              child: const SizedBox(
                height: 54,
                width: 54,
                child: Icon(Icons.tune_rounded, color: Colors.white),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

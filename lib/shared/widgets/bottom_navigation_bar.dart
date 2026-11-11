import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const Color _orange = Color(0xFFE68A45);
  static const Color _deepOrange = Color(0xFFB95F2D);

  static const List<_NavItemData> _items = [
    _NavItemData(icon: Icons.home_rounded, label: 'Home'),
    _NavItemData(icon: Icons.search_rounded, label: 'Search'),
    _NavItemData(icon: Icons.favorite_rounded, label: 'Wishlist'),
    _NavItemData(icon: Icons.shopping_bag_rounded, label: 'Cart'),
    _NavItemData(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF20232D) : Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color:
                isDark
                    ? Colors.white.withValues(alpha: 0.07)
                    : const Color(0xFFF1E5DB),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: _deepOrange.withValues(alpha: isDark ? 0.20 : 0.14),
              blurRadius: 25,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];

            return Expanded(
              child: _BottomNavItem(
                icon: item.icon,
                label: item.label,
                selected: currentIndex == index,
                orange: _orange,
                onTap: () => onTap(index),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.orange,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final Color orange;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final inactiveColor = colors.onSurface.withValues(alpha: 0.58);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: selected ? orange.withValues(alpha: 0.13) : Colors.transparent,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(19),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: selected ? 1.10 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: Icon(
                    icon,
                    size: 22,
                    color: selected ? orange : inactiveColor,
                  ),
                ),
                const SizedBox(height: 5),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    color: selected ? orange : inactiveColor,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  height: 3,
                  width: selected ? 16 : 0,
                  decoration: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

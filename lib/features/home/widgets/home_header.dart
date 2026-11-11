import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSearchTap;

  const HomeHeader({
    super.key,
    this.userName = 'Shopper',
    this.onNotificationTap,
    this.onProfileTap,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryText =
        isDark ? const Color(0xFFF5F1EC) : const Color(0xFF29231F);

    final secondaryText =
        isDark ? const Color(0xFFBDB5AD) : const Color(0xFF77716B);

    final cardColor = Theme.of(context).cardColor;
    const orange = Color(0xFFE68A45);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $userName!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: secondaryText,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Find your favorites',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: primaryText,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
            ),
            _HeaderButton(
              icon: Icons.notifications_none_rounded,
              onTap: onNotificationTap,
              iconColor: orange,
            ),
            const SizedBox(width: 10),
            _HeaderButton(
              icon: Icons.person_outline_rounded,
              onTap: onProfileTap,
              iconColor: orange,
            ),
          ],
        ),
        const SizedBox(height: 22),
        Material(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onSearchTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: orange.withValues(alpha: isDark ? 0.18 : 0.13),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, color: secondaryText, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search products...',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: secondaryText,
                      ),
                    ),
                  ),
                  const Icon(Icons.tune_rounded, color: orange, size: 21),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color iconColor;

  const _HeaderButton({
    required this.icon,
    this.onTap,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: iconColor.withValues(alpha: isDark ? 0.20 : 0.14),
            ),
          ),
          child: Icon(icon, size: 22, color: iconColor),
        ),
      ),
    );
  }
}

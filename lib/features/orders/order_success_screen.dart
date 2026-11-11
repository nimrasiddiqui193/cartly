import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final double totalAmount;
  final VoidCallback? onContinueShopping;
  final VoidCallback? onViewOrder;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.totalAmount,
    this.onContinueShopping,
    this.onViewOrder,
  });

  static const Color primaryOrange = Color(0xFFE68A45);
  static const Color darkOrange = Color(0xFFB95F2D);
  static const Color successGreen = Color(0xFF168653);

  Widget _buildDetailRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Icon(icon, size: 19, color: primaryOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryText =
        isDark ? const Color(0xFFE9E2DB) : const Color(0xFF332B25);

    final secondaryText =
        isDark ? const Color(0xFFAAA19A) : const Color(0xFF77716B);

    final cardColor = theme.cardColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 15),

                // Success illustration.
                Container(
                  width: 142,
                  height: 142,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: successGreen.withValues(alpha: 0.09),
                  ),
                  child: Center(
                    child: Container(
                      width: 108,
                      height: 108,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: successGreen.withValues(alpha: 0.14),
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: successGreen,
                        size: 82,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 27),

                Text(
                  'Order Placed Successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: primaryText,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Thank you for shopping with Cartly. '
                  'Your order has been received and is being processed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 30),

                // Order information card.
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(21),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(
                      color: primaryOrange.withValues(
                        alpha: isDark ? 0.16 : 0.12,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.16 : 0.05,
                        ),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'ORDER CONFIRMATION',
                        style: TextStyle(
                          color: primaryOrange,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Container(
                        width: 53,
                        height: 53,
                        decoration: BoxDecoration(
                          color: primaryOrange.withValues(alpha: 0.11),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.receipt_long_outlined,
                          color: primaryOrange,
                          size: 27,
                        ),
                      ),

                      const SizedBox(height: 13),

                      Text(
                        '#$orderId',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: primaryText,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'Your order reference number',
                        style: TextStyle(fontSize: 11, color: secondaryText),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Divider(
                          height: 1,
                          color: theme.dividerColor.withValues(alpha: 0.35),
                        ),
                      ),

                      _buildDetailRow(
                        context: context,
                        icon: Icons.shopping_bag_outlined,
                        label: 'Order Status',
                        value: 'Placed',
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                      ),

                      _buildDetailRow(
                        context: context,
                        icon: Icons.payments_outlined,
                        label: 'Total Amount',
                        value: AppFormatters.formatPrice(totalAmount),
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                      ),

                      _buildDetailRow(
                        context: context,
                        icon: Icons.local_shipping_outlined,
                        label: 'Delivery',
                        value: 'Standard Delivery',
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Order tracking information.
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: primaryOrange.withValues(
                      alpha: isDark ? 0.12 : 0.08,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: primaryOrange.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.notifications_active_outlined,
                        color: primaryOrange,
                        size: 23,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You can view your order details and follow '
                          'its progress from your order history.',
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.5,
                            color: primaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 27),

                // View order button.
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: onViewOrder,
                    icon: const Icon(Icons.receipt_long_outlined),
                    label: const Text(
                      'View My Order',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryOrange,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shadowColor: darkOrange.withValues(alpha: 0.25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Continue shopping button.
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton.icon(
                    onPressed: onContinueShopping,
                    icon: const Icon(Icons.storefront_outlined),
                    label: const Text(
                      'Continue Shopping',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryOrange,
                      side: const BorderSide(color: primaryOrange, width: 1.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                Text(
                  'Thank you for choosing Cartly!',
                  style: TextStyle(
                    fontSize: 11,
                    color: secondaryText,
                    fontWeight: FontWeight.w500,
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

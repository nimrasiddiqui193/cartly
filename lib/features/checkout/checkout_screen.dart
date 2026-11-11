import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';

class CheckoutScreen extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final double discount;
  final String? selectedAddress;
  final String? selectedPaymentMethod;
  final VoidCallback? onSelectAddress;
  final VoidCallback? onSelectPayment;
  final VoidCallback? onPlaceOrder;

  const CheckoutScreen({
    super.key,
    required this.subtotal,
    this.shipping = 0,
    this.discount = 0,
    this.selectedAddress,
    this.selectedPaymentMethod,
    this.onSelectAddress,
    this.onSelectPayment,
    this.onPlaceOrder,
  });

  static const Color primaryOrange = Color(0xFFE68A45);
  static const Color darkOrange = Color(0xFFB95F2D);
  static const Color lightOrange = Color(0xFFFFF0E3);

  double get total {
    return (subtotal + shipping - discount)
        .clamp(0.0, double.infinity)
        .toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = theme.textTheme.bodyMedium?.color?.withValues(
      alpha: 0.65,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: darkOrange,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 22, 18, 30),
        children: [
          _buildProgressIndicator(),
          const SizedBox(height: 28),

          _sectionHeader(
            title: 'Delivery Address',
            subtitle: 'Where should we deliver your order?',
            icon: Icons.location_on_outlined,
            isDark: isDark,
          ),
          const SizedBox(height: 13),

          _optionCard(
            context: context,
            icon: Icons.location_on_outlined,
            title: selectedAddress ?? 'Select delivery address',
            subtitle:
                selectedAddress == null
                    ? 'Add or choose your delivery location'
                    : 'Your selected delivery location',
            onTap: onSelectAddress,
            isSelected: selectedAddress != null,
          ),

          const SizedBox(height: 27),

          _sectionHeader(
            title: 'Payment Method',
            subtitle: 'Choose your preferred payment option.',
            icon: Icons.account_balance_wallet_outlined,
            isDark: isDark,
          ),
          const SizedBox(height: 13),

          _optionCard(
            context: context,
            icon: Icons.payment_outlined,
            title: selectedPaymentMethod ?? 'Select payment method',
            subtitle:
                selectedPaymentMethod == null
                    ? 'Choose how you want to pay'
                    : 'Your selected payment option',
            onTap: onSelectPayment,
            isSelected: selectedPaymentMethod != null,
          ),

          const SizedBox(height: 27),

          _sectionHeader(
            title: 'Order Summary',
            subtitle: 'Review your payment details.',
            icon: Icons.receipt_long_outlined,
            isDark: isDark,
          ),
          const SizedBox(height: 13),

          Container(
            padding: const EdgeInsets.all(19),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.045),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _summaryRow(
                  'Subtotal',
                  AppFormatters.formatPrice(subtotal),
                  textColor: textColor,
                  secondaryColor: secondaryColor,
                ),
                const SizedBox(height: 15),
                _summaryRow(
                  'Shipping',
                  shipping == 0 ? 'Free' : AppFormatters.formatPrice(shipping),
                  textColor: textColor,
                  secondaryColor: secondaryColor,
                  valueColor: shipping == 0 ? Colors.green : null,
                ),
                if (discount > 0) ...[
                  const SizedBox(height: 15),
                  _summaryRow(
                    'Discount',
                    '-${AppFormatters.formatPrice(discount)}',
                    textColor: textColor,
                    secondaryColor: secondaryColor,
                    valueColor: Colors.green,
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Divider(
                    color:
                        isDark
                            ? Colors.white12
                            : Colors.grey.withValues(alpha: 0.2),
                    height: 1,
                  ),
                ),
                _summaryRow(
                  'Total Amount',
                  AppFormatters.formatPrice(total),
                  textColor: textColor,
                  secondaryColor: secondaryColor,
                  isBold: true,
                  valueColor: primaryOrange,
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color:
                  isDark ? primaryOrange.withValues(alpha: 0.13) : lightOrange,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  color: primaryOrange,
                  size: 22,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your order details will be saved securely on this device.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed:
                  selectedAddress != null && selectedPaymentMethod != null
                      ? onPlaceOrder
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryOrange,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade600,
                elevation: 3,
                shadowColor: primaryOrange.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Place Order',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _progressStep('Cart', true),
        _progressLine(),
        _progressStep('Checkout', true),
        _progressLine(),
        _progressStep('Complete', false),
      ],
    );
  }

  Widget _progressStep(String label, bool active) {
    return Column(
      children: [
        Container(
          width: 31,
          height: 31,
          decoration: BoxDecoration(
            color: active ? primaryOrange : Colors.grey.shade400,
            shape: BoxShape.circle,
          ),
          child: Icon(
            active ? Icons.check : Icons.circle_outlined,
            color: Colors.white,
            size: 17,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? darkOrange : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _progressLine() {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: primaryOrange.withValues(alpha: 0.35),
      ),
    );
  }

  Widget _sectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: isDark ? primaryOrange.withValues(alpha: 0.15) : lightOrange,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primaryOrange, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _optionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  isSelected
                      ? primaryOrange.withValues(alpha: 0.55)
                      : isDark
                      ? Colors.white12
                      : Colors.grey.withValues(alpha: 0.15),
              width: isSelected ? 1.3 : 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.025),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? primaryOrange.withValues(alpha: 0.15)
                          : lightOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: primaryOrange, size: 22),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.textTheme.bodyMedium?.color?.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isSelected
                    ? Icons.check_circle
                    : Icons.arrow_forward_ios_rounded,
                color: primaryOrange,
                size: isSelected ? 21 : 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    required Color textColor,
    Color? secondaryColor,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 15 : 13,
            color: isBold ? textColor : secondaryColor,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 13,
            color: valueColor ?? textColor,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

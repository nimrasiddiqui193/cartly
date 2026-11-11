import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';

class CartSummary extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final double discount;
  final VoidCallback? onCheckout;

  const CartSummary({
    super.key,
    required this.subtotal,
    this.shipping = 0,
    this.discount = 0,
    this.onCheckout,
  });

  double get total =>
      (subtotal + shipping - discount).clamp(0, double.infinity).toDouble();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 21, 20, 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.055),
            blurRadius: 18,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                Icon(
                  Icons.receipt_long_outlined,
                  color: colors.primary,
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _SummaryRow(
              label: 'Subtotal',
              value: AppFormatters.formatPrice(subtotal),
            ),
            const SizedBox(height: 13),
            _SummaryRow(
              label: 'Shipping',
              value:
                  shipping == 0 ? 'Free' : AppFormatters.formatPrice(shipping),
              valueColor: shipping == 0 ? Colors.green.shade600 : null,
            ),
            if (discount > 0) ...[
              const SizedBox(height: 13),
              _SummaryRow(
                label: 'Discount',
                value: '-${AppFormatters.formatPrice(discount)}',
                valueColor: Colors.green.shade600,
              ),
            ],
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(),
            ),
            _SummaryRow(
              label: 'Total',
              value: AppFormatters.formatPrice(total),
              isBold: true,
              valueColor: colors.primary,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 53,
              child: ElevatedButton(
                onPressed: onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Proceed to Checkout',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 9),
                    Icon(Icons.arrow_forward_rounded, size: 19),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? null : mutedColor,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            fontSize: isBold ? 15 : 14,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: valueColor,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
              fontSize: isBold ? 18 : 14,
            ),
          ),
        ),
      ],
    );
  }
}

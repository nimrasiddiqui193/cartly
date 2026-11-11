import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/utils/formatters.dart';
import '../../data/models/order_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTrackOrder;
  final VoidCallback? onCancelOrder;

  const OrderDetailsScreen({
    super.key,
    required this.order,
    this.onTrackOrder,
    this.onCancelOrder,
  });

  static const Color primaryBlue = Color(0xFF974305);
  static const Color darkBlue = Color(0xFFE68A45);

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return const Color(0xFF168653);
      case 'shipped':
        return const Color(0xFF1976D2);
      case 'processing':
        return const Color(0xFFB7791F);
      case 'cancelled':
        return const Color(0xFFD14343);
      default:
        return primaryBlue;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Icons.check_circle_rounded;
      case 'shipped':
        return Icons.local_shipping_rounded;
      case 'processing':
        return Icons.sync_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: primaryBlue, size: 21),
          const SizedBox(width: 9),
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(
    String label,
    String value, {
    bool emphasized = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: emphasized ? null : Colors.grey,
                fontWeight: emphasized ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: emphasized ? 15 : 12,
                fontWeight: emphasized ? FontWeight.w800 : FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHeader(BuildContext context) {
    final theme = Theme.of(context);
    final color = _statusColor(order.status);

    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [darkBlue, primaryBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withValues(alpha: 0.18),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Order Status',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_statusIcon(order.status), color: color, size: 14),
                    const SizedBox(width: 5),
                    Text(
                      order.status,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Text(
            'Order #${order.id}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'Placed on ${_formatDate(order.createdAt)}',
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 18),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 15),
          const Text(
            'Total Amount',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 5),
          Text(
            AppFormatters.formatPrice(order.total),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline(BuildContext context) {
    final theme = Theme.of(context);
    final steps = ['Placed', 'Processing', 'Shipped', 'Delivered'];
    final currentStatus = order.status.toLowerCase();
    final isCancelled = currentStatus == 'cancelled';

    int currentIndex;

    switch (currentStatus) {
      case 'processing':
        currentIndex = 1;
        break;
      case 'shipped':
        currentIndex = 2;
        break;
      case 'delivered':
        currentIndex = 3;
        break;
      case 'cancelled':
        currentIndex = -1;
        break;
      default:
        currentIndex = 0;
    }

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Order Tracking', Icons.route_outlined),
            if (isCancelled)
              Row(
                children: [
                  const Icon(Icons.cancel_outlined, color: Color(0xFFD14343)),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'This order has been cancelled.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            else
              ...List.generate(steps.length, (index) {
                final isCompleted = index <= currentIndex;
                final isLast = index == steps.length - 1;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 28,
                        child: Column(
                          children: [
                            Icon(
                              isCompleted
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              color:
                                  isCompleted
                                      ? primaryBlue
                                      : theme.colorScheme.onSurfaceVariant
                                          .withValues(alpha: 0.4),
                              size: 21,
                            ),
                            if (!isLast)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  color:
                                      index < currentIndex
                                          ? primaryBlue
                                          : theme.dividerColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 22),
                          child: Text(
                            steps[index],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  isCompleted
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                              color:
                                  isCompleted
                                      ? null
                                      : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildProducts(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Purchased Products', Icons.shopping_bag_outlined),
            ...order.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: primaryBlue.withValues(alpha: 0.09),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        color: primaryBlue,
                        size: 23,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Quantity: ${item.quantity}',
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppFormatters.formatPrice(item.totalPrice),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAddress(BuildContext context) {
    final theme = Theme.of(context);
    final address = order.shippingAddress;

    final addressLines =
        [
              address['streetAddress'],
              address['city'],
              address['state'],
              address['postalCode'],
              address['country'],
            ]
            .where(
              (value) => value != null && value.toString().trim().isNotEmpty,
            )
            .map((value) => value.toString())
            .toList();

    final fullAddress = addressLines.join(', ');
    final fullName = address['fullName']?.toString() ?? 'N/A';
    final phone = address['phone']?.toString() ?? 'N/A';

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Delivery Address', Icons.location_on_outlined),
            Text(
              fullName,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 7),
            Text(
              fullAddress.isEmpty ? 'No address available' : fullAddress,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const Icon(Icons.phone_outlined, color: primaryBlue, size: 16),
                const SizedBox(width: 7),
                Text(phone, style: const TextStyle(fontSize: 12)),
              ],
            ),
            if ((address['additionalDetails']?.toString() ?? '')
                .trim()
                .isNotEmpty) ...[
              const SizedBox(height: 9),
              Text(
                'Instructions: ${address['additionalDetails']}',
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPayment(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Payment Information', Icons.payment_outlined),
            _detailRow('Payment Method', order.paymentMethod),
            _detailRow('Payment Status', order.paymentStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Price Summary', Icons.receipt_long_outlined),
            _detailRow('Subtotal', AppFormatters.formatPrice(order.subtotal)),
            _detailRow(
              'Shipping Fee',
              AppFormatters.formatPrice(order.shippingFee),
            ),
            _detailRow(
              'Discount',
              '- ${AppFormatters.formatPrice(order.discount)}',
              valueColor: const Color(0xFF168653),
            ),
            const Divider(height: 22),
            _detailRow(
              'Total Amount',
              AppFormatters.formatPrice(order.total),
              emphasized: true,
              valueColor: primaryBlue,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canCancel =
        order.status.toLowerCase() == 'placed' ||
        order.status.toLowerCase() == 'processing';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _buildStatusHeader(context),
          const SizedBox(height: 20),
          _buildTrackingTimeline(context),
          const SizedBox(height: 20),
          _buildProducts(context),
          const SizedBox(height: 20),
          _buildAddress(context),
          const SizedBox(height: 20),
          _buildPayment(context),
          const SizedBox(height: 20),
          _buildPriceSummary(context),
          if (order.notes != null && order.notes!.trim().isNotEmpty) ...[
            const SizedBox(height: 20),
            Card(
              elevation: 1,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
              child: Padding(
                padding: const EdgeInsets.all(17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Order Notes', Icons.notes_outlined),
                    Text(
                      order.notes!,
                      style: const TextStyle(fontSize: 12, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 23),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: onTrackOrder,
              icon: const Icon(Icons.local_shipping_outlined),
              label: const Text(
                'Track Order',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          if (canCancel && onCancelOrder != null) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onCancelOrder,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFD14343),
                side: const BorderSide(color: Color(0xFFD14343)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Cancel Order',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

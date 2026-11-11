import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/utils/formatters.dart';
import '../../data/models/order_model.dart';

class OrdersScreen extends StatelessWidget {
  final List<OrderModel> orders;
  final ValueChanged<OrderModel>? onOrderTap;

  const OrdersScreen({super.key, this.orders = const [], this.onOrderTap});

  static const Color primaryBlue = Color(0xFFE68A45);
  static const Color darkBlue = Color(0xFFB95F2D);

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return const Color(0xFF168653);
      case 'shipped':
        return const Color(0xFF1BF607);
      case 'processing':
        return const Color(0xFFB7791F);
      case 'cancelled':
        return const Color(0xFFD14343);
      case 'placed':
      default:
        return primaryBlue;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Icons.check_circle_outline_rounded;
      case 'shipped':
        return Icons.local_shipping_outlined;
      case 'processing':
        return Icons.sync_rounded;
      case 'cancelled':
        return Icons.cancel_outlined;
      case 'placed':
      default:
        return Icons.receipt_long_outlined;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  Widget _buildStatus(String status) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_statusIcon(status), size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    final theme = Theme.of(context);
    final itemCount = order.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    final productNames = order.items
        .take(2)
        .map((item) => item.product.title)
        .join(', ');

    final remainingItems = order.items.length - 2;

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onOrderTap?.call(order),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: primaryBlue.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: primaryBlue,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.id}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _formatDate(order.createdAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatus(order.status),
                ],
              ),
              const SizedBox(height: 15),
              Divider(
                height: 1,
                color: theme.dividerColor.withValues(alpha: 0.35),
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 17,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              if (productNames.isNotEmpty) ...[
                const SizedBox(height: 7),
                Text(
                  productNames +
                      (remainingItems > 0 ? ' + $remainingItems more' : ''),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    'Order Total',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    AppFormatters.formatPrice(order.total),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 115,
              height: 115,
              decoration: BoxDecoration(
                color: primaryBlue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 57,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 23),
            const Text(
              'No Orders Yet',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 9),
            Text(
              'You haven\'t placed any orders yet. '
              'Your order history will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedOrders = [...orders]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          sortedOrders.isEmpty
              ? _buildEmptyState(context)
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Order History',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: primaryBlue.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${sortedOrders.length} ${sortedOrders.length == 1 ? 'Order' : 'Orders'}',
                            style: const TextStyle(
                              color: primaryBlue,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      itemCount: sortedOrders.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 13),
                      itemBuilder: (context, index) {
                        return _buildOrderCard(context, sortedOrders[index]);
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}

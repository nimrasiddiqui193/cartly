import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final String? selectedMethod;
  final ValueChanged<String>? onPaymentSelected;
  final VoidCallback? onContinue;

  const PaymentScreen({
    super.key,
    this.selectedMethod,
    this.onPaymentSelected,
    this.onContinue,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const Color primaryOrange = Color(0xFFE68A45);
  static const Color darkOrange = Color(0xFFB95F2D);
  static const Color lightOrange = Color(0xFFFFF0E3);

  late String _selectedMethod;

  final List<_PaymentOption> _options = const [
    _PaymentOption(
      title: 'Cash on Delivery',
      subtitle: 'Pay in cash when your order arrives.',
      description: 'No advance payment required.',
      icon: Icons.payments_outlined,
      tag: 'Recommended',
    ),
    _PaymentOption(
      title: 'Credit / Debit Card',
      subtitle: 'Visa, Mastercard and other supported cards.',
      description: 'Card gateway integration is not enabled yet.',
      icon: Icons.credit_card_outlined,
    ),
    _PaymentOption(
      title: 'Mobile Wallet',
      subtitle: 'Pay using a supported mobile wallet.',
      description: 'Wallet integration is not enabled yet.',
      icon: Icons.account_balance_wallet_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.selectedMethod ?? 'Cash on Delivery';
  }

  @override
  void didUpdateWidget(covariant PaymentScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedMethod != oldWidget.selectedMethod &&
        widget.selectedMethod != null) {
      _selectedMethod = widget.selectedMethod!;
    }
  }

  void _selectMethod(String method) {
    setState(() {
      _selectedMethod = method;
    });

    widget.onPaymentSelected?.call(method);
  }

  Widget _paymentCard(_PaymentOption option) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = _selectedMethod == option.title;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color:
              isSelected
                  ? primaryOrange
                  : theme.dividerColor.withValues(alpha: 0.25),
          width: isSelected ? 1.7 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isSelected ? 0.07 : 0.025),
            blurRadius: isSelected ? 12 : 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: () => _selectMethod(option.title),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 49,
                  height: 49,
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? primaryOrange.withValues(alpha: 0.13)
                            : isDark
                            ? const Color(0xFF29231F)
                            : const Color(0xFFFFF9F4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    option.icon,
                    color:
                        isSelected
                            ? primaryOrange
                            : theme.colorScheme.onSurfaceVariant,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              option.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (option.tag != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: primaryOrange.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                option.tag!,
                                style: const TextStyle(
                                  color: darkOrange,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        option.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        option.description,
                        style: TextStyle(
                          fontSize: 10,
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color:
                      isSelected
                          ? primaryOrange
                          : theme.colorScheme.onSurfaceVariant,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Method',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: darkOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [darkOrange, primaryOrange, Color(0xFFF2A96B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: darkOrange.withValues(alpha: 0.18),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Secure Checkout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Choose how you would like to pay for your order.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Choose Payment Method',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Select your preferred payment option.',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 17),
                  ..._options.map(_paymentCard),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? primaryOrange.withValues(alpha: 0.12)
                              : lightOrange,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: primaryOrange,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Card and mobile wallet options are currently '
                            'display-only. No real payment will be processed. '
                            'Cash on Delivery is the available payment option.',
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.5,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 13, 20, 16),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: widget.onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shadowColor: primaryOrange.withValues(alpha: 0.25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 9),
                      Icon(Icons.arrow_forward_rounded, size: 19),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final String? tag;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    this.tag,
  });
}

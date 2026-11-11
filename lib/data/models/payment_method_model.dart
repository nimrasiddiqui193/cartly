enum PaymentMethodType { cashOnDelivery, creditDebitCard }

class PaymentMethodModel {
  final PaymentMethodType type;
  final String title;
  final String description;
  final String iconName;

  const PaymentMethodModel({
    required this.type,
    required this.title,
    required this.description,
    required this.iconName,
  });

  static const List<PaymentMethodModel> availableMethods = [
    PaymentMethodModel(
      type: PaymentMethodType.cashOnDelivery,
      title: 'Cash on Delivery',
      description: 'Pay when your order arrives',
      iconName: 'payments',
    ),
    PaymentMethodModel(
      type: PaymentMethodType.creditDebitCard,
      title: 'Credit / Debit Card',
      description: 'Demo payment option',
      iconName: 'credit_card',
    ),
  ];

  String get value {
    switch (type) {
      case PaymentMethodType.cashOnDelivery:
        return 'Cash on Delivery';
      case PaymentMethodType.creditDebitCard:
        return 'Credit / Debit Card';
    }
  }

  static PaymentMethodType fromValue(String value) {
    switch (value) {
      case 'Credit / Debit Card':
        return PaymentMethodType.creditDebitCard;
      case 'Cash on Delivery':
      default:
        return PaymentMethodType.cashOnDelivery;
    }
  }
}

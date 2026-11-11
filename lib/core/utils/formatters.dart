import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

class AppFormatters {
  AppFormatters._();

  // Approximate USD to PKR exchange rate.
  // Update this value when the exchange rate changes.
  static const double usdToPkrRate = 277.05;

  // Converts an API price from USD to PKR.
  static double convertUsdToPkr(num amount) {
    return amount * usdToPkrRate;
  }

  // Currency formatting with two decimal places.
  // Product API prices are supplied in USD.
  static String currency(num amount) {
    final convertedAmount = convertUsdToPkr(amount);
    final formatter = NumberFormat('#,##0.00', 'en_US');

    return '${AppConstants.currencySymbol} ${formatter.format(convertedAmount)}';
  }

  // Backward compatibility for existing screens and widgets.
  static String formatPrice(num amount) {
    return currency(amount);
  }

  // Currency formatting without decimal places.
  static String wholeCurrency(num amount) {
    final convertedAmount = convertUsdToPkr(amount);
    final formatter = NumberFormat('#,##0', 'en_US');

    return '${AppConstants.currencySymbol} ${formatter.format(convertedAmount)}';
  }

  // Compact currency formatting.
  static String compactCurrency(num amount) {
    final convertedAmount = convertUsdToPkr(amount);
    final formatter = NumberFormat.compact(locale: 'en_US');

    return '${AppConstants.currencySymbol} ${formatter.format(convertedAmount)}';
  }

  // Number formatting.
  static String number(num value) {
    return NumberFormat('#,##0.##', 'en_US').format(value);
  }

  // Percentage formatting.
  static String percentage(num value) {
    return '${value.toStringAsFixed(0)}%';
  }

  // Date formatting.
  static String date(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String shortDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String dateWithWeekday(DateTime date) {
    return DateFormat('EEE, dd MMM yyyy').format(date);
  }

  // Time formatting.
  static String time(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  // Date and time formatting.
  static String dateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  // Relative date formatting.
  static String relativeDate(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    final difference = target.difference(today).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';

    return thisDate(date);
  }

  static String thisDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  // Order ID formatting.
  static String orderId(String id) {
    if (id.length <= 8) {
      return id.toUpperCase();
    }

    return id.substring(0, 8).toUpperCase();
  }

  // Capitalizes the first character.
  static String capitalize(String value) {
    if (value.trim().isEmpty) return value;

    final text = value.trim();

    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  // Capitalizes every word.
  static String capitalizeWords(String value) {
    if (value.trim().isEmpty) return value;

    return value.trim().split(RegExp(r'\s+')).map(capitalize).join(' ');
  }

  // Truncates long text.
  static String truncate(String value, {int maxLength = 40}) {
    if (value.length <= maxLength) {
      return value;
    }

    if (maxLength <= 3) {
      return value.substring(0, maxLength);
    }

    return '${value.substring(0, maxLength - 3)}...';
  }

  // Quantity formatting.
  static String quantity(int value) {
    return value.toString();
  }
}

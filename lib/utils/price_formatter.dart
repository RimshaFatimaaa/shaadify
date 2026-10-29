import 'package:intl/intl.dart';

class PriceFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: 'Rs. ',
    decimalDigits: 0,
    locale: 'en_PK',
  );

  static String format(double price) {
    if (price >= 100000) {
      // Format in Lakhs
      double lakhs = price / 100000;
      return 'Rs. ${lakhs.toStringAsFixed(1)} Lakh';
    } else if (price >= 1000) {
      // Format in Thousands
      double thousands = price / 1000;
      return 'Rs. ${thousands.toStringAsFixed(0)}K';
    } else {
      return _currencyFormat.format(price);
    }
  }

  static String formatCompact(double price) {
    if (price >= 10000000) {
      // Crores
      double crores = price / 10000000;
      return 'Rs. ${crores.toStringAsFixed(1)} Cr';
    } else if (price >= 100000) {
      // Lakhs
      double lakhs = price / 100000;
      return 'Rs. ${lakhs.toStringAsFixed(1)} L';
    } else if (price >= 1000) {
      // Thousands
      double thousands = price / 1000;
      return 'Rs. ${thousands.toStringAsFixed(0)}K';
    } else {
      return 'Rs. ${price.toStringAsFixed(0)}';
    }
  }
}


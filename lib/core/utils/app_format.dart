import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Locale-aware number formatting. Arabic uses `ar_EG`, which renders
/// Arabic-Indic digits (٠١٢٣…) and the Arabic decimal separator.
class AppFormat {
  AppFormat(this.languageCode) : _numberLocale = languageCode == 'ar' ? 'ar_EG' : 'en';

  factory AppFormat.of(BuildContext context) =>
      AppFormat(Localizations.localeOf(context).languageCode);

  final String languageCode;
  final String _numberLocale;

  bool get isArabic => languageCode == 'ar';

  String integer(num value) =>
      NumberFormat.decimalPattern(_numberLocale).format(value.round());

  String decimal(num value, {int digits = 1}) {
    final format = NumberFormat.decimalPattern(_numberLocale)
      ..minimumFractionDigits = digits
      ..maximumFractionDigits = digits;
    return format.format(value);
  }

  /// Fewer decimals as the number grows: 0.42 · 4.2 · 42 · 420.
  String flexible(num value) {
    final size = value.abs();
    final digits = size >= 100 ? 0 : (size >= 10 ? 1 : 2);
    return decimal(value, digits: digits);
  }

  String percent(int value) =>
      NumberFormat.percentPattern(_numberLocale).format(value / 100);

  /// Five decimals; always shown inside an LTR [Directionality].
  String coordinate(double value) => decimal(value, digits: 5);

  String month(int month) => DateFormat.MMM(languageCode).format(DateTime(2024, month));
}

import 'package:intl/intl.dart';

abstract final class AppFormatters {
  static final DateFormat shortDate = DateFormat('yyyy-MM-dd');
  static final DateFormat fullDateTime = DateFormat('yyyy-MM-dd HH:mm');
  static final DateFormat displayDate = DateFormat('d MMM yyyy');
  static final NumberFormat currency = NumberFormat.currency(symbol: '\$');
  static final NumberFormat compact = NumberFormat.compact();

  static String formatDate(DateTime date) => shortDate.format(date);
  static String formatDateTime(DateTime date) => fullDateTime.format(date);
  static String formatDisplayDate(DateTime date) => displayDate.format(date);
  static String formatCurrency(num amount) => currency.format(amount);
  static String formatCompact(num amount) => compact.format(amount);
}

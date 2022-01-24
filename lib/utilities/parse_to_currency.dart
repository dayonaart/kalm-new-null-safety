import 'package:intl/intl.dart';

String CURRENCY(dynamic number) {
  try {
    return NumberFormat("#,##0").format(number);
  } catch (e) {
    return "";
  }
}

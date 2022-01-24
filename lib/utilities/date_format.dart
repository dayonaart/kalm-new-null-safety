import 'dart:async';

import 'package:intl/intl.dart';

String? DATE_FORMAT(DateTime? dateTime, {String? addPattern, String? pattern}) {
  try {
    if (addPattern != null) {
      return DateFormat(pattern ?? "MMMM dd y")
          .addPattern(addPattern)
          .format(dateTime!);
    } else {
      return DateFormat(pattern ?? "MMMM dd y").format(dateTime!);
    }
  } catch (e) {
    return dateTime?.toIso8601String();
  }
}

String? get defaultLocale {
  var zoneLocale = Zone.current[#Intl.locale] as String?;
  return zoneLocale ?? 'id';
}

double? VALIDATE_DOB_MATURE(DateTime? dob) {
  if (dob == null) {
    return null;
  }
  var _today = DateTime.now();
  return (_today.difference(dob).inDays / 365.25);
}

String DURATION_FORMAT(Duration d) =>
    d.toString().split(".").first.padLeft(8, "0");

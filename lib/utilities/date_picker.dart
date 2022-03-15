import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/widget/date_picker.dart';
import 'package:kalm/widget/text.dart';

Future<DateTime?> DATE_PICKER({
  DateTime? initialDateTime,
  bool showUserAge = true,
}) async {
  DatePickerController _now = DatePickerController(
      initialDateTime: initialDateTime ?? DateTime.now(),
      minYear: 1900,
      maxYear: DateTime.now().year);
  DateTime? _dateTime;
  await Get.bottomSheet<bool>(
    DatePicker(
      showUserAge: showUserAge,
      onSubmit: (d) {
        _dateTime = d;
        Get.back();
      },
      title: "Pilih Tanggal",
      height: Get.height / 3,
      controller: _now,
      locale: DatePickerLocale.id_ID,
      pickerDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: BLUEKALM, width: 2.0)),
      config: DatePickerConfig(
          isLoop: false, selectedTextStyle: COSTUM_TEXT_STYLE()),
      onChanged: (date) {
        _dateTime = date;
      },
    ),
  );
  return _dateTime;
}

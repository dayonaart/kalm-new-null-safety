import 'package:flutter/material.dart';
import 'package:kalm/color/colors.dart';
import 'package:get/get.dart';

Container BOX_BORDER(
  Widget child, {
  double? circularRadius,
  Color? fillColor,
}) {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
        color: fillColor,
        border: Border.all(width: 0.5, color: BLUEKALM),
        borderRadius: BorderRadius.circular(circularRadius ?? 10)),
    child: child,
  );
}

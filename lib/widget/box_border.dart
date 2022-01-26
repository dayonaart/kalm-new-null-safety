import 'package:flutter/material.dart';
import 'package:kalm/color/colors.dart';
import 'package:get/get.dart';

Container BOX_BORDER(
  Widget child, {
  double? circularRadius,
  Color? fillColor,
  DecorationImage? decorationImage,
  double? height,
  double? width,
}) {
  return Container(
    width: width ?? Get.width,
    height: height,
    decoration: BoxDecoration(
        image: decorationImage,
        color: fillColor,
        border: Border.all(width: 0.5, color: BLUEKALM),
        borderRadius: BorderRadius.circular(circularRadius ?? 10)),
    child: child,
  );
}

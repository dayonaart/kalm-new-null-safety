import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/color/colors.dart';

Text TEXT(
  String? content, {
  TextStyle? style,
  TextAlign? textAlign,
  TextOverflow? textOverflow,
}) {
  return Text(
    content ?? "not found",
    style: style ?? Get.textTheme.bodyText1,
    textAlign: textAlign ?? TextAlign.start,
    overflow: textOverflow,
  );
}

TextStyle URL_STYLE() {
  return TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.blue[300],
    fontFamily: "fonts/AlexBrush-Regular.ttf",
  );
}

TextStyle COSTUM_TEXT_STYLE({
  Color? color,
  FontWeight? fontWeight,
  double? fonstSize,
  FontStyle? fontStyle,
  Color? backColor,
  TextDecoration? decoration,
}) {
  return TextStyle(
    decoration: decoration,
    backgroundColor: backColor,
    fontSize: fonstSize ?? 16,
    fontStyle: fontStyle,
    fontWeight: fontWeight ?? FontWeight.normal,
    color: color ?? BLUEKALM,
    fontFamily: "fonts/AlexBrush-Regular.ttf",
  );
}

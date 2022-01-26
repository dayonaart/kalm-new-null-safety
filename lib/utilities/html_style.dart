import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

Html HTML_VIEW(
  String? data, {
  double? fontSize,
  double? wordSpace,
  Color? textColor,
  FontWeight? fontWeight,
}) {
  return Html(
    onLinkTap: (l, c, e, r) async {
      if (await canLaunch(l!)) {
        await launch(l);
      } else {
        ERROR_SNACK_BAR("Perhatian", "Tidak dapat membuka link");
        return;
      }
    },
    data: data,
    style: HTML_STYLE(
        fontSize: fontSize,
        wordSpace: wordSpace,
        fontWeight: fontWeight,
        textColor: textColor),
  );
}

Map<String, Style> HTML_STYLE({
  double? fontSize,
  double? wordSpace,
  Color? textColor,
  FontWeight? fontWeight,
}) {
  return {
    "p": Style(
        // width: Get.width,
        wordSpacing: wordSpace ?? 4,
        fontFamily: "fonts/AlexBrush-Regular.ttf",
        fontSize: FontSize(fontSize ?? 14),
        color: textColor ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.normal),
    "li": Style(
        // width: Get.width,
        wordSpacing: wordSpace ?? 4,
        fontFamily: "fonts/AlexBrush-Regular.ttf",
        fontSize: FontSize(fontSize ?? 14),
        color: textColor ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.normal)
  };
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/color/colors.dart';

void ERROR_SNACK_BAR(String? title, String? message) {
  Get.rawSnackbar(
      message: message,
      title: title,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red[300]!,
      isDismissible: true,
      duration: const Duration(seconds: 2));
}

void SUCCESS_SNACK_BAR(String? title, String? message) {
  Get.rawSnackbar(
      message: message,
      title: title,
      snackPosition: SnackPosition.TOP,
      backgroundColor: GREENKALM,
      isDismissible: true,
      duration: const Duration(seconds: 4));
}

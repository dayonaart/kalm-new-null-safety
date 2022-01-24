import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/widget/safe_area.dart';

class PincodePage extends StatelessWidget {
  final _controller = Get.put(PincodeController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PincodeController>(builder: (_) {
      return SAFE_AREA();
    });
  }
}

class PincodeController extends GetxController {}

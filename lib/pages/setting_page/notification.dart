import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/widget/safe_area.dart';

class NotificationPage extends StatelessWidget {
  final _controller = Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(builder: (_) {
      return SAFE_AREA();
    });
  }
}

class NotificationController extends GetxController {}

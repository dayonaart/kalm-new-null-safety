import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/utilities/html_style.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class HowToUsePage extends StatelessWidget {
  final _controller = Get.put(HowToUseController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HowToUseController>(builder: (_) {
      return SAFE_AREA(
          child: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SPACE(),
              TEXT(PRO.howToResModel?.howToData?.name,
                  style: Get.textTheme.headline2),
              SPACE(),
              HTML_VIEW(PRO.howToResModel?.howToData?.description, wordSpace: 0)
            ],
          ),
        )
      ]));
    });
  }
}

class HowToUseController extends GetxController {}

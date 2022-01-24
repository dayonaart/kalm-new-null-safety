import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/utilities/html_style.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class TermAndConditionPage extends StatelessWidget {
  final _controller = Get.put(TermAndConditionController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TermAndConditionController>(builder: (_) {
      return SAFE_AREA(
          child: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SPACE(),
              TEXT(PRO.termAndConditionResModel?.howToData?.name,
                  style: Get.textTheme.headline2),
              SPACE(),
              HTML_VIEW(PRO.termAndConditionResModel?.howToData?.description,
                  wordSpace: 0)
            ],
          ),
        )
      ]));
    });
  }
}

class TermAndConditionController extends GetxController {}

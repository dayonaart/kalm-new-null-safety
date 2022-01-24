import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/utilities/html_style.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final _controller = Get.put(PrivacyPolicyController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrivacyPolicyController>(builder: (_) {
      return SAFE_AREA(
          child: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SPACE(),
              TEXT(PRO.privacyPolicyResModel?.howToData?.name,
                  style: Get.textTheme.headline2),
              SPACE(),
              HTML_VIEW(PRO.privacyPolicyResModel?.howToData?.description,
                  wordSpace: 0)
            ],
          ),
        )
      ]));
    });
  }
}

class PrivacyPolicyController extends GetxController {}

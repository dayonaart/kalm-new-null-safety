import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/about_res_model/about_data.dart';
import 'package:kalm/utilities/html_style.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/social_share.dart';
import 'package:kalm/widget/text.dart';

class AboutUsPage extends StatelessWidget {
  final _controller = Get.put(AboutUsController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AboutUsController>(builder: (_) {
      return SAFE_AREA(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                TEXT(_.data()?.name, style: Get.textTheme.headline2),
                HTML_VIEW(_.data()?.description),
                SOCIAL_SHARE()
              ],
            ),
          )
        ],
      ));
    });
  }
}

class AboutUsController extends GetxController {
  AboutData? data() {
    return PRO.aboutResModel?.aboutData;
  }
}

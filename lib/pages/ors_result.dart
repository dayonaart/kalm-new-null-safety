import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/ors_res_model/ors_res_model.dart';
import 'package:kalm/pages/auth/login.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class OrsResultPage extends StatelessWidget {
  int result;
  OrsResultPage({this.result = 0});
  final _controller = Get.put(OrsResultController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrsResultController>(builder: (_) {
      return SAFE_AREA(
          canBack: PRO.userData != null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset(_.orsResultImage(result), scale: 3),
                    SPACE(),
                    TEXT(_.resultModel(result).title,
                        textAlign: TextAlign.center,
                        style: COSTUM_TEXT_STYLE(
                            fonstSize: _.resultModel(result).titleSize,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  height: Get.height / 3,
                  child: SingleChildScrollView(
                    child: TEXT("${_.resultModel(result).desc}",
                        style: COSTUM_TEXT_STYLE(
                            fonstSize: _.resultModel(0).descSize)),
                  ),
                ),
                Column(
                  children: [
                    TEXT("What would you like to do now?"),
                    SPACE(),
                    GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 40,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                      children: List.generate(_.buttonTitle.length, (i) {
                        return BUTTON(_.buttonTitle[i],
                            titleStyle: COSTUM_TEXT_STYLE(
                                fonstSize: 12, color: Colors.white),
                            onPressed: () => _.ontap(i, context),
                            backgroundColor: _.buttonColor[i]);
                      }),
                    )
                  ],
                )
              ],
            ),
          ));
    });
  }
}

class OrsResultController extends GetxController {
  List<String> buttonTitle = [
    'Chat with a Kalmselor',
    'SelfKALM Audio',
    'Gratitude Journal',
    'Learn About Wellbeing'
  ];
  String orsResultImage(int result) {
    switch (result) {
      case 0:
        return "assets/image/ors1.png";
      default:
        return "assets/image/ors1.png";
    }
  }

  OrsResultModel resultModel(int result) {
    return PRO.orsResultModel![result];
  }

  List<Color> buttonColor = [
    ORANGEKALM,
    const Color(0xFFE6B363),
    const Color(0xFFB0BB90),
    BLUEKALM
  ];
  void ontap(int i, BuildContext context) {
    if (PRO.userData == null) {
      Get.offAll(LoginPage());
      return;
    } else {
      switch (i) {
        case 0:
          PRO.updateInitialIndexTab(2);
          break;
        case 1:
          PRO.updateInitialIndexTab(3);
          break;
        case 2:
          PRO.updateInitialIndexTab(1);
          break;
        case 3:
          Navigator.pop(context);
          break;
        default:
      }
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/user_model/user_model.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/social_share.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class ContactUsPage extends StatelessWidget {
  final _controller = Get.put(ContactUsController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContactUsController>(builder: (_) {
      return SAFE_AREA(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                TEXT("Hubungi Kami", style: Get.textTheme.headline2),
                Html(
                  shrinkWrap: true,
                  data: PRO.contactUsResModel?.contactUsData?.description,
                  style: {
                    "p": Style(
                        wordSpacing: 4,
                        fontFamily: "fonts/AlexBrush-Regular.ttf",
                        fontSize: const FontSize(16),
                        color: Colors.black,
                        fontWeight: FontWeight.normal)
                  },
                ),
                CupertinoTextField(
                  focusNode: _.fieldFocus,
                  controller: _.fieldController,
                  onChanged: (val) => _.onchangeField(val),
                  placeholder: "Masukan isi pesanmu ( minimal 10 karakter )",
                  minLines: 8,
                  maxLines: 8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 0.5, color: BLUEKALM)),
                ),
                SPACE(height: 20),
                BUTTON("Kirim",
                    onPressed:
                        _.validationField ? () async => await _.submit() : null,
                    verticalPad: 12,
                    circularRadius: 30),
                SPACE(height: 20),
                SOCIAL_SHARE()
              ],
            ),
          )
        ],
      ));
    });
  }
}

class ContactUsController extends GetxController {
  TextEditingController fieldController = TextEditingController();
  FocusNode fieldFocus = FocusNode();

  bool validationField = false;
  void onchangeField(String val) {
    if (val.length >= 10) {
      validationField = true;
    } else {
      validationField = false;
    }
    update();
  }

  Future<void> submit() async {
    var _res = await Api().POST(
        SETTING_CONTACT, {"message": fieldController.text},
        useToken: true);
    if (_res?.statusCode == 200) {
      fieldController.clear();
      fieldFocus.unfocus();
      await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
    } else {
      return;
    }
  }
}

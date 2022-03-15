import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/user_model/user_model.dart';
import 'package:kalm/widget/box_border.dart';
import 'package:kalm/widget/loading.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class NotificationPage extends StatelessWidget {
  final _controller = Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    // print(PRO.userData?.userNotificationSetting?.toJson());
    return GetBuilder<NotificationController>(builder: (_) {
      return SAFE_AREA(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SPACE(height: 20),
              _options("Email Saya", "Ketika Kalmselor Mengirimi saya pesan",
                  _.emailController(context)),
              SPACE(height: 20),
              _options("Push Notification", "Ketika Kalmselor Mengirimi saya pesan", false),
            ],
          ),
        ),
      ));
    });
  }

  Column _options(String title, String content, bool isActive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TEXT(title, style: Get.textTheme.headline1),
        SPACE(),
        InkWell(
          onTap: () async => await _controller.onChange(title == "Email Saya"),
          child: BOX_BORDER(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  BOX_BORDER(
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Card(
                          color: isActive ? ORANGEKALM : Colors.white,
                          margin: const EdgeInsets.all(0),
                        ),
                      ),
                      height: 20,
                      width: 20,
                      circularRadius: 2),
                  SPACE(),
                  TEXT(content)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NotificationController extends GetxController {
  bool emailController(BuildContext context) {
    try {
      return STATE(context).userData?.userNotificationSetting?.emailClientSendMessage == 1;
    } catch (e) {
      return false;
    }
  }

  Future<void> onChange(bool isEmail) async {
    if (isEmail) {
      bool isActive = PRO.userData?.userNotificationSetting?.emailClientSendMessage == 1;
      var _res =
          await Api().POST(EMAIL_NOTIFICATION_SETTING, {'value': isActive ? 0 : 1}, useToken: true);
      if (_res?.statusCode == 200) {
        await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
        Loading.hide();
      } else {
        Loading.hide();
        return;
      }
    } else {}
  }
}

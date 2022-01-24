import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/main.dart';
import 'package:kalm/main_tab.dart';
import 'package:kalm/tab_pages/home_page.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/safe_area.dart';

class NoConnectionPage extends StatelessWidget {
  final _controller = Get.put(NoConnectionController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NoConnectionController>(
        dispose: (ds) {},
        initState: (st) async {},
        builder: (_) {
          return NON_MAIN_SAFE_AREA(
              child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wifi_off_outlined,
                  size: 100,
                  color: BLUEKALM,
                ),
                SizedBox(
                  width: Get.width / 1.5,
                  child: BUTTON("Coba Lagi", onPressed: () async {
                    await PRO.updateSession();
                    await pushRemoveUntilScreen(context,
                        screen: KalmMainTab(), withNavBar: true);
                  }),
                )
              ],
            ),
          ));
        });
  }
}

class NoConnectionController extends GetxController {
  Connectivity connectivity = Connectivity();
}

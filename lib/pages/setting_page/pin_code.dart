import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/main.dart';
import 'package:kalm/pages/auth/login.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'package:kalm/widget/virtual_numpad.dart';

class PincodePage extends StatelessWidget {
  String? createCode;
  bool isLock;
  PincodePage({this.createCode, this.isLock = false});
  final _controller = Get.put(PincodeController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isLock) {
          exit(0);
        } else {
          return Future.value(true);
        }
      },
      child: GetBuilder<PincodeController>(dispose: (d) {
        _controller.createCode = null;
      }, builder: (_) {
        return SAFE_AREA(
            useAppBar: !isLock,
            canBack: !isLock,
            child: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    children: [
                      isLock
                          ? Column(
                              children: [
                                const SizedBox(height: 20),
                                TEXT('Enter Your Pin',
                                    style: Get.textTheme.headline1)
                              ],
                            )
                          : TEXT(
                              createCode != null
                                  ? 'Konfirmasi kode untuk melanjutkan'
                                  : "Masukan kode untuk melanjutkan",
                              style: Get.textTheme.headline1),
                      SPACE(height: 20),
                      _createCodeBox(),
                      SPACE(height: 20),
                      SizedBox(
                          width: Get.width / 1.8,
                          child: BUTTON(
                              createCode != null ? "Konfirmasi" : "Lanjutkan",
                              onPressed: _.validationCode
                                  ? () async => await _.checkingCode(context,
                                      confirmCode: createCode, isLock: isLock)
                                  : null,
                              verticalPad: 10,
                              circularRadius: 30)),
                      SPACE(height: 20),
                      VirtualNumpad(
                          seletedNum: (n) => _.onChangeCreateCode(n),
                          textColor: ORANGEKALM)
                    ],
                  ),
                )
              ],
            ));
      }),
    );
  }

  Row _createCodeBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
          createCode?.length ?? _controller.createCodeList.length, (i) {
        return Container(
          height: Get.height / 10,
          width: Get.width / 5,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: BLUEKALM),
              shape: BoxShape.rectangle),
          child: Center(
              child: TEXT(_controller.createCodeList[i] ?? "",
                  style: COSTUM_TEXT_STYLE(
                      fonstSize: 40,
                      fontWeight: FontWeight.bold,
                      color: ORANGEKALM))),
        );
      }),
    );
  }
}

class PincodeController extends GetxController {
  bool get validationCode => !createCodeList.contains(null);

  List<int> tryPassword = [];
  Future<void> checkingCode(BuildContext context,
      {String? confirmCode, bool isLock = false}) async {
    if (confirmCode != null && !isLock) {
      if (createCode == confirmCode) {
        await PRO.savePinCode(confirmCode);
        Navigator.pop(context);
        SUCCESS_SNACK_BAR("Perhatian", 'Pin Berhasil dibuat');
      } else {
        ERROR_SNACK_BAR("Perhatian", 'Kode tidak sama');
        return;
      }
    } else if (isLock) {
      if (createCode == confirmCode) {
        await STARTING(isLock: false);
      } else {
        tryPassword.add(0);

        if (tryPassword.length > 3) {
          await PRO.clearAllData();
          Get.offAll(LoginPage());
        } else {
          ERROR_SNACK_BAR("Perhatian",
              'Pin Salah\nAnda masih memiliki ${(4 - tryPassword.length)} kesempatan');
        }
        return;
      }
    } else {
      pushReplacementNewScreen(context,
          screen: PincodePage(createCode: createCode));
      createCode = null;
    }
  }

  String? createCode;
  void onChangeCreateCode(String val) {
    createCode = val;
    update();
  }

  List<String?> get createCodeList => List.generate(4, (i) {
        try {
          return createCode![i];
        } catch (e) {
          return null;
        }
      });
}

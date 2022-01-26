import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'package:kalm/widget/virtual_numpad.dart';

class PincodePage extends StatelessWidget {
  final _controller = Get.put(PincodeController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PincodeController>(dispose: (d) {
      _controller.finalConfirmCode = null;
      _controller.finalCreateCode = null;
      _controller.createCode = null;
      _controller.confirmCode = null;
    }, builder: (_) {
      return SAFE_AREA(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                TEXT(
                    _.finalCreateCode != null
                        ? 'Konfirmasi kode untuk melanjutkan'
                        : "Masukan kode untuk melanjutkan",
                    style: Get.textTheme.headline1),
                SPACE(height: 20),
                _createCodeBox(),
                _confirmCodeBox(),
                SPACE(height: 20),
                SizedBox(
                    width: Get.width / 1.8,
                    child: BUTTON(_.finalCreateCode != null ? "Konfirmasi" : "Lanjutkan",
                        onPressed: () => _.checkingCode(), verticalPad: 10, circularRadius: 30)),
                SPACE(height: 20),
                if (_.finalCreateCode == null) _.field1 else _.field2
              ],
            ),
          )
        ],
      ));
    });
  }

  Row _createCodeBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_controller.createCodeList.length, (i) {
        return Container(
          height: Get.height / 10,
          width: Get.width / 5,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: BLUEKALM), shape: BoxShape.rectangle),
          child: Center(
              child: TEXT(_controller.createCodeList[i] ?? "",
                  style: COSTUM_TEXT_STYLE(
                      fonstSize: 40, fontWeight: FontWeight.bold, color: ORANGEKALM))),
        );
      }),
    );
  }

  Row _confirmCodeBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_controller.confirmCodeList.length, (i) {
        return Container(
          height: Get.height / 10,
          width: Get.width / 5,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: BLUEKALM), shape: BoxShape.rectangle),
          child: Center(
              child: TEXT(_controller.confirmCodeList[i] ?? "",
                  style: COSTUM_TEXT_STYLE(
                      fonstSize: 40, fontWeight: FontWeight.bold, color: ORANGEKALM))),
        );
      }),
    );
  }
}

class PincodeController extends GetxController {
  bool get validationCode =>
      (!createCodeList.contains(null) && finalConfirmCode == null) ||
      (!confirmCodeList.contains("") && finalConfirmCode != null);
  String? finalCreateCode;
  String? finalConfirmCode;

  VirtualNumpad get field2 =>
      VirtualNumpad(seletedNum: (v) => onChangeConfirmCode(v), textColor: BLUEKALM);
  VirtualNumpad get field1 =>
      VirtualNumpad(seletedNum: (n) => onChangeCreateCode(n), textColor: ORANGEKALM);
  void checkingCode() {
    finalCreateCode = createCode;
    finalConfirmCode = confirmCode;
    update();
    print('$finalCreateCode : $finalConfirmCode');
    // if (finalConfirmCode != null) {
    //   if (finalConfirmCode == finalCreateCode) {
    //     Get.back();
    //   } else {
    //     ERROR_SNACK_BAR("Perhatian", 'Kode tidak sama');
    //     return;
    //   }
    // }
  }

  String? createCode;
  void onChangeCreateCode(String val) {
    print("ONCREATE");
    createCode = val;
    update();
  }

  String? confirmCode;
  void onChangeConfirmCode(String val) {
    print("ONCONFIRM $val");
    if (val.isEmpty) {
      val == "";
    }
    confirmCode = val;
    update();
  }

  List<String?> get createCodeList => List.generate(4, (i) {
        try {
          return createCode![i];
        } catch (e) {
          return null;
        }
      });

  List<String?> get confirmCodeList => List.generate(4, (i) {
        try {
          return confirmCode![i];
        } catch (e) {
          return null;
        }
      });
}

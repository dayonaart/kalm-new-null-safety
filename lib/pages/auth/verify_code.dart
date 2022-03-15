import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/main_tab.dart';
import 'package:kalm/model/user_model/user_model.dart';
import 'package:kalm/pages/auth/login.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/dialog.dart';
import 'package:kalm/widget/loading.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'package:kalm/widget/virtual_numpad.dart';

class VerifyCodePage extends StatelessWidget {
  bool resendCode;
  VerifyCodePage({this.resendCode = false});
  final _controller = Get.put(VerifyCodeController());
  @override
  Widget build(BuildContext context) {
    print(PRO.userData?.activationCode);
    return GetBuilder<VerifyCodeController>(initState: (st) async {
      if (resendCode) {
        await _controller.resendCode(PRO.userData!.email!);
      } else {
        _controller.restartCoundownResend();
      }
    }, builder: (_) {
      return NON_MAIN_SAFE_AREA(
          bottomPadding: 0,
          appBar: PreferredSize(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          SHOW_DIALOG(
                              "Apakah Anda yakin ingin keluar dari verifikasi kode?",
                              onAcc: () async {
                            // await PRO.clearAllData();
                            await Get.offAll(LoginPage());
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: BLUEKALM,
                        )),
                  ],
                ),
              ),
              preferredSize: Size(Get.width, 50)),
          child: POP_SCREEN_DIALOG(
            onConfirm: () async {
              await PRO.clearAllData();
              await Get.offAll(LoginPage());
            },
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/wave/wave.png"),
                      alignment: Alignment.bottomCenter)),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Column(
                      children: [
                        TEXT("KODE VERIFiKASI", style: Get.textTheme.headline2),
                        SPACE(),
                        TEXT("Kami telah mengirimkan kode verifikasi ke"),
                        TEXT(
                            resendCode
                                ? PRO.userData?.email
                                : PRO.registerPayload?.email,
                            style: COSTUM_TEXT_STYLE(
                                color: ORANGEKALM,
                                fontWeight: FontWeight.w600)),
                        SPACE(),
                        TEXT("Masukan kode untuk melanjutkan"),
                        SPACE(),
                        _codeBox(),
                        SPACE(height: 20),
                        SizedBox(
                            width: Get.width / 1.8,
                            child: BUTTON("Submit",
                                onPressed: _.validationCode
                                    ? () async => await _.submit()
                                    : null,
                                verticalPad: 10,
                                circularRadius: 30)),
                        SPACE(height: 20),
                        _resendCode(_),
                        SPACE(height: 20),
                        VirtualNumpad(seletedNum: (n) => _.onChangeCode(n)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ));
    });
  }

  Row _codeBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_controller.codeList().length, (i) {
        return Container(
          height: Get.height / 10,
          width: Get.width / 5,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: BLUEKALM),
              shape: BoxShape.rectangle),
          child: Center(
              child: TEXT(_controller.codeList()[i],
                  style: COSTUM_TEXT_STYLE(
                      fonstSize: 40,
                      fontWeight: FontWeight.bold,
                      color: ORANGEKALM))),
        );
      }),
    );
  }

  StreamBuilder<String> _resendCode(VerifyCodeController _) {
    return StreamBuilder<String>(
        stream: _.coundownResend,
        builder: (context, snap) {
          if (snap.hasData) {
            return Column(
              children: [
                if (int.tryParse(snap.data!) != 0)
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: BLUEKALM),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TEXT(snap.data ?? "",
                          style: COSTUM_TEXT_STYLE(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                SPACE(),
                if (int.tryParse(snap.data!) == 0)
                  InkWell(
                      onTap: () async =>
                          await _.resendCode(PRO.userData!.email!),
                      child: TEXT("Kirim Ulang Kode")),
              ],
            );
          } else {
            return Container();
          }
        });
  }
}

class VerifyCodeController extends GetxController {
  bool get validationCode => !codeList().contains("");

  String code = "";
  void onChangeCode(String val) {
    code = val;
    update();
  }

  List<String> codeList() {
    return List.generate(4, (i) {
      try {
        return code[i];
      } catch (e) {
        return "";
      }
    });
  }

  Stream<String>? coundownResend;
  int countDownMax = 59;
  void restartCoundownResend() {
    coundownResend = Stream<String>.periodic(const Duration(seconds: 1), (x) {
      if (countDownMax > 8) {
        return "${countDownMax - x}";
      } else {
        return "0${countDownMax - x}";
      }
    }).take(60);
    update();
  }

  Future<void> resendCode(String email) async {
    var _res = await Api().POST(RESEND_CODE, {"email": email, "role": "10"});
    if (_res?.statusCode == 200) {
      await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
      restartCoundownResend();
      Loading.hide();
      SUCCESS_SNACK_BAR(_res?.message,
          "Kode verifikasi berhasil dikirimkan ke email $email}");
    } else {
      Loading.hide();
      return;
    }
  }

  Future<void> submit() async {
    var _payload = {
      "email": PRO.userData?.email,
      "activation_code": codeList().map((e) => e).join(",").replaceAll(",", ""),
      "role": "10"
    };
    var _res = await Api().POST(ACTIVATION_CODE, _payload);
    var _user = UserModel.fromJson(_res?.data);
    if (_res?.statusCode == 200) {
      await PRO.saveLocalUser(_user.data);
      Loading.hide();
      await Get.offAll(KalmMainTab());
    } else if (_user.message == "Your account already confirmed") {
      await PRO.updateSession();
      Loading.hide();
      await Get.offAll(KalmMainTab());
    } else {
      Loading.hide();
      return;
    }
  }
}

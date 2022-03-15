import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_identifier/flutter_device_identifier.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/main_tab.dart';
import 'package:kalm/model/login_payload.dart';
import 'package:kalm/model/ors_payload/ors_payload.dart';
import 'package:kalm/model/ors_payload/ors_value.dart';
import 'package:kalm/model/user_model/user_data.dart';
import 'package:kalm/model/user_model/user_model.dart';
import 'package:kalm/pages/auth/onboarding.dart';
import 'package:kalm/pages/auth/verify_code.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/loading.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'package:kalm/widget/textfield.dart';
import 'package:wonderpush_flutter/wonderpush_flutter.dart';

class LoginPage extends StatelessWidget {
  final _controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (_) {
      return NON_MAIN_SAFE_AREA(
          bottomPadding: 0,
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/wave/login_wave.png'),
                    alignment: Alignment.bottomCenter)),
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      if (MediaQuery.of(context).viewInsets.bottom == 0.0)
                        Column(
                          children: [
                            Image.asset('assets/icon/kalm.png', scale: 2.5),
                            SPACE(),
                            Image.asset('assets/icon/login_icon.png',
                                scale: 2.5),
                          ],
                        ),
                      TEXT_FIELD(_.emailField,
                          focusNode: _.emailFocus,
                          onSubmitted: (val) => _.onSubmittedEmail(val),
                          onChanged: (val) => _.onChangeEmail(val),
                          prefixIcon: const Icon(Icons.email_outlined),
                          hint: 'Email'),
                      SPACE(),
                      if (_.validateEmail != null) _.validateEmail!,
                      SPACE(),
                      TEXT_FIELD(_.passwodField,
                          obscureText: _.passwordObsecure,
                          onSubmitted: (val) async =>
                              await _.onSubmittedPassword(val),
                          focusNode: _.passwordFocus,
                          onChanged: (val) => _.onChangePassword(val),
                          prefixIcon: Icon(_.passwordObsecure
                              ? Icons.lock_outline
                              : Icons.lock_open_outlined),
                          hint: "Password",
                          suffixIcon: IconButton(
                              onPressed: () => _.onChangeObsecure(),
                              icon: Icon(_.passwordObsecure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility))),
                      SPACE(),
                      if (_.validatePassword != null) _.validatePassword!,
                      SPACE(height: 20),
                      BUTTON("Masuk",
                          verticalPad: 15,
                          circularRadius: 30,
                          onPressed: _.validationForm
                              ? () async => await _.submit()
                              : null),
                      SPACE(),
                      BUTTON("Daftar",
                          verticalPad: 15,
                          circularRadius: 30,
                          onPressed: () => Get.to(OnBoardingPage())),
                      SPACE(height: 20),
                      _forgetPassword(_),
                    ],
                  ),
                )
              ],
            ),
          ));
    });
  }

  InkWell _forgetPassword(LoginController _) {
    return InkWell(
        onTap: () async {
          TextEditingController _emailController = TextEditingController();
          bool _validateEmail = false;
          await Get.bottomSheet(StatefulBuilder(builder: (context, st) {
            return Container(
                color: Colors.white,
                height: Get.height / 3.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      TEXT("Lupa Password", style: Get.textTheme.headline2),
                      SPACE(),
                      Column(
                        children: [
                          SizedBox(
                            height: 40,
                            child: CupertinoTextField(
                              onChanged: (val) {
                                st(() {
                                  if (val.isEmail) {
                                    _validateEmail = true;
                                  } else {
                                    _validateEmail = false;
                                  }
                                });
                              },
                              placeholder: "Email",
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(width: 0.5, color: BLUEKALM)),
                              controller: _emailController,
                            ),
                          ),
                          if (!_validateEmail &&
                              _emailController.text.length > 1)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child:
                                  ERROR_VALIDATION_FIELD("Email tidak valid"),
                            )
                        ],
                      ),
                      SPACE(),
                      Row(
                        children: [
                          BUTTON(
                            "Lanjutkan",
                            onPressed: () async {
                              Get.back();
                              await _.forgotPassword(_emailController.text);
                            },
                            isExpanded: true,
                            expandedHorizontalPad: 5,
                          ),
                          BUTTON("Batalkan", onPressed: () {
                            Get.back();
                          }, isExpanded: true, expandedHorizontalPad: 5),
                        ],
                      ),
                    ],
                  ),
                ));
          }), barrierColor: BLUEKALM.withOpacity(0.6));
        },
        child: TEXT("Lupa Kata Sandi?",
            style: COSTUM_TEXT_STYLE(
                color: ORANGEKALM, fontWeight: FontWeight.w600)));
  }
}

class LoginController extends GetxController {
  Widget? validateEmail, validatePassword;
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  TextEditingController emailField = TextEditingController();
  TextEditingController passwodField = TextEditingController();
  bool passwordObsecure = true;
  bool get validationForm =>
      (validateEmail == null && validatePassword == null) &&
      (emailField.text.isNotEmpty && passwodField.text.isNotEmpty);

  void onChangeObsecure() {
    passwordObsecure = !passwordObsecure;
    update();
  }

  void onChangeEmail(String val) {
    if (val.isEmpty) {
      validateEmail = null;
    } else if (!val.isEmail) {
      validateEmail = ERROR_VALIDATION_FIELD("Email tidak valid");
    } else {
      // validateEmail = SUCCESS_VALIDATION_FIELD("Email Terverifikasi");
      validateEmail = null;
    }
    update();
  }

  void onChangePassword(String val) {
    if (val.isEmpty) {
      validatePassword = null;
    } else if (val.length < 6) {
      validatePassword = ERROR_VALIDATION_FIELD("Password minimal 6 digit");
    } else {
      // validatePassword = SUCCESS_VALIDATION_FIELD("Password Terverifikasi");
      validatePassword = null;
    }
    update();
  }

  void onSubmittedEmail(String val) {
    emailFocus.unfocus();
    FocusScope.of(Get.context!).requestFocus(passwordFocus);
  }

  Future<void> onSubmittedPassword(String val) async {
    validationForm ? await submit() : null;
  }

  Future<int?> _deviceNum() async {
    if (kIsWeb) {
      return 00000;
    } else {
      try {
        if (await FlutterDeviceIdentifier.checkPermission()) {
          try {
            var _serialNumber = await FlutterDeviceIdentifier.imeiCode;
            return double.parse(_serialNumber.replaceAll(RegExp(r"\D"), ''))
                .floor();
          } catch (e) {
            var rng = Random();
            var l = List.generate(8, (_) => rng.nextInt(100));
            return int.parse(l.join(',').replaceAll(',', ''));
          }
        } else {
          if (await FlutterDeviceIdentifier.requestPermission()) {
            try {
              var _serialNumber = await FlutterDeviceIdentifier.imeiCode;
              return double.parse(_serialNumber.replaceAll(RegExp(r"\D"), ''))
                  .floor();
            } catch (e) {
              var rng = Random();
              var l = List.generate(8, (_) => rng.nextInt(100));
              return int.parse(l.join(',').replaceAll(',', ''));
            }
          } else {
            ERROR_SNACK_BAR("Perhatian", 'Izinkan aplikasi untuk melanjutkan');
            await Future.delayed(const Duration(seconds: 2));
            FlutterDeviceIdentifier.openSettings();
            return null;
          }
        }
      } catch (e) {
        var rng = Random();
        var l = List.generate(8, (_) => rng.nextInt(100));
        return int.parse(l.join(',').replaceAll(',', ''));
      }
    }
  }

  Future<String?> _installationId() async {
    // if (Platform.localHostname == "Dayonas-MacBook-Pro.local") {
    //   return "test-installation";
    // } else {
    // print(await WonderPush.getUserId());

    if (kIsWeb) {
      return "WEB_TOKEN";
    }
    return await WonderPush.getInstallationId();
    // }
  }

  OrsPayload get orsPayload => OrsPayload(
      userCode: PRO.userData?.code,
      date: DateTime.now().toIso8601String(),
      value: OrsValue(
          first: PRO.localOrs![0].toInt(),
          second: PRO.localOrs![1].toInt(),
          third: PRO.localOrs![2].toInt(),
          four: PRO.localOrs![3].toInt()));
  Future<void> submit() async {
    if (await _installationId() == null) {
      ERROR_SNACK_BAR('Perhatian',
          "Anda tidak mengizinkan fitur Notifikasi di ponsel Anda\nSilahkan restart aplikasi KALM untuk mengaktifkan notifikasi kembali");
      return;
    } else if (await _deviceNum() == null) {
      return;
    }
    var _firebaseToken = await PRO.firebaseAuth.currentUser?.getIdToken();
    var _payload = LoginPayload(
        email: emailField.text,
        password: passwodField.text,
        deviceNumber: await _deviceNum(),
        installationId: await _installationId(),
        deviceType: _deviceType(),
        firebaseToken: _firebaseToken,
        role: "10");
    var _res = await Api().POST(AUTH, _payload.toJson());
    // PR(_res?.data['data']["ever_bought_package_subscription"]);
    if (_res?.statusCode == 200) {
      emailField.clear();
      passwodField.clear();
      emailFocus.unfocus();
      passwordFocus.unfocus();
      update();
      var _user = UserModel.fromJson(_res?.data).data;
      await _redirectPage(_user);
    } else {
      Loading.hide();
      return;
    }
  }

  int _deviceType() {
    if (kIsWeb) {
      return 10;
    }
    return Platform.isAndroid ? 0 : 1;
  }

  Future<void> forgotPassword(String email) async {
    var _res =
        await Api().POST(FORGOT_PASSWORD, {"email": email, "role": "10"});
    if (_res?.statusCode == 200) {
      Loading.hide();
      SUCCESS_SNACK_BAR("Perhatian", _res?.data['message']);
      return;
    } else {
      Loading.hide();
      return;
    }
  }

  Future<void> _redirectPage(UserData? _user) async {
    switch (_user?.status == 1 || _user?.status == 2 || _user?.status == 3) {
      case true:
        await PRO.saveLocalUser(_user);
        if (PRO.localOrs != null) {
          var _orsRes =
              await Api().POST(STORE_ORS, orsPayload.toJson(), useToken: true);
          if (_orsRes?.statusCode != 200) {
            Loading.hide();
            return;
          }
          await PRO.saveOrs([], isDelete: true);
        }
        if (_user?.userHasActiveCounselor != null) {
          await PRO.getCounselor(useLoading: true);
        }
        Loading.hide();
        await Get.offAll(KalmMainTab());
        break;
      case false:
        await PRO.saveLocalUser(_user);
        if (_user?.status == 5) {
          Loading.hide();
          await Get.offAll(VerifyCodePage());
        } else {
          Loading.hide();
          return;
        }
        break;
      default:
        Loading.hide();
        break;
    }
  }
}

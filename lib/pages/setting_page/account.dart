import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/change_password_payload.dart';
import 'package:kalm/model/user_model/user_model.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/loading.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'package:kalm/widget/textfield.dart';

class AccountPage extends StatelessWidget {
  final _controller = Get.put(AccountController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(dispose: (d) {
      _controller.clearTextController();
    }, builder: (_) {
      return SAFE_AREA(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                TEXT("AKUN", style: Get.textTheme.headline2),
                Column(
                  children: List.generate(4, (i) {
                    return Builder(builder: (context) {
                      if (i == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SPACE(),
                            TEXT("Email", style: Get.textTheme.headline1),
                            _textField(_.textController[i],
                                onSubmitted: _.onSubmitted()[i],
                                onChanged: _.onChange()[i],
                                focusNode: _.focusNode[i],
                                obscureText: _.obsecureController[i],
                                onPressedSecure: _.onPressSecure()[i],
                                isRead: i == 0),
                            SPACE(),
                            TEXT("UBAH PASSWORD", style: Get.textTheme.headline1),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            _textField(_.textController[i],
                                onSubmitted: _.onSubmitted()[i],
                                onChanged: _.onChange()[i],
                                focusNode: _.focusNode[i],
                                obscureText: _.obsecureController[i],
                                onPressedSecure: _.onPressSecure()[i],
                                isRead: i == 0,
                                placeholder: _.placeholder[i]),
                            if (!_.validationField[i] && _.textController[i].text.isNotEmpty)
                              ERROR_VALIDATION_FIELD(_.errorMessageField[i])
                          ],
                        );
                      }
                    });
                  }),
                ),
                SPACE(),
                BUTTON("Kirim",
                    onPressed:
                        !_.validationField.contains(false) ? () async => await _.submit() : null,
                    verticalPad: 15,
                    circularRadius: 30)
              ],
            ),
          )
        ],
      ));
    });
  }

  Padding _textField(
    TextEditingController controller, {
    bool obscureText = true,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    FocusNode? focusNode,
    void Function()? onPressedSecure,
    bool isRead = false,
    String? placeholder,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        height: 40,
        child: CupertinoTextField(
          padding: const EdgeInsets.all(10.0),
          placeholder: placeholder,
          readOnly: isRead,
          focusNode: focusNode,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
          onSubmitted: onSubmitted,
          onChanged: onChanged,
          obscureText: obscureText,
          controller: controller,
          prefix: isRead
              ? const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.email),
                )
              : null,
          suffix: isRead
              ? null
              : IconButton(
                  onPressed: onPressedSecure,
                  icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility)),
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: BLUEKALM),
              borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}

class AccountController extends GetxController {
  List<TextEditingController> textController = List.generate(4, (i) {
    if (i == 0) {
      return TextEditingController(text: PRO.userData?.email);
    } else {
      return TextEditingController();
    }
  });
  List<bool> obsecureController = List.generate(4, (i) {
    if (i == 0) {
      return false;
    } else {
      return true;
    }
  });
  List<bool> validationField = List.generate(4, (i) {
    if (i == 0) {
      return true;
    } else {
      return false;
    }
  });

  List<FocusNode> focusNode = List.generate(4, (i) => FocusNode());
  List<String> placeholder = [
    "Email",
    "Password Lama",
    "Password Baru",
    "Konfirmasi Password Baru"
  ];
  List<String> errorMessageField = [
    "",
    "Minimal 6 karakter",
    "Minimal 6 karakter dan pastikan tidak sama dengan password lama",
    "Konfirmasi Password sesuai"
  ];

  List<Function(String val)> onChange() {
    return List.generate(4, (i) {
      return (v) {
        if (v.isNotEmpty && v.length < 6) {
          validationField[i] = false;
        } else if (i == 2) {
          if ((v.isNotEmpty) && v == textController[1].text) {
            validationField[i] = false;
          } else {
            validationField[i] = true;
          }
        } else if (i == 3) {
          if ((v.isNotEmpty) && v != textController[2].text) {
            validationField[i] = false;
          } else {
            validationField[i] = true;
          }
        } else {
          validationField[i] = true;
        }
        update();
      };
    });
  }

  List<Function(String val)> onSubmitted() {
    return List.generate(4, (i) {
      return (v) async {
        try {
          if (i == 3) {
            await submit();
          }
          focusNode[i].unfocus();
          FocusScope.of(Get.context!).requestFocus(focusNode[i + 1]);
        } catch (e) {
          focusNode[i].unfocus();
        }
      };
    });
  }

  List<Function()> onPressSecure() {
    return List.generate(4, (i) {
      return () {
        obsecureController[i] = !obsecureController[i];
        update();
      };
    });
  }

  void clearTextController() {
    for (var i = 0; i < textController.length; i++) {
      if (i != 0) {
        textController[i].clear();
      }
    }
  }

  ChangePasswordPayload get changePasswordPayload => ChangePasswordPayload(
      currentPassword: textController[1].text,
      newPassword: textController[2].text,
      confirmPassword: textController[3].text);

  Future<void> submit() async {
    var _res = await Api().POST(CHANGE_PASSWORD, changePasswordPayload.toJson(), useToken: true);
    if (_res?.statusCode == 200) {
      await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
      Loading.hide();
      SUCCESS_SNACK_BAR("Perhatian", _res?.message);
      Get.back();
    } else {
      Loading.hide();
      return;
    }
  }
}

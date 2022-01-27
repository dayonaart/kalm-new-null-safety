import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/user_model/user_data.dart';
import 'package:kalm/pages/questioner_page.dart/user_questioner_match_up_page.dart';
import 'package:kalm/pages/setting_page/edit_profile.dart';
import 'package:kalm/utilities/date_format.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/image_cache.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class ProfilePage extends StatelessWidget {
  final _controller = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (_) {
      return SAFE_AREA(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                CircleAvatar(
                    backgroundColor: BLUEKALM,
                    radius: 100,
                    child: IMAGE_CACHE(
                      "$IMAGE_URL/users/${_.user(context)?.photo}",
                      width: 190,
                      height: 190,
                      circularRadius: 100,
                    )),
                SPACE(),
                TEXT("${_.user(context)?.firstName} ${_.user(context)?.lastName ?? ""}",
                    style: Get.textTheme.headline2),
                SPACE(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(3, (i) {
                      return Column(
                        children: [
                          _properties(i),
                          SPACE(),
                          _propertiesText(i, context),
                        ],
                      );
                    })),
                SPACE(height: 20),
                const Divider(thickness: 1, color: BLUEKALM),
                _optionList(_, context),
              ],
            ),
          )
        ],
      ));
    });
  }

  Column _optionList(ProfileController _, BuildContext context) {
    return Column(
      children: List.generate(3, (i) {
        return BUTTON(
          _.buttonTitle[i],
          onPressed: _.onPress(context)[i],
          verticalPad: 10,
          circularRadius: 20,
          titleMainAxisAlignment: MainAxisAlignment.start,
        );
      }),
    );
  }

  Text _propertiesText(int i, BuildContext context) {
    switch (i) {
      case 0:
        try {
          return TEXT(
              "${VALIDATE_DOB_MATURE(STATE(context).userData!.dob!)!.toStringAsFixed(0)} Tahun");
        } catch (e) {
          return TEXT("Not found");
        }
      case 1:
        return TEXT(PRO.userData?.gender == 1 ? "Laki-Laki" : "Perempuan");
      case 2:
        return TEXT(_country(PRO.userData!.countryId));
      default:
        return TEXT("Unknow");
    }
  }

  String _country(int? i) {
    try {
      switch (i) {
        case 1:
          return "Indonesia";
        case 2:
          return "Singapore";
        case 3:
          return "Lainnya";
        default:
          return "Unknow";
      }
    } catch (e) {
      return "Unknow";
    }
  }

  CircleAvatar _properties(int i) {
    return CircleAvatar(
        backgroundColor: ORANGEKALM,
        radius: 35,
        child: Image.asset(_controller.properties[i], scale: 3));
  }
}

class ProfileController extends GetxController {
  UserData? user(BuildContext context) {
    return STATE(context).userData;
  }

  List<String> properties = [
    "assets/image/gender.png",
    "assets/tab/setting.png",
    "assets/image/latitude.png"
  ];
  List<String> buttonTitle = [
    "informasi Pribadi",
    "Kuisioner Pengenalan",
    "Jawaban Kuisioner Pencocokan"
  ];
  List<Future<void> Function()> onPress(BuildContext context) {
    return List.generate(3, (i) {
      return () async {
        switch (i) {
          case 0:
            await pushNewScreen(context, screen: EditProfilePage());
            break;
          case 1:
            // var _res = await Api().GET(GET_TO_KNOW, useToken: true);
            // if (_res?.statusCode == 200) {
            //   var _list = _res?.data['data'] as List<dynamic>;
            //   // _list.sort((a, b) {
            //   //   return DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at']));
            //   // });
            //   _list.sort((a, b) {
            //     return (b['questionnaire_id'] as int).compareTo(a['questionnaire_id']);
            //   });
            //   var _model = _list.take(11).map((e) {
            //     print(e);
            //     print(e['questionnaire_id']);
            //     try {
            //       return UserQuestionerPayload.fromJson(e);
            //     } catch (e) {
            //       return UserQuestionerPayload();
            //     }
            //   }).toList();
            // List<UserQuestionerPayload> _gen =
            //     List.generate((_res?.data['data'] as List<dynamic>).length, (i) {
            //   try {
            //     return UserQuestionerPayload(
            //         answer: _res?.data['data'][i]['answer'].runtimeType == int
            //             ? _res?.data['data'][i]['answer']
            //             : int.parse(_res?.data['data'][i]['answer']));
            //   } catch (e) {
            //     return UserQuestionerPayload(question: e.toString());
            //   }
            // });
            // print(_model.map((e) => e.toJson()).toList());
            // } else {}

            // await pushNewScreen(context, screen: UserQustionerPage());
            break;
          case 2:
            var _gridAnswer = PRO.userData?.matchupJson?.map((e) {
              return e?.answer?.map((f) {
                if (f.runtimeType == int) {
                  return f as int;
                } else {
                  return int.parse(f);
                }
              }).toList();
            }).toList();
            await pushNewScreen(context,
                screen: UserQustionerMatchupPage(
                  isEdit: false,
                  gridAnswer: _gridAnswer![1]!,
                  languageAnswer: _gridAnswer[0]!,
                ));
            break;
          default:
        }
      };
    });
  }

  int? _existingPayloadAnswer(int i) {
    var _u = PRO.userData;
    switch (i) {
      case 1:
        return 0;
      case 2:
        return 0;
      case 3:
        return _u?.gender;
      case 4:
        return _u?.gender;
      case 5:
        return 0;
      case 6:
        return 0;
      case 7:
        return 0;
      case 8:
        return 0;
      case 9:
        return 0;
      case 10:
        return 0;
      case 11:
        return 0;
      case 12:
        return 0;
      default:
        return 0;
    }
  }
}

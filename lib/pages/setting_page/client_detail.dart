import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/tnc_res_model/tnc_data.dart';
import 'package:kalm/pages/change_client.dart';
import 'package:kalm/pages/questioner_page.dart/user_questioner_match_up_page.dart';
import 'package:kalm/utilities/date_format.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/image_cache.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'dart:math' as math;

class ClientDetailPage extends StatelessWidget {
  final _controller = Get.put(ClientDetailController());
  @override
  Widget build(BuildContext context) {
    // print(PRO.counselorData?.counselor?.userCounselorFile?.toJson());
    return GetBuilder<ClientDetailController>(builder: (_) {
      return SAFE_AREA(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                CircleAvatar(
                    backgroundColor: BLUEKALM,
                    radius: 80,
                    child: Builder(builder: (context) {
                      return IMAGE_CACHE(
                        "$IMAGE_URL/users/${PRO.counselorData?.counselor?.photo}",
                        width: 150,
                        height: 150,
                        circularRadius: 80,
                      );
                    })),
                SPACE(),
                TEXT(
                    "${PRO.counselorData?.counselor?.firstName} ${PRO.counselorData?.counselor?.lastName}",
                    style: COSTUM_TEXT_STYLE(
                        fonstSize: 20, fontWeight: FontWeight.w500)),
                SPACE(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(3, (i) {
                      return Column(
                        children: [
                          _properties(i),
                          SPACE(),
                          _propertiesText(i),
                        ],
                      );
                    })),
                SPACE(height: 10),
                const Divider(thickness: 1),
                SPACE(height: 20),
                Column(
                  children: List.generate(3, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: BUTTON(_.buttonTitle[i],
                          suffixIcon: Transform.rotate(
                              angle: math.pi,
                              child: const Icon(Icons.arrow_back_ios_new)),
                          circularRadius: 30,
                          verticalPad: 10,
                          onPressed: () async => await _.onPress(i, context)),
                    );
                  }),
                ),
                SPACE(height: 20),
                SizedBox(
                  width: Get.width / 1.5,
                  child: BUTTON(
                    'Ganti Kalmselor',
                    onPressed: () async {
                      await pushNewScreen(context, screen: ChangeClientPage());
                    },
                    circularRadius: 30,
                    verticalPad: 10,
                  ),
                )
              ],
            ),
          ),
        ],
      ));
    });
  }

  Text _propertiesText(int i) {
    switch (i) {
      case 0:
        try {
          return TEXT(
              "${VALIDATE_DOB_MATURE(PRO.counselorData?.counselor?.dob)!.toStringAsFixed(0)} Tahun");
        } catch (e) {
          return TEXT("Not found");
        }
      case 1:
        return TEXT(PRO.counselorData?.counselor?.gender == 1
            ? "Laki-Laki"
            : "Perempuan");
      case 2:
        return TEXT(_country(PRO.counselorData?.counselor?.countryId));
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

class ClientDetailController extends GetxController {
  List<String> properties = [
    "assets/image/gender.png",
    "assets/tab/setting.png",
    "assets/image/latitude.png"
  ];
  List<String> buttonTitle = [
    "Keahlian",
    "Kredensial Tambahan",
    "Persetujuan Kalmselor - klien"
  ];

  Future<void> onPress(int i, BuildContext context) async {
    switch (i) {
      case 0:
        var _gridAnswer = PRO.counselorData?.counselor?.matchupJson?.map((e) {
          return e?.answer?.map((f) {
            if (f.runtimeType == int) {
              return f as int;
            } else {
              return int.parse(f);
            }
          }).toList();
        }).toList();
        if (_gridAnswer == null || _gridAnswer.contains(null)) {
          ERROR_SNACK_BAR("Perhatian",
              "Keahlian tidak tersedia\natau hubungi Kalmselor Anda untuk memperbaharui keahlian");
          return;
        }
        await pushNewScreen(context,
            screen: UserQustionerMatchupPage(
              gridAnswer: _gridAnswer[1]!,
              languageAnswer: _gridAnswer[0]!,
              isEdit: false,
            ));
        break;
      case 1:
        if (PRO.counselorData?.counselor?.userCounselorOptionalFiles == null) {
          ERROR_SNACK_BAR(
              "Perhatian", "Kalmselor tidak memiliki kredensial tambahan");
        } else {
          pushNewScreen(context, screen: _counselorOptionalFile());
        }
        break;
      case 2:
        if (PRO.tncResModel != null) {
          // print(PRO.tncResModel?.toJson());
        } else {
          // await PRO.getTncData();
        }
        var _data = PRO.tncResModel?.data;
        pushNewScreen(context, screen: _clientTnc(_data));
        break;
      default:
    }
  }

  SafeArea _clientTnc(List<TncResModelData>? _data) {
    return SAFE_AREA(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ListView(
        children: [
          Column(
            children: [
              TEXT("Persetujuan Kalmselor - Klien",
                  style: COSTUM_TEXT_STYLE(
                      fontWeight: FontWeight.w700, fonstSize: 20)),
              SPACE(),
              TEXT("Persetujuan ini telah Anda setujui pada\n"),
              TEXT(
                  "${PRO.counselorData?.counselor?.firstName} ${PRO.counselorData?.counselor?.lastName}",
                  style: COSTUM_TEXT_STYLE(
                      fontWeight: FontWeight.w500, fonstSize: 18)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _data!.map((e) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TEXT(e.name,
                      style: COSTUM_TEXT_STYLE(
                          fontWeight: FontWeight.w700, fonstSize: 18)),
                  TEXT(e.description),
                ],
              );
            }).toList(),
          )
        ],
      ),
    ));
  }

  SafeArea _counselorOptionalFile() {
    return SAFE_AREA(
        child: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              TEXT("Kredesial Tambahan", style: Get.textTheme.headline2),
              SPACE(),
              Column(
                  children: List.generate(
                      PRO.counselorData?.counselor?.userCounselorOptionalFiles
                              ?.length ??
                          0, (i) {
                var _data = PRO
                    .counselorData!.counselor!.userCounselorOptionalFiles![i];
                return Column(
                  children: [
                    IMAGE_CACHE(COUNSELOR_IMAGE_URL + _data!.file!),
                    SPACE(),
                  ],
                );
              }))
            ],
          ),
        )
      ],
    ));
  }
}

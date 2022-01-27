import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/pages/questioner_page.dart/user_questioner_match_up_page.dart';
import 'package:kalm/pages/setting_page/contact_us.dart';
import 'package:kalm/pages/setting_page/packages.dart';
import 'package:kalm/tab_pages/chat_room.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/image_cache.dart';
import 'package:kalm/widget/loading.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'dart:math' as math;

class ChatPage extends StatelessWidget {
  final _controller = Get.put(ChatController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (_) {
      return NON_MAIN_SAFE_AREA(
          top: true,
          child: Builder(builder: (context) {
            return Builder(builder: (context) {
              if (STATE(context).isHavePackages) {
                if (STATE(context).isChatting) {
                  return ChatRoomPage();
                } else if (STATE(context).isPendingKalmselorCode) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: _pendingKalmselorCode(context));
                } else if (STATE(context).isShowTnc) {
                  return _showTnc(context, _);
                } else {
                  return _matchingSystem(context);
                }
              } else {
                return _buyPackages(context);
              }
            });
          }));
    });
  }

  ListView _showTnc(BuildContext context, ChatController _) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              CircleAvatar(
                  backgroundColor: BLUEKALM,
                  radius: 70,
                  child: IMAGE_CACHE(
                      IMAGE_URL +
                          "users/${STATE(context).counselorData?.counselor?.photo}",
                      width: 130,
                      height: 130,
                      circularRadius: 70)),
              SPACE(height: 20),
              _tncDesc(_, context),
              SPACE(height: 20),
              SizedBox(
                width: Get.width / 1.5,
                child: Column(
                  children: [
                    BUTTON("Terima",
                        backgroundColor: GREENKALM,
                        verticalPad: 10,
                        circularRadius: 30,
                        onPressed: STATE(context).tncResModel == null
                            ? null
                            : () async => await _.accTnc(),
                        suffixIcon: Image.asset('assets/icon/accept.png',
                            scale: 5, color: Colors.white)),
                    SPACE(),
                    BUTTON("Tolak",
                        backgroundColor: BLUEKALM,
                        verticalPad: 10,
                        circularRadius: 30,
                        onPressed: STATE(context).tncResModel == null
                            ? null
                            : () async => await _.rejectTnc(),
                        suffixIcon: Image.asset('assets/icon/decline.png',
                            scale: 5, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Container _tncDesc(ChatController _, BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(width: 0.5),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (STATE(context).tncResModel != null)
                Column(
                  children: [
                    TEXT(
                        "${STATE(context).counselorData?.counselor?.firstName} ${STATE(context).counselorData?.counselor?.lastName}",
                        style: COSTUM_TEXT_STYLE(
                            fonstSize: 20, fontWeight: FontWeight.bold)),
                    SPACE(),
                    TEXT(STATE(context)
                        .tncResModel
                        ?.data
                        ?.map((e) => "${e.description}\n")
                        .join(',')),
                  ],
                )
              else
                const CupertinoActivityIndicator(radius: 10)
            ],
          ),
        ));
  }

  SizedBox _pendingKalmselorCode(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CupertinoActivityIndicator(radius: 40),
          SPACE(),
          TEXT('Mohon Menunggu'),
          SPACE(),
          TEXT("Anda akan dihubungkan dengan Kalmselor"),
          TEXT(
              " ${STATE(context).pendingKalmselorCodeModel?.data?.counselorFullname}",
              style: COSTUM_TEXT_STYLE(
                  fonstSize: 18, fontWeight: FontWeight.w500)),
          SPACE(height: 20),
          SizedBox(
              width: Get.width / 1.5,
              child: BUTTON("Hubungi Admin", onPressed: () async {
                if (PRO.contactUsResModel == null) {
                  await PRO.getContactUs();
                  Loading.hide();
                }
                pushNewScreen(context, screen: ContactUsPage());
              }, circularRadius: 30, verticalPad: 15)),
        ],
      ),
    );
  }

  SizedBox _matchingSystem(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CupertinoActivityIndicator(radius: 40),
          SPACE(),
          TEXT('Mohon Menunggu'),
          SPACE(),
          TEXT(
              "Kalmselor yang cocok akan segera melayani\nAnda selambat-lambatnya dalam 1x24 jam"),
          SPACE(height: 20),
          SizedBox(
              width: Get.width / 1.5,
              child: BUTTON("Ubah Preferensi", onPressed: () async {
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
                      gridAnswer: _gridAnswer![1]!,
                      languageAnswer: _gridAnswer[0]!,
                    ));
              }, circularRadius: 30, verticalPad: 15)),
          SPACE(),
          SizedBox(
              width: Get.width / 1.5,
              child: BUTTON("Hubungi Admin", onPressed: () async {
                if (PRO.contactUsResModel == null) {
                  await PRO.getContactUs();
                  Loading.hide();
                }
                pushNewScreen(context, screen: ContactUsPage());
              }, circularRadius: 30, verticalPad: 15)),
        ],
      ),
    );
  }

  SizedBox _buyPackages(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TEXT(
              'Maaf paket berlangganan sudah habis.\nSilahkan membeli paket berlangganan\nuntuk menggunakan fitur chat',
              textAlign: TextAlign.center,
              style: COSTUM_TEXT_STYLE(fonstSize: 18)),
          SPACE(height: 30),
          SizedBox(
              width: Get.width / 1.5,
              child: BUTTON("Beli Paket", onPressed: () async {
                if (PRO.subscriptionListResModel != null) {
                  await pushNewScreen(context, screen: PackagesPage());
                } else {
                  await PRO.getSubSubcriptionList();
                  Loading.hide();
                  await pushNewScreen(context, screen: PackagesPage());
                }
              }, circularRadius: 30, verticalPad: 15)),
          SPACE(),
          SizedBox(
              width: Get.width / 1.5,
              child: BUTTON("Hubungi Admin", onPressed: () async {
                if (PRO.contactUsResModel == null) {
                  await PRO.getContactUs();
                  Loading.hide();
                }
                pushNewScreen(context, screen: ContactUsPage());
              }, circularRadius: 30, verticalPad: 15)),
        ],
      ),
    );
  }
}

class ChatController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Future<void> accTnc() async {
    var _res = await Api()
        .POST(ACC_TNC(PRO.counselorData!.counselor!.code!), {}, useToken: true);
    if (_res?.statusCode == 200) {
      await PRO.updateSession(useLoading: true);
      Loading.hide();
    } else {
      Loading.hide();
      return;
    }
  }

  Future<void> rejectTnc() async {
    var _res = await Api()
        .POST(REJECT_TNC, {"reason": "Reject TNC by User"}, useToken: true);
    if (_res?.statusCode == 200) {
      await PRO.updateSession(useLoading: true);
      Loading.hide();
    } else {
      Loading.hide();
      return;
    }
  }
}

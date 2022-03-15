import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/pages/questioner_page.dart/user_questioner_match_up_page.dart';
import 'package:kalm/pages/questioner_page.dart/user_questioner_page.dart';
import 'package:kalm/tab_pages/chat_page.dart';
import 'package:kalm/tab_pages/discovery_page.dart';
import 'package:kalm/tab_pages/gratitude_journal.dart';
import 'package:kalm/tab_pages/home_page.dart';
import 'package:kalm/tab_pages/setting_page.dart';
import 'package:kalm/widget/curved_nav_bar.dart';
import 'package:kalm/widget/dialog.dart';
import 'package:kalm/widget/persistent_tab/persistent_kalm_tab.dart';
import 'package:get/get.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

GetBuilder<KalmAppController> KalmMainTab() {
  late StreamSubscription<bool> keyboardSubscription;
  return GetBuilder<KalmAppController>(initState: (st) async {
    if (!kIsWeb) await PRO.checkAppVersion();
    if (PRO.surveyResModel != null && !(PRO.userData?.hasBuyPackage)!) {
      SHOW_DIALOG(
          "${PRO.surveyResModel?.title}\n${PRO.surveyResModel?.content}",
          onAcc: () async {
        if (await canLaunch(PRO.surveyResModel!.url!)) {
          launch(PRO.surveyResModel!.url!);
          Get.back();
        } else {
          Get.back();
          ERROR_SNACK_BAR("Perhatian", 'Tidak dapat membuka link');
        }
      }, reject: () async {
        Get.back();
      });
    }
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      PRO.updateKeyboardVisibility(visible);
    });
    PRO.matchupRef.onValue.listen((event) async {
      await PRO.updateSession();
    });
  }, builder: (_) {
    return PersistentTabView.custom(Get.context!,
        backgroundColor: Colors.transparent,
        bottomScreenMargin: 0,
        handleAndroidBackButtonPress: true,
        onWillPop: (v) => _.onWillpop(),
        controller: PRO.tabController,
        confineInSafeArea: false,
        screens: _.pages(Get.context!),
        customWidget: _navBar(_),
        itemCount: _.pages(Get.context!).length);
  });
}

Builder _navBar(KalmAppController _) {
  return Builder(builder: (context) {
    return CurvedNavigationBar(
      items: const <String>[
        "assets/tab/home.png",
        "assets/tab/gratitude.png",
        "assets/tab/chat.png",
        "assets/tab/discovery.png",
        "assets/tab/setting.png"
      ],
      onTap: (index) => PRO.onChangeTab(index),
      index: STATE(context).tabController.index,
    );
  });
}

class KalmAppController extends GetxController {
  Future<bool> onWillpop() async {
    return await Future.value(true);
  }

  List<Widget> pages(BuildContext context) {
    return [
      HomePage(),
      GratitudeJournalPage(),
      page3(context),
      DiscoveryPage(),
      SettingPage()
    ];
  }

  Widget page3(BuildContext context) {
    if (STATE(context).statusTestDebug != null) {
      switch (STATE(context).statusTestDebug) {
        case 5:
          return UserQustionerPage();
        case 2:
          return UserQustionerMatchupPage();
        default:
          return ChatPage();
      }
    } else {
      switch (PRO.userData?.status) {
        case 2:
          if (PRO.userData?.dob == null) {
            return UserQustionerPage();
          } else {
            return UserQustionerMatchupPage();
          }
        default:
          return ChatPage();
      }
    }
  }

  List<Widget> items = [
    Image.asset("assets/tab/home.png", scale: 3),
    Image.asset("assets/tab/gratitude.png", scale: 3),
    Image.asset("assets/tab/chat.png", scale: 3),
    Image.asset("assets/tab/discovery.png", scale: 3),
    Image.asset("assets/tab/setting.png", scale: 3),
  ];
  int selectedIndex = 0;

  Future<void> _updateRead() async {
    var _snap =
        PRO.database.ref("chats/${PRO.counselorData?.matchupId ?? "100111"}");
    var _getRead = await _snap
        .orderByChild("code")
        .equalTo("CONS-210409025411162")
        // .equalTo(PRO.counselorData?.counselor?.code)
        .once();
    var _chatModel = Map<String, dynamic>.from(
        _getRead.snapshot.value as Map<Object?, Object?>);
    _chatModel.forEach((key, value) {
      _snap.child(key).child("status").set("read");
    });
  }
}

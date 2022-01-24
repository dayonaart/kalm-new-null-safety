import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/pages/auth/login.dart';
import 'package:kalm/pages/gratitude_journal_history.dart';
import 'package:kalm/pages/setting_page/about_us.dart';
import 'package:kalm/pages/setting_page/account.dart';
import 'package:kalm/pages/setting_page/contact_us.dart';
import 'package:kalm/pages/setting_page/faq.dart';
import 'package:kalm/pages/setting_page/how_to_use.dart';
import 'package:kalm/pages/setting_page/packages.dart';
import 'package:kalm/pages/setting_page/privacy_policy.dart';
import 'package:kalm/pages/setting_page/profile.dart';
import 'package:kalm/pages/setting_page/term_and_condition.dart';
import 'package:kalm/utilities/deep_link_redirect.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'dart:math' as math;

class SettingPage extends StatelessWidget {
  final _controller = Get.put(SettingController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(builder: (_) {
      return SAFE_AREA(
          canBack: false,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Column(
                      children: _.buttonTitle.map((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: InkWell(
                            onTap: () async => await _.onPress(e, context),
                            child: SizedBox(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TEXT(e),
                                      Transform.rotate(
                                        angle: math.pi,
                                        child: const Icon(Icons.arrow_back_ios_new,
                                            color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  const Divider(thickness: 1, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SPACE(),
                    SizedBox(
                      width: Get.width / 1.3,
                      child: BUTTON("Keluar", circularRadius: 30, verticalPad: 15,
                          onPressed: () async {
                        PRO.updateInitialIndexTab(0);
                        await PRO.clearAllData();
                      }),
                    ),
                    SPACE(),
                    TEXT("APP VERSION"),
                    SPACE(),
                    TEXT(STATE(context).APP_VERSION, style: COSTUM_TEXT_STYLE(color: Colors.grey))
                  ],
                ),
              ),
            ],
          ));
    });
  }
}

class SettingController extends GetxController {
  List<String> buttonTitle = [
    'Tentang Kalm',
    'Akun',
    'Profil',
    'Pin Code',
    'Gratitude Journal',
    'Informasi Pembayaran',
    'Notifikasi',
    'FAQ',
    'Cara Penggunaan',
    'Kebijakan Privasi',
    'Syarat dan Ketentuan',
    'Hubungi Kami',
    Platform.isAndroid ? ('Dukung Kami Playstore') : ('Dukung Kami AppStore'),
    // 'Theme (Developer Preview)',
  ];

  Future<void> onPress(String title, BuildContext context) async {
    switch (title) {
      case "Tentang Kalm":
        if (PRO.aboutResModel == null) {
          await PRO.getAboutUs();
          await pushNewScreen(context, screen: AboutUsPage());
        } else {
          await pushNewScreen(context, screen: AboutUsPage());
        }
        break;
      case "Akun":
        await pushNewScreen(context, screen: AccountPage());
        break;
      case "Profil":
        await pushNewScreen(context, screen: ProfilePage());
        break;
      case "Informasi Pembayaran":
        if (PRO.subscriptionListResModel != null) {
          await pushNewScreen(context, screen: PackagesPage());
        } else {
          await PRO.getSubSubcriptionList();
          await pushNewScreen(context, screen: PackagesPage());
        }
        break;
      case "FAQ":
        if (PRO.faqResModel == null) {
          await PRO.getFaq();
          await pushNewScreen(context, screen: FaqPage());
        } else {
          await pushNewScreen(context, screen: FaqPage());
        }
        break;
      case "Cara Penggunaan":
        if (PRO.howToResModel == null) {
          await PRO.getHowTo();
          await pushNewScreen(context, screen: HowToUsePage());
        } else {
          await pushNewScreen(context, screen: HowToUsePage());
        }
        break;
      case "Gratitude Journal":
        if (PRO.gratitudeJournalHistoryResModel == null) {
          await PRO.getGratitudeJournalHistory();
          await pushNewScreen(context, screen: GratitudeJournalHistoryPage());
        } else {
          await pushNewScreen(context, screen: GratitudeJournalHistoryPage());
        }
        break;
      case "Kebijakan Privasi":
        if (PRO.privacyPolicyResModel == null) {
          await PRO.getPrivacyPolicy();
          await pushNewScreen(context, screen: PrivacyPolicyPage());
        } else {
          await pushNewScreen(context, screen: PrivacyPolicyPage());
        }
        break;
      case "Syarat dan Ketentuan":
        if (PRO.termAndConditionResModel == null) {
          await PRO.getTermAndCondition();
          await pushNewScreen(context, screen: TermAndConditionPage());
        } else {
          await pushNewScreen(context, screen: TermAndConditionPage());
        }
        break;
      case "Hubungi Kami":
        if (PRO.contactUsResModel == null) {
          await PRO.getContactUs();
          await pushNewScreen(context, screen: ContactUsPage());
        } else {
          await pushNewScreen(context, screen: ContactUsPage());
        }
        break;
      case 'Dukung Kami Playstore':
        await GO_TO_STORE();
        break;
      case "Dukung Kami AppStore":
        await GO_TO_STORE();
        break;
      default:
        print("lain");
    }
  }
}

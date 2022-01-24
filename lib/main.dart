import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/main_tab.dart';
import 'package:kalm/pages/auth/login.dart';
import 'package:kalm/pages/auth/verify_code.dart';
import 'package:kalm/sdk/firebase.dart';
import 'package:kalm/splash_screen.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wonderpush_flutter/wonderpush_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (await GetStorage.init()) {
    await Firebase.initializeApp(
      options: Platform.isIOS ? iosFirebaseOption : androidFirebaseOption,
    );
    if (await WonderPush.isSubscribedToNotifications()) {
      runApp(MultiProvider(
        providers: [ChangeNotifierProvider<UserController>(create: (_) => UserController())],
        child: KalmApp(),
      ));
    } else {
      await WonderPush.subscribeToNotifications();
      runApp(MultiProvider(
        providers: [ChangeNotifierProvider<UserController>(create: (_) => UserController())],
        child: KalmApp(),
      ));
    }
  } else {
    runApp(_deviceNotCompatibleStorage());
  }
}

MaterialApp _deviceNotCompatibleStorage() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NON_MAIN_SAFE_AREA(
        child: SizedBox(
      height: Get.height,
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TEXT("Sorry your device not compatile with this app"),
          SPACE(),
          InkWell(
              onTap: () {
                exit(0);
              },
              child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 0.5, color: BLUEKALM)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("EXIT", style: TextStyle(color: BLUEKALM)),
                  )))
        ],
      ),
    )),
  );
}

class KalmApp extends StatelessWidget {
  final _controller = Get.put(KalmAppController());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      onReady: () async {
        await PRO.updateWording();
        PRO.readLocalUser();
        await PRO.updateSession(useLoading: false);
        await Future.microtask(() async {
          _starting();
        });
      },
      onInit: () async {
        if (Platform.isAndroid) {
          WebView.platform = SurfaceAndroidWebView();
        }
      },
      theme: ThemeData(
          textTheme: TextTheme(
        caption: TextStyle(
            fontFamily: "fonts/AlexBrush-Regular.ttf",
            fontSize: 16,
            color: Colors.blue[300],
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600),
        button: const TextStyle(
            fontFamily: "fonts/AlexBrush-Regular.ttf",
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600),
        bodyText1: const TextStyle(
            fontFamily: "fonts/AlexBrush-Regular.ttf", fontSize: 16, color: Colors.black54),
        bodyText2: const TextStyle(
            fontFamily: "fonts/AlexBrush-Regular.ttf",
            fontSize: 18,
            color: BLUEKALM,
            fontWeight: FontWeight.w600),
        headline1: const TextStyle(
            fontFamily: "fonts/AlexBrush-Regular.ttf",
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: BLUEKALM),
        headline2: const TextStyle(
            fontFamily: "fonts/AlexBrush-Regular.ttf",
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: BLUEKALM),
      )),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }

  void _starting() {
    if (PRO.userData != null) {
      if (PRO.userData?.status == 1) {
        Get.offAll(KalmMainTab());
      } else if (PRO.userData?.status == 5) {
        Get.offAll(VerifyCodePage());
      } else if (PRO.userData?.status == 2) {
        Get.offAll(KalmMainTab());
      } else {
        Get.offAll(LoginPage());
      }
    } else {
      Get.offAll(LoginPage());
    }
  }
}

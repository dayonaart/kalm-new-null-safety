import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/main_tab.dart';
import 'package:kalm/pages/auth/login.dart';
import 'package:kalm/pages/auth/verify_code.dart';
import 'package:kalm/pages/ors.dart';
import 'package:kalm/pages/setting_page/pin_code.dart';
import 'package:kalm/sdk/firebase.dart';
import 'package:kalm/splash_screen.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wonderpush_flutter/wonderpush_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _enableRotation();
  await _runApp();
}

void _enableRotation() {
  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}

Future<void> _runApp() async {
  if (await checkNetwork() == ConnectivityResult.none) {
    runApp(
        _deviceNotCompatible("Pastikan Anda terhubung ke Internet", "Coba Lagi", onTap: () async {
      await _runApp();
    }));
    return;
  }
  try {
    var _fireApp = await Firebase.initializeApp(
        name: "kalm",
        options: Platform.isIOS
            ? iosFirebaseOption
            : kIsWeb
                ? webFirebaseOption
                : androidFirebaseOption);
  } catch (e) {
    ERROR_SNACK_BAR('Perhatian', "$e");
    return;
  }
  if (!kIsWeb) await WonderPush.subscribeToNotifications();
  if (await GetStorage.init()) {
    if (kIsWeb) {
      runApp(MultiProvider(
        providers: [ChangeNotifierProvider<UserController>(create: (_) => UserController())],
        child: KalmApp(),
      ));
    } else {
      if (await WonderPush.isSubscribedToNotifications()) {
        if (kDebugMode) {
          WonderPush.setLogging(false);
        }
        runApp(MultiProvider(
          providers: [ChangeNotifierProvider<UserController>(create: (_) => UserController())],
          child: KalmApp(),
        ));
      } else {
        await WonderPush.subscribeToNotifications();
        if (kDebugMode) {
          WonderPush.setLogging(false);
        }
        runApp(MultiProvider(
          providers: [ChangeNotifierProvider<UserController>(create: (_) => UserController())],
          child: KalmApp(),
        ));
      }
    }
  } else {
    runApp(
        _deviceNotCompatible("Sorry your device not compatible with this app", "EXIT", onTap: () {
      exit(0);
    }));
  }
}

MaterialApp _deviceNotCompatible(String title, String buttonTitle, {void Function()? onTap}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NON_MAIN_SAFE_AREA(
        child: SizedBox(
      height: Get.height,
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (buttonTitle == "Coba Lagi")
            const Icon(Icons.wifi_off_outlined, size: 100)
          else
            const Icon(Icons.error_outline_outlined, size: 100),
          SPACE(),
          TEXT(title),
          SPACE(),
          InkWell(
              onTap: onTap,
              child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 0.5, color: BLUEKALM)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TEXT(buttonTitle),
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
        // await PRO.updateWording();
        PRO.readLocalUser();
        await PRO.firebaseSignin();
        await PRO.getOrsFirebase();
        await PRO.getSurvey();
        await PRO.updateSession(useLoading: false);
        await Future.microtask(() async {
          await STARTING();
        });
      },
      onInit: () async {
        if (!kIsWeb && Platform.isAndroid) {
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
      home: _splashScreen(),
    );
  }

  Stack _splashScreen() {
    return Stack(
      children: [
        SplashScreen(),
        if (PIN_LOCK != null) PincodePage(isLock: true, createCode: PIN_LOCK)
      ],
    );
  }
}

Future<void> STARTING({bool isLock = true}) async {
  if (PIN_LOCK != null && isLock) {
    return;
  } else {
    if (PRO.localOrs == null && PRO.userData == null) {
      await Get.offAll(SAFE_AREA(canBack: false, child: OrsPage(), bottomPadding: 0));
    } else {
      if (PRO.userData != null) {
        if (PRO.userData?.status == 1 || PRO.userData?.status == 2 || PRO.userData?.status == 3) {
          await Get.offAll(KalmMainTab());
        } else if (PRO.userData?.status == 5) {
          await Get.offAll(VerifyCodePage(resendCode: true));
        } else {
          await Get.offAll(LoginPage());
        }
      } else {
        await Get.offAll(LoginPage());
      }
    }
  }
}

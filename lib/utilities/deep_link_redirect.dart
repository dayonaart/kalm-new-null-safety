import 'dart:io';

import 'package:kalm/widget/snack_bar.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> launchUniversalLinkIos(String url) async {
  if (await canLaunch(url)) {
    final bool nativeAppLaunchSucceeded = await launch(url,
        forceSafariVC: false, universalLinksOnly: true, enableJavaScript: true);
    if (!nativeAppLaunchSucceeded) {
      await launch(url, forceSafariVC: false, enableJavaScript: true);
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<bool> launchInWebViewWithJavaScript(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
      enableJavaScript: true,
    );
    return true;
  } else {
    return false;
  }
}

Future<void> GO_TO_STORE({String? appId, bool writeReview = false}) async {
  try {
    if (Platform.isAndroid) {
      LaunchReview.launch(
          writeReview: writeReview, androidAppId: appId ?? "id.cranium.kalm");
    } else {
      try {
        LaunchReview.launch(
            writeReview: writeReview, iOSAppId: appId ?? "1440381889");
      } catch (e) {
        ERROR_SNACK_BAR("Perhatian", "$e");
      }
    }
  } catch (e) {
    ERROR_SNACK_BAR("Perhatian", "$e");
  }
}

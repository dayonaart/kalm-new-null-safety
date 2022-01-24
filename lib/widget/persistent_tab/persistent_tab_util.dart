import 'dart:io';
import 'package:flutter/cupertino.dart';

Future<Object?> pushNewScreen<T extends Object>(BuildContext context,
    {@required Widget? screen,
    bool withNavBar = true,
    bool platformSpecific = false}) {
  return Navigator.of(context, rootNavigator: !withNavBar)
      .push(CupertinoPageRoute(builder: (BuildContext context) => screen!));
}

Future<Object?> pushNewScreenName<T extends Object>(BuildContext context,
    {@required String? screen,
    Object? arguments,
    bool? withNavBar,
    bool platformSpecific = false}) {
  if (platformSpecific && withNavBar == null) {
    withNavBar = Platform.isAndroid ? false : true;
  } else {
    withNavBar ??= true;
  }
  // return Get.toNamed(screen);
  return Navigator.of(context, rootNavigator: !withNavBar)
      .pushNamed(screen!, arguments: arguments);
}

Future pushReplacementNewScreen<T extends Object>(BuildContext context,
    {@required Widget? screen,
    bool? withNavBar,
    bool platformSpecific = false}) {
  if (platformSpecific && withNavBar == null) {
    withNavBar = Platform.isAndroid ? false : true;
  } else {
    withNavBar ??= true;
  }
  return Navigator.of(context, rootNavigator: !withNavBar).pushReplacement(
      CupertinoPageRoute(builder: (BuildContext context) => screen!));
}

Future pushRemoveUntilScreen<T extends Object>(BuildContext context,
    {@required Widget? screen,
    bool? withNavBar,
    bool platformSpecific = false}) {
  if (platformSpecific && withNavBar == null) {
    withNavBar = Platform.isAndroid ? false : true;
  } else {
    withNavBar ??= true;
  }
  return Navigator.of(context, rootNavigator: !withNavBar).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (BuildContext context) => screen!),
      (_) => false);
}

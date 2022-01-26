import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';

SafeArea SAFE_AREA({Widget? child, bool canBack = true}) {
  return SafeArea(
    top: false,
    bottom: false,
    child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: canBack
              ? IconButton(
                  onPressed: () async => await Navigator.maybePop(Get.context!),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: BLUEKALM,
                  ))
              : null,
          backgroundColor: Colors.white,
          title: Image.asset("assets/icon/kalm.png", scale: 4),
          shadowColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Image.asset("assets/icon/bell.png", scale: 3)),
          ],
        ),
        body: Builder(builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: STATE(context).keyboardVisibility ? 0 : 75),
            child: child,
          );
        })),
    // minimum: EdgeInsets.only(bottom: 10),
  );
}

SafeArea NON_MAIN_SAFE_AREA({
  Widget? child,
  bool resizeBottomInset = true,
  PreferredSizeWidget? appBar,
  bool? top,
  bool? bottom,
  double? minimumInset,
}) {
  return SafeArea(
      top: top ?? false,
      bottom: bottom ?? false,
      child: Scaffold(
        appBar: appBar,
        body: Builder(builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: STATE(context).keyboardVisibility ? 0 : 38),
            child: child!,
          );
        }),
        resizeToAvoidBottomInset: resizeBottomInset,
      ));
}

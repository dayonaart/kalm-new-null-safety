import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/text.dart';

SafeArea SAFE_AREA({
  Widget? child,
  bool canBack = true,
  bool useAppBar = true,
  double? bottomPadding,
}) {
  return SafeArea(
    top: false,
    bottom: false,
    child: Scaffold(
        appBar: !useAppBar
            ? null
            : AppBar(
                centerTitle: true,
                leading: canBack
                    ? IconButton(
                        onPressed: () async =>
                            await Navigator.maybePop(Get.context!),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: BLUEKALM,
                        ))
                    : null,
                backgroundColor: Colors.white,
                title: Image.asset("assets/icon/kalm.png", scale: 4),
                shadowColor: Colors.transparent,
                actions: [
                  Builder(builder: (context) {
                    return IconButton(
                        onPressed: () {
                          pushNewScreen(context,
                              screen: NON_MAIN_SAFE_AREA(
                                  child: SizedBox(
                                width: Get.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TEXT("Belum ada notifikasi"),
                                  ],
                                ),
                              )));
                        },
                        icon: Image.asset("assets/icon/bell.png", scale: 3));
                  }),
                ],
              ),
        body: Builder(builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: STATE(context).keyboardVisibility
                    ? 0
                    : bottomPadding ?? 75),
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
  double? bottomPadding,
}) {
  return SafeArea(
      top: top ?? false,
      bottom: bottom ?? false,
      child: Scaffold(
        appBar: appBar,
        body: Builder(builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: STATE(context).keyboardVisibility
                    ? 0
                    : (bottomPadding ?? 38)),
            child: child!,
          );
        }),
        resizeToAvoidBottomInset: resizeBottomInset,
      ));
}

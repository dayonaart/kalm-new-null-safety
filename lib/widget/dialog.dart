import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

WillPopScope POP_SCREEN_DIALOG(
    {@required Widget? child, String? content, void Function()? onConfirm}) {
  return WillPopScope(
      child: child!,
      onWillPop: () async {
        if (onConfirm == null) {
          return true;
        } else {
          await SHOW_DIALOG(content, onAcc: onConfirm);
        }
        return false;
      });
}

Future SHOW_DIALOG(
  String? content, {
  Function()? onAcc,
  Widget? customButton,
  bool barrierDismissible = true,
}) async {
  await Get.dialog(
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: Get.width / 1.5,
              child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TEXT(content, textAlign: TextAlign.center),
                        SPACE(height: 20),
                        if (customButton != null)
                          customButton
                        else
                          Row(
                            mainAxisAlignment: !barrierDismissible
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              IconButton(
                                  icon: Image.asset(
                                    'assets/icon/accept.png',
                                  ),
                                  onPressed: onAcc),
                              !barrierDismissible
                                  ? Container()
                                  : IconButton(
                                      icon: Image.asset(
                                        'assets/icon/decline.png',
                                      ),
                                      onPressed: () => Get.back(),
                                    ),
                            ],
                          ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
      barrierDismissible: barrierDismissible);
}

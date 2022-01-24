import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/widget/text.dart';

TextField TEXT_FIELD(
  TextEditingController? editingController, {
  Widget? suffixIcon,
  Widget? prefixIcon,
  String? hint,
  FocusNode? focusNode,
  void Function(String)? onChanged,
  void Function(String)? onSubmitted,
  bool obscureText = false,
}) {
  return TextField(
    obscureText: obscureText,
    obscuringCharacter: '•',
    onSubmitted: onSubmitted,
    focusNode: focusNode,
    onChanged: onChanged,
    style: Get.textTheme.bodyText1,
    controller: editingController,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontFamily: "fonts/AlexBrush-Regular.ttf",
      ),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
    ),
  );
}

Widget ERROR_VALIDATION_FIELD(
  String? errorText, {
  double? textWidth,
  bool useOverFlow = true,
}) {
  if (errorText == null) {
    return Container();
  } else {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.red[400]),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: textWidth ?? (Get.width / 1.5),
              child: TEXT(errorText,
                  textOverflow: useOverFlow ? TextOverflow.ellipsis : null,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  )),
            ),
            const Icon(
              Icons.disabled_by_default_outlined,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

Widget SUCCESS_VALIDATION_FIELD(String? successText) {
  if (successText == null) {
    return Container();
  } else {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.green[400]),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: Get.width / 1.5,
              child: TEXT(successText,
                  textOverflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  )),
            ),
            const Icon(
              Icons.check_circle_outline_sharp,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

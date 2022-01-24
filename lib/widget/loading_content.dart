import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/widget/loading.dart';

Center get LOADING => Center(
    child: SizedBox(
        height: 100, width: 100, child: Loading().LOADING_ICON(Get.context!)));

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/faq_res_model/faq_data.dart';
import 'package:kalm/widget/box_border.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class FaqPage extends StatelessWidget {
  final _controller = Get.put(FaqController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FaqController>(builder: (_) {
      return SAFE_AREA(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SPACE(),
                TEXT("FAQ", style: Get.textTheme.headline2),
                SPACE(),
                Column(
                  children: List.generate(_.data()?.length ?? 0, (i) {
                    var _data = _.data()![i];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: InkWell(
                            onTap: () => _.onChangeOpen(i),
                            child: BOX_BORDER(
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TEXT(_data.name,
                                      style: COSTUM_TEXT_STYLE(
                                          color: _.openController![i]
                                              ? Colors.white
                                              : BLUEKALM,
                                          fonstSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                                fillColor: _.openController![i]
                                    ? BLUEKALM
                                    : Colors.white),
                          ),
                        ),
                        if (_.openController![i])
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                _data.descriptionChild?.length ?? 0, (j) {
                              var _dChild = _data.descriptionChild![j];
                              return Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: InkWell(
                                      onTap: () => _.onChildChangeOpen(i, j),
                                      child: BOX_BORDER(
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TEXT(_dChild.name,
                                                    style: COSTUM_TEXT_STYLE(
                                                        color:
                                                            _.openChildController![
                                                                    i]![j]
                                                                ? Colors.white
                                                                : BLUEKALM,
                                                        fonstSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                          fillColor:
                                              _.openChildController![i]![j]
                                                  ? ORANGEKALM
                                                  : Colors.white),
                                    ),
                                  ),
                                  if (_.openChildController![i]![j])
                                    BOX_BORDER(
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TEXT(_dChild.description,
                                                style: COSTUM_TEXT_STYLE(
                                                    color: Colors.white,
                                                    fonstSize: 16))),
                                        fillColor: GREENKALM)
                                ],
                              );
                            }),
                          )
                      ],
                    );
                  }),
                )
              ],
            ),
          )
        ],
      ));
    });
  }
}

class FaqController extends GetxController {
  List<FaqData>? data() {
    return PRO.faqResModel?.faqData;
  }

  late List<bool>? openController;

  void onChangeOpen(int i) {
    try {
      openController![i] = !openController![i];
      update();
    } catch (e) {
      ERROR_SNACK_BAR("Perhatian", "$e");
    }
  }

  late List<List<bool>?>? openChildController;
  void onChildChangeOpen(int i, int j) {
    try {
      openChildController![i]![j] = !openChildController![i]![j];
      update();
    } catch (e) {
      ERROR_SNACK_BAR("Perhatian", "$e");
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    openController = List.generate(data()?.length ?? 0, (i) => false);
    openChildController = List.generate(
        data()?.length ?? 0,
        (i) => List.generate(
            data()?[i].descriptionChild?.length ?? 0, (i) => false));
  }
}

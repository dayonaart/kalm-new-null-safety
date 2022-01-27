
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/indodana_res_model/payment.dart';
import 'package:kalm/utilities/date_format.dart';
import 'package:kalm/utilities/parse_to_currency.dart';
import 'package:kalm/widget/box_border.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class IndodanaPage extends StatelessWidget {
  final _controller = Get.put(IndodanaController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndodanaController>(builder: (_) {
      return SAFE_AREA(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Image.asset("assets/icon/indodana.png", scale: 5),
                SPACE(),
                Row(
                  children: List.generate(_.indodana()?.length ?? 0, (i) {
                    var _data = _.indodana()![i];
                    return BUTTON("${_data.tenure} Bulan",
                        isExpanded: true,
                        expandedHorizontalPad: 5,
                        onPressed: () => _.onOpenTenure(i),
                        backgroundColor: _.openTenureController[i]
                            ? ORANGEKALM
                            : Colors.grey);
                  }),
                ),
                _tenureList(_),
                BUTTON("Selanjutnya",
                    onPressed: () async => await PRO.indodanaDeeplink(context,
                        installmentId: _.tenureList()?.id))
              ],
            ),
          )
        ],
      ));
    });
  }

  Column _tenureList(IndodanaController _) {
    return Column(
      children: List.generate(_.tenureList()?.tenure ?? 0, (i) {
        var _data = _.tenureList();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: BOX_BORDER(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.white,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TEXT('Jatuh Tempo',
                                style: COSTUM_TEXT_STYLE(color: Colors.white)),
                            TEXT(
                                DATE_FORMAT(DateTime.now()
                                    .add(Duration(days: (30 * (i + 1))))),
                                style: COSTUM_TEXT_STYLE(color: Colors.white)),
                          ],
                        )
                      ],
                    ),
                    TEXT("TOTAL Rp. ${CURRENCY(_data?.monthlyInstallment)}",
                        style: COSTUM_TEXT_STYLE(color: Colors.white)),
                  ],
                ),
              ),
              fillColor: BLUEKALM),
        );
      }),
    );
  }

  Column _tt(IndodanaController _) {
    return Column(
      children: List.generate(_.indodana()?.length ?? 0, (i) {
        var _data = _.indodana()![i];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TEXT(_data.toJson().toString()),
        );
      }),
    );
  }
}

class IndodanaController extends GetxController {
  List<Payment>? indodana() {
    return PRO.indodanaResModel?.indodana?.payments;
  }

  Payment? tenureList() {
    try {
      var _openIndex = openTenureController.indexWhere((e) => e);
      return PRO.indodanaResModel?.indodana?.payments![_openIndex];
    } catch (e) {
      return null;
    }
  }

  List<bool> openTenureController = List.generate(
      PRO.indodanaResModel?.indodana?.payments?.length ?? 0, (i) => false);

  void onOpenTenure(int i) {
    for (var j = 0; j < openTenureController.length; j++) {
      if (i == j) {
        if (openTenureController[j]) {
          openTenureController[j] = false;
        } else {
          openTenureController[j] = true;
        }
      } else {
        openTenureController[j] = false;
      }
    }
    update();
  }
}

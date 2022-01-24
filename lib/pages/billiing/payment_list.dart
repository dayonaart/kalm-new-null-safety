import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/payment_list_res_model/payment_data.dart';
import 'package:kalm/pages/billiing/bank_transfer.dart';
import 'package:kalm/pages/billiing/gopay.dart';
import 'package:kalm/pages/billiing/indodana.dart';
import 'package:kalm/pages/billiing/shopee.dart';
import 'package:kalm/utilities/bank_properties.dart';
import 'package:kalm/widget/box_border.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'dart:math' as math;

class PaymentListPage extends StatelessWidget {
  final _controller = Get.put(PaymentListController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentListController>(builder: (_) {
      return SAFE_AREA(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                TEXT("Pilih Metode Pembayaran", style: Get.textTheme.headline1),
                SPACE(height: 20),
                Column(
                  children: List.generate(_.data(context)!.length, (i) {
                    var _name = _.data(context, isListen: false)![i].name!;
                    return InkWell(
                      onTap: () async => await _.submit(context, _name),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: BOX_BORDER(
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Image.asset(
                                    "assets/icon/${_.data(context)![i].name!.toLowerCase()}.png",
                                    height: 70,
                                    width: 70),
                                SPACE(width: 20),
                                TEXT(_.desc(
                                    _.data(context)![i].name!.toLowerCase())),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ));
    });
  }
}

class PaymentListController extends GetxController {
  List<PaymentData>? data(BuildContext context, {bool isListen = true}) {
    if (bankName(context, isListen: isListen) != null) {
      return STATE(context, isListen: isListen)
          .paymentListResModel!
          .paymentData!
          .where((e) {
        return e.name?.toUpperCase() == bankName(context, isListen: isListen);
      }).toList();
    } else {
      return STATE(context, isListen: isListen)
          .paymentListResModel!
          .paymentData!;
    }
  }

  String desc(String name) {
    switch (name == "ovo" ||
        name == "shopee" ||
        name == "credit card" ||
        name == "gopay" ||
        name == "indodana") {
      case true:
        if (name == "indodana") {
          return "Paylater from $name";
        } else {
          return "Pay from $name";
        }
      case false:
        return "Pay from $name ATMs\nor Internet Banking";
      default:
        return name;
    }
  }

  Future<void> submit(BuildContext context, String paymentName) async {
    // print(PRO.pendingPaymentResModel?.pendingData?.otherResponse?.toJson());
    if (bankName(context, isListen: false) != null) {
      if (bankName(context, isListen: false) == "GOPAY") {
        await pushNewScreen(context, screen: GopayPage());
      } else if (bankName(context, isListen: false) == "SHOPEE") {
        await pushNewScreen(context, screen: ShopeePage());
      } else if (bankName(context, isListen: false) == "INDODANA") {
        await PRO.indodanaDeeplink(context);
      } else {
        await pushNewScreen(context, screen: BankTransferPage());
      }
    } else {
      await PRO.submitPayment(paymentName, context);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/pending_payment_res_model/pending_data.dart';
import 'package:kalm/pages/billiing/payment_list.dart';
import 'package:kalm/utilities/date_format.dart';
import 'package:kalm/utilities/parse_to_currency.dart';
import 'package:kalm/widget/box_border.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class PaymentDetailPage extends StatelessWidget {
  final _controller = Get.put(PaymentDetailController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentDetailController>(builder: (_) {
      return SAFE_AREA(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Builder(builder: (context) {
              if (STATE(context).pendingPaymentResModel?.pendingData == null) {
                return SizedBox(
                  height: Get.height / 1.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TEXT('Terima kasih telah melakukan transaksi dengan KALM',
                          textAlign: TextAlign.center,
                          style: Get.textTheme.headline2),
                    ],
                  ),
                );
              } else {
                return _detailPackages(_, context);
              }
            }),
          )
        ],
      ));
    });
  }

  Column _detailPackages(PaymentDetailController _, BuildContext context) {
    return Column(
      children: [
        TEXT(
            'Terima kasih telah membeli paket\nberlangganan konseling dengan KALM\nberikut rincian pesanan Anda',
            textAlign: TextAlign.center),
        SPACE(height: 20),
        Builder(builder: (context) {
          try {
            return _detail(_, context);
          } catch (e) {
            return Container();
          }
        }),
        SPACE(height: 20),
        TEXT("INSTUKSI PEMBAYARAN", style: COSTUM_TEXT_STYLE(fonstSize: 20)),
        SPACE(),
        TEXT("Lakukan pembayaran dengan mengklik\ntombol berikut",
            textAlign: TextAlign.center, style: COSTUM_TEXT_STYLE()),
        SPACE(),
        SizedBox(
          width: Get.width / 1.3,
          child: Column(
            children: [
              BUTTON('Bayar', onPressed: () async {
                await PRO.getPaymentList();
                await pushNewScreen(context, screen: PaymentListPage());
              }, verticalPad: 12, circularRadius: 30),
              SPACE(height: 5),
              BUTTON('Batalkan', onPressed: () async {
                await PRO.cancelPayment();
                Navigator.pop(context);
              }, verticalPad: 12, circularRadius: 30),
            ],
          ),
        ),
      ],
    );
  }

  Container _detail(PaymentDetailController _, BuildContext context) {
    return BOX_BORDER(Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          SPACE(),
          _item("assets/icon/box.png", _.data(context).name!),
          SPACE(),
          const Divider(thickness: 1),
          SPACE(),
          _item("assets/icon/dollar.png",
              "Rp. ${CURRENCY(_.data(context).package?.price)}"),
          SPACE(),
          const Divider(thickness: 1),
          SPACE(),
          _item("assets/icon/clock.png",
              "${DATE_FORMAT(DateTime.parse(_.data(context).startAt!), pattern: "dd MMM")} - ${DATE_FORMAT(DateTime.parse(_.data(context).endAt!), pattern: "dd MMM y")!}"),
          SPACE(),
        ],
      ),
    ));
  }

  Row _item(String asseticon, String desc) {
    return Row(
      children: [
        Image.asset(asseticon, scale: 2),
        SPACE(width: 20),
        TEXT(desc),
      ],
    );
  }
}

class PaymentDetailController extends GetxController {
  PendingData data(BuildContext context) =>
      STATE(context).pendingPaymentResModel!.pendingData!;
}

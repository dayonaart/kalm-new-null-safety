import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/ovo_res_model/ovo_res_model.dart';
import 'package:kalm/utilities/parse_to_currency.dart';
import 'package:kalm/widget/box_border.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/loading.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'package:kalm/widget/textfield.dart';

class OvoPage extends StatelessWidget {
  final _controller = Get.put(OvoController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OvoController>(
        dispose: (ds) {
          if (_controller.streamSubscription != null) {
            _controller.streamSubscription?.cancel();
          }
          _controller.phoneController.clear();
        },
        initState: (st) {},
        builder: (_) {
          // print(PRO.pendingPaymentResModel?.pendingData?.toJson());
          return SAFE_AREA(
              child: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: [
                    Image.asset("assets/icon/ovo.png", scale: 8),
                    SPACE(height: 20),
                    if (_.response(context) != null) _detailPayment(_, context),
                    Column(
                      children: [
                        SPACE(),
                        _phoneField(_, context),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ));
        });
  }

  Container _phoneField(OvoController _, BuildContext context) {
    return BOX_BORDER(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: CupertinoTextField(
                focusNode: _.focusNode,
                onChanged: (val) => _.onChangePhone(val),
                controller: _.phoneController,
                placeholder: '08xxxxx',
                maxLength: 13,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                prefix: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TEXT("No HP : "),
                ),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: BLUEKALM),
                    borderRadius: BorderRadius.circular(10))),
          ),
          if (_.phoneController.text.length > 1 && !_.validationField)
            Column(
              children: [
                SPACE(),
                ERROR_VALIDATION_FIELD("Nomor Hp tidak valid"),
              ],
            ),
          SPACE(),
          SizedBox(
            width: Get.width / 1.8,
            child: Column(
              children: [
                BUTTON('Selanjutnya',
                    onPressed: _.validationField
                        ? () async => await _.submit(context)
                        : null),
                BUTTON('Kembali', onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }),
              ],
            ),
          )
        ],
      ),
    ));
  }

  Column _detailPayment(OvoController _, BuildContext context) {
    return Column(
      children: [
        _totalPayment(_),
        SPACE(),
        _transactionTime(_, context),
      ],
    );
  }

  Container _transactionTime(OvoController _, BuildContext context) {
    return BOX_BORDER(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_.loadingCheck &&
                  _.response(context)?.data?.status != "FAILED")
                TEXT("Menunggu pembayaran"),
              TEXT(_.response(context)?.data?.status),
            ],
          ),
          if (_.response(context) != null)
            BUTTON("Cek Status", onPressed: () async {
              _.setLoading(true);
              await PRO.ovoGet();
              _.setLoading(false);
              if ((_.response(context, listen: false) != null) &&
                  _.response(context, listen: false)?.data?.status ==
                      "FAILED") {
                await Future.delayed(const Duration(seconds: 1));
                await PRO.cancelPayment();
                Navigator.pop(context);
                Navigator.pop(context);
              } else if (_.response(context, listen: false) == null) {
                await Future.delayed(const Duration(seconds: 1));
                await PRO.cancelPayment();
                Navigator.pop(context);
                Navigator.pop(context);
              }
              // debugPrint("${_.response(context, listen: false)?.toJson()}",
              //     wrapWidth: 1024);
            })
        ],
      ),
    ));
  }

  Container _totalPayment(OvoController _) {
    return BOX_BORDER(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TEXT("Total Pembayaran"),
              SPACE(),
              Builder(builder: (context) {
                try {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TEXT(
                          "Rp. ${CURRENCY(_.response(context)!.data!.amount!)}",
                          style: Get.textTheme.headline1),
                      SPACE(),
                    ],
                  );
                } catch (e) {
                  return TEXT('Pembayaran Gagal atau waktu habis',
                      style: COSTUM_TEXT_STYLE(
                          fontWeight: FontWeight.bold, color: ORANGEKALM));
                }
              }),
            ],
          ),
          if (_.loadingCheck) const CupertinoActivityIndicator(radius: 20)
        ],
      ),
    ));
  }
}

class OvoController extends GetxController {
  StreamSubscription<DateTime?>? streamSubscription;
  TextEditingController phoneController = TextEditingController();
  FocusNode focusNode = FocusNode();
  OvoResModel? response(BuildContext context, {bool listen = true}) {
    return STATE(context, isListen: listen).ovoResModel;
  }

  bool validationField = false;
  void onChangePhone(String val) {
    if (val.length >= 11) {
      validationField = true;
    } else {
      validationField = false;
    }
    update();
  }

  bool loadingCheck = false;
  void setLoading(bool loading) {
    loadingCheck = loading;
    update();
  }

  Future<void> submit(BuildContext context) async {
    focusNode.unfocus();
    await PRO.ovoCreate(phoneController.text, context);
    Loading.hide();
    if (response(context, listen: false) != null) {
    } else {
      return;
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/assign_voucher_res_model/assign_voucher_data.dart';
import 'package:kalm/model/assign_voucher_res_model/assign_voucher_res_model.dart';
import 'package:kalm/model/voucher_res_model/voucher_res_model.dart';
import 'package:kalm/utilities/text_input_formatter.dart';
import 'package:kalm/widget/box_border.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/dialog.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class VoucherPage extends StatelessWidget {
  final _controller = Get.put(VoucherController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VoucherController>(dispose: (d) {
      _controller.voucherResModel = null;
    }, builder: (_) {
      return SAFE_AREA(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: _.assignVoucherData == null ? Get.height / 1.5 : null,
              width: Get.width,
              child: Column(
                mainAxisAlignment: _.assignVoucherData == null
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Image.asset("assets/icon/voucher.png"),
                  SPACE(height: 20),
                  TEXT("Masukan Kode Gift Voucher"),
                  SizedBox(
                    height: 50,
                    child: CupertinoTextField(
                      placeholder: "XXXXX-XX-XX-XX-XX",
                      style: Get.textTheme.headline1,
                      focusNode: _.focusNode,
                      controller: _.voucherController,
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        CustomInputFormatter(mask: "xxxxx-xx-xx-xx-xx", separator: "-")
                      ],
                      textAlignVertical: TextAlignVertical.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: BLUEKALM),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SPACE(),
                  SizedBox(
                      width: Get.width / 1.5,
                      child: BUTTON("Selanjutnya",
                          onPressed: () async => await _.checkVoucher(),
                          verticalPad: 10,
                          circularRadius: 30)),
                  if (_.assignVoucherData != null)
                    Column(
                      children: [
                        SPACE(),
                        BOX_BORDER(Column(
                          children: [
                            Image.asset('assets/icon/voucher-success.png'),
                            SPACE(),
                            TEXT("Selamat Voucher Anda telah aktif"),
                            SPACE(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BOX_BORDER(Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TEXT(
                                        "Aktif Sampai dengan : ${_.assignVoucherData?.original?.packageEndAt}",
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              )),
                            ),
                          ],
                        )),
                      ],
                    )
                ],
              ),
            ),
          ),
        ],
      ));
    });
  }
}

class VoucherController extends GetxController {
  VoucherResModel? voucherResModel;
  AssignVoucherData? assignVoucherData;
  TextEditingController voucherController = TextEditingController();
  FocusNode focusNode = FocusNode();
  get activeVoucher {
    try {
      return (DateTime.parse(voucherResModel!.voucherData!.endAt!)
              .difference(DateTime.parse(voucherResModel!.voucherData!.startAt!)))
          .inDays;
    } catch (e) {
      return null;
    }
  }

  Future<void> checkVoucher() async {
    focusNode.unfocus();
    var _res = await Api().GET(CHECK_VOUCHER(voucherController.text), useToken: true);
    if (_res?.statusCode == 200) {
      voucherResModel = VoucherResModel.fromJson(_res?.data);
      update();
      await SHOW_DIALOG(
          "Apakah Anda ingin menggunakan Voucher\n${voucherResModel?.voucherData?.code}",
          onAcc: () async {
        await assignVoucher();
        Get.back();
      });
    } else {
      assignVoucherData = null;
      voucherResModel = null;
      update();
      return;
    }
  }

  Future<void> assignVoucher() async {
    var _res = await Api().POST(ASSIGN_VOUCHER, {"code": voucherController.text}, useToken: true);
    if (_res?.statusCode == 200) {
      assignVoucherData = AssignVoucherResModel.fromJson(_res?.data).assignVoucherData;
      update();
    } else {
      assignVoucherData = null;
      update();
      return;
    }
  }
}

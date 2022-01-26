import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/promo_res_model/promo_res_model.dart';
import 'package:kalm/model/subscription_list_res_model/subscription_data.dart';
import 'package:kalm/model/subscription_payload.dart';
import 'package:kalm/pages/billiing/payment_detail.dart';
import 'package:kalm/pages/voucher.dart';
import 'package:kalm/utilities/date_format.dart';
import 'package:kalm/utilities/parse_to_currency.dart';
import 'package:kalm/widget/box_border.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/dialog.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class PackagesPage extends StatelessWidget {
  final _controller = Get.put(PackagesController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PackagesController>(initState: (st) async {
      await PRO.getPendingPayment(useSnackbar: false);
    }, builder: (_) {
      // print("total ${Get.width} : remaining ${_.containerPackageWidth(context)}");
      return SAFE_AREA(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                if (_.optionIndex == 0)
                  Column(
                    children: [
                      SPACE(height: 10),
                      _voucherButton(context),
                    ],
                  ),
                SPACE(height: 10),
                TEXT('JENIS PAKET', style: COSTUM_TEXT_STYLE(fonstSize: 25)),
                SPACE(height: 20),
                _option(_),
                SPACE(),
                if (_.optionIndex == 0)
                  Column(
                    children: [
                      _subscription(_),
                      SPACE(),
                      SizedBox(
                          width: Get.width / 1.5,
                          child: BUTTON("Selanjutnya",
                              onPressed: _.validationSubscription
                                  ? () async => await _.submit(context)
                                  : null,
                              verticalPad: 12,
                              circularRadius: 30)),
                    ],
                  ),
                if (_.optionIndex == 1)
                  Builder(builder: (context) {
                    if (STATE(context).userData!.userSubscriptionList!.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TEXT("Anda belum memiliki paket berlangganan",
                            style: Get.textTheme.headline1, textAlign: TextAlign.center),
                      );
                    } else {
                      return _content(_);
                    }
                  }),
              ],
            ),
          )
        ],
      ));
    });
  }

  InkWell _voucherButton(BuildContext context) {
    return InkWell(
      onTap: () async => await pushNewScreen(context, screen: VoucherPage()),
      child: SizedBox(
        width: Get.width / 1.5,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            BOX_BORDER(
                Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TEXT("Voucher",
                          style: COSTUM_TEXT_STYLE(
                              color: Colors.white, fontWeight: FontWeight.bold, fonstSize: 20)),
                    )),
                height: 50,
                circularRadius: 50,
                fillColor: const Color(0xFFE6B363)),
            BOX_BORDER(Image.asset("assets/icon/voucher.png", scale: 4),
                circularRadius: 50, height: 70, width: 70, fillColor: Colors.white),
          ],
        ),
      ),
    );
  }

  Column _content(PackagesController _) {
    return Column(
      children: [
        TEXT("Informasi Tagihan Saya", style: COSTUM_TEXT_STYLE(fonstSize: 20)),
        SPACE(),
        Builder(builder: (context) {
          if (_.remainingActivePackageDay(context) != null) {
            return Column(
              children: [
                _remainingDays(_, context),
                SPACE(),
              ],
            );
          } else {
            return Container();
          }
        }),
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: BLUEKALM),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(builder: (context) {
              try {
                return Column(
                  children: [
                    if (STATE(context).pendingPaymentResModel?.pendingData != null)
                      _pendingPackages(context, _),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SPACE(),
                        _activePackages(context, _),
                      ],
                    ),
                  ],
                );
              } catch (e) {
                return Container();
              }
            }),
          ),
        )
      ],
    );
  }

  Column _remainingDays(PackagesController _, BuildContext context) {
    return Column(
      children: [
        SPACE(),
        BOX_BORDER(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TEXT("${(_.remainingActivePackageDay(context)!.toInt())} Hari Tersisa"),
                SPACE(),
                BOX_BORDER(
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BOX_BORDER(Container(),
                              width: _.remainingActivePackageDay(context),
                              fillColor: BLUEKALM,
                              circularRadius: 10,
                              height: 25),
                        ],
                      ),
                    ),
                    height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  GridView _activePackages(BuildContext context, PackagesController _) {
    return GridView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
      children: List.generate(STATE(context).userData!.userSubscriptionList!.length, (i) {
        var _data = STATE(context).userData!.userSubscriptionList!;
        return Container(
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: BLUEKALM),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Container(
                width: Get.width,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: TEXT(_.packageStatus(_data[i]?.status),
                        style: COSTUM_TEXT_STYLE(color: Colors.white)),
                  ),
                ),
                decoration: const BoxDecoration(
                    color: BLUEKALM,
                    borderRadius: BorderRadiusDirectional.only(
                        topEnd: Radius.circular(10), topStart: Radius.circular(10))),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/icon/box.png', scale: 5),
                        SPACE(),
                        TEXT(_data[i]?.name)
                      ],
                    ),
                    SPACE(),
                    _packageDate(_data[i]!.startAt!, _data[i]!.endAt!, true),
                    SPACE(height: 3),
                    _packageDate(_data[i]!.startAt!, _data[i]!.endAt!, false),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  InkWell _pendingPackages(BuildContext context, PackagesController _) {
    return InkWell(
      onTap: () async => await pushNewScreen(context, screen: PaymentDetailPage()),
      child: GridView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
        children: List.generate(1, (i) {
          var _data = STATE(context).pendingPaymentResModel!;
          return Container(
            decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: BLUEKALM),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Container(
                  width: Get.width,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: TEXT(_.packageStatus(_data.pendingData?.status),
                          style: COSTUM_TEXT_STYLE(color: Colors.white)),
                    ),
                  ),
                  decoration: const BoxDecoration(
                      color: BLUEKALM,
                      borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(10), topStart: Radius.circular(10))),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/icon/box.png', scale: 5),
                          SPACE(),
                          TEXT(_data.pendingData?.name)
                        ],
                      ),
                      SPACE(),
                      _packageDate(_data.pendingData!.startAt!, _data.pendingData!.endAt!, true),
                      SPACE(height: 3),
                      _packageDate(_data.pendingData!.startAt!, _data.pendingData!.endAt!, false),
                    ],
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Card _packageDate(String start, String end, bool isStart) {
    return Card(
      color: isStart ? BLUEKALM : ORANGEKALM,
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TEXT(isStart ? 'Mulai' : "Berakhir",
                style: COSTUM_TEXT_STYLE(color: Colors.white, fonstSize: 12)),
            SPACE(height: 5),
            SizedBox(
              width: Get.width,
              child: TEXT(
                  isStart ? DATE_FORMAT(DateTime.parse(start)) : DATE_FORMAT(DateTime.parse(end)),
                  style: COSTUM_TEXT_STYLE(color: Colors.white, fonstSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  ListView _subscription(PackagesController _) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: List.generate(PRO.subscriptionListResModel!.subscriptionData!.length, (i) {
        var _sub = PRO.subscriptionListResModel!.subscriptionData!;
        return Column(
          children: [
            InkWell(
              onTap: () => _.onChangeSubController(i),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: _.openSubController[i] ? BLUEKALM : Colors.grey[400]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TEXT(_sub[i].name, style: COSTUM_TEXT_STYLE(color: Colors.white)),
                      TEXT("BERLANGGANAN", style: COSTUM_TEXT_STYLE(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            if (_.openSubController[i]) _subscriptionBox(_sub, i, _),
            SPACE(),
          ],
        );
      }),
    );
  }

  Container _subscriptionBox(List<SubscriptionData> _sub, int i, PackagesController _) {
    return Container(
      width: Get.width / 1.2,
      decoration: BoxDecoration(
          border: Border.all(color: BLUEKALM),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(_sub[i].note!.length, (j) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment:
                        j != 0 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: BLUEKALM,
                        radius: 15,
                        child: TEXT("${j + 1}", style: COSTUM_TEXT_STYLE(color: Colors.white)),
                      ),
                      SPACE(),
                      if (_.promoResModel?.promoData != null && j == 2)
                        TEXT("Total biaya Rp. ${CURRENCY(_.promoResModel?.promoData?.finalAmount)}")
                      else if (_.promoResModel?.promoData != null && j == 1)
                        TEXT(_sub[i].note![j],
                            style: const TextStyle(decoration: TextDecoration.lineThrough))
                      else
                        TEXT(_sub[i].note![j])
                    ],
                  ),
                );
              }),
            ),
            if (_.promoResModel?.promoData != null)
              Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TEXT(
                        "Anda mendapatkan potongan sebesar Rp. ${_.promoResModel?.promoData?.value}",
                        style: COSTUM_TEXT_STYLE(color: ORANGEKALM, fonstSize: 11)),
                    SPACE(height: 5),
                    TEXT(_.promoResModel?.promoData?.note),
                  ],
                ),
              )),
            SPACE(),
            _promoField(_, i),
            SPACE(),
            InkWell(
              onTap: () => _.onChangeCheckBox(i, _sub[i]),
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: BLUEKALM),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                          decoration: BoxDecoration(
                              color: _.checkBoxController[i] ? ORANGEKALM : Colors.white,
                              border: Border.all(width: 0.5, color: BLUEKALM),
                              borderRadius: BorderRadius.circular(3))),
                    ),
                  ),
                  SPACE(),
                  SizedBox(
                    width: Get.width / 1.5,
                    child: TEXT("Saya ingin berlangganan paket ini",
                        textOverflow: TextOverflow.ellipsis),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  CupertinoTextField _promoField(PackagesController _, int i) {
    return CupertinoTextField(
      focusNode: _.promoFocus[i],
      textCapitalization: TextCapitalization.characters,
      suffix: InkWell(
        onTap: () async => await _.checkPromo(i),
        child: Row(
          children: [
            if (_.loadingPromo[i]) const CupertinoActivityIndicator(radius: 10),
            Card(
              color: BLUEKALM,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TEXT("Add", style: COSTUM_TEXT_STYLE(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      controller: _.promoController[i],
      style: COSTUM_TEXT_STYLE(color: Colors.white),
      placeholderStyle: COSTUM_TEXT_STYLE(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      placeholder: 'Masukan Kode Promo',
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.grey[400]),
    );
  }

  Row _option(PackagesController _) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: InkWell(
            onTap: () async => await _.onChangeOption(0),
            child: Container(
                decoration: BoxDecoration(
                    color: _.optionIndex == 0 ? ORANGEKALM : Colors.grey[400],
                    borderRadius: const BorderRadiusDirectional.only(
                        topStart: Radius.circular(25), bottomStart: Radius.circular(25))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  child: Center(
                      child: TEXT("KONSELING",
                          style:
                              COSTUM_TEXT_STYLE(color: Colors.white, fontWeight: FontWeight.w600))),
                )),
          ),
        ),
        SPACE(width: 10),
        Expanded(
          child: InkWell(
            onTap: () async => await _.onChangeOption(1),
            child: Container(
                decoration: BoxDecoration(
                    color: _.optionIndex == 1 ? ORANGEKALM : Colors.grey[400],
                    borderRadius: const BorderRadiusDirectional.only(
                        topEnd: Radius.circular(25), bottomEnd: Radius.circular(25))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  child: Center(
                      child: TEXT("KONTEN",
                          style:
                              COSTUM_TEXT_STYLE(color: Colors.white, fontWeight: FontWeight.w600))),
                )),
          ),
        ),
      ],
    );
  }
}

class PackagesController extends GetxController {
  bool get validationSubscription =>
      subscriptionPayload != null &&
      checkBoxController.contains(true) &&
      openSubController.contains(true);
  SubscriptionPayload? subscriptionPayload;
  PromoResModel? promoResModel;
  List<FocusNode> promoFocus =
      List.generate(PRO.subscriptionListResModel!.subscriptionData!.length, (i) {
    return FocusNode();
  });
  List<TextEditingController> promoController =
      List.generate(PRO.subscriptionListResModel!.subscriptionData!.length, (i) {
    return TextEditingController();
  });
  int optionIndex = 0;
  List<bool> openSubController =
      List.generate(PRO.subscriptionListResModel!.subscriptionData!.length, (i) {
    return false;
  });
  List<bool> checkBoxController =
      List.generate(PRO.subscriptionListResModel!.subscriptionData!.length, (i) {
    return false;
  });

  int? activePackageDay(BuildContext context) {
    try {
      DateTime _start =
          DateTime.parse(STATE(context).userData!.userSubscriptionList!.first!.startAt!);
      DateTime _end = DateTime.parse(STATE(context).userData!.userSubscriptionList!.last!.endAt!);
      return _end.difference(_start).inDays;
    } catch (e) {
      return null;
    }
  }

  double? remainingActivePackageDay(BuildContext context) {
    try {
      DateTime _end = DateTime.parse(STATE(context).userData!.userSubscriptionList!.last!.endAt!);
      return _end.difference(DateTime.now()).inDays.toDouble();
    } catch (e) {
      return null;
    }
  }

  double? containerPackageWidth(BuildContext context) {
    return activePackageDay(context)!.toDouble() / Get.width * Get.width;
  }

  Future<void> onChangeOption(int i) async {
    optionIndex = i;
    update();
    if (i == 1) {
      await PRO.getSubSubcriptionList(useLoading: false);
    }
  }

  void onChangeCheckBox(int i, SubscriptionData sub) {
    checkBoxController[i] = !checkBoxController[i];
    subscriptionPayload =
        SubscriptionPayload(subscriptionId: sub.id, promoCode: promoResModel?.promoData?.code);
    update();
  }

  void onChangeSubController(int i) {
    for (var j = 0; j < openSubController.length; j++) {
      if (j == i) {
        if (openSubController[j]) {
          openSubController[j] = false;
          checkBoxController[j] = false;
          promoResModel = null;
        } else {
          openSubController[j] = true;
        }
      } else {
        openSubController[j] = false;
        checkBoxController[j] = false;
        promoResModel = null;
      }
    }

    update();
  }

  String? packageStatus(int? status) {
    switch (status) {
      case 1:
        return "Aktif";
      default:
        return "Pending";
    }
  }

  Future<void> submit(BuildContext context) async {
    // debugPrint(jsonEncode(subscriptionPayload?.toJson()), wrapWidth: 1024);
    if (PRO.pendingPaymentResModel?.pendingData != null) {
      SHOW_DIALOG("Anda masih memiliki pembayaran yang belum selesai\nLajutkan", onAcc: () async {
        _clearValidation();
        update();
        Get.back();
        promoController.map((e) => e.clear()).toList();
        await pushNewScreen(context, screen: PaymentDetailPage());
      });
    } else {
      var _res = await Api().POST(USER_SUBSCRIBE, subscriptionPayload?.toJson(), useToken: true);
      if (_res?.statusCode == 200) {
        _clearValidation();
        update();
        promoController.map((e) => e.clear()).toList();
        await PRO.getPendingPayment(useLoading: true);
        await pushNewScreen(context, screen: PaymentDetailPage());
      } else {
        return;
      }
    }
  }

  void _clearValidation() {
    subscriptionPayload = null;
    promoResModel = null;
    var _checkIndex = checkBoxController.indexWhere((e) => e);
    checkBoxController[_checkIndex] = false;
  }

  List<bool> loadingPromo =
      List.generate(PRO.subscriptionListResModel!.subscriptionData!.length, (i) => false);

  Future<void> checkPromo(int i) async {
    if (promoController[i].text.isEmpty) {
      return;
    } else {
      loadingPromo[i] = true;
      update();
      var _res = await Api().GET(
          PROMO_CHECK(
              subsId: PRO.subscriptionListResModel?.subscriptionData?[i].id?.toString(),
              promo: promoController[i].text),
          useToken: true,
          useLoading: false);
      if (_res?.statusCode == 200) {
        loadingPromo[i] = false;
        promoResModel = PromoResModel.fromJson(_res?.data);
        if (promoResModel?.promoData == null) {
          ERROR_SNACK_BAR("Perhatian", promoResModel?.message);
        }
        update();
      } else {
        loadingPromo[i] = false;
        update();
        return;
      }
    }
    promoFocus.map((e) => e.unfocus()).toList();
  }
}

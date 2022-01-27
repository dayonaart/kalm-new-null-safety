import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/pending_payment_res_model/pending_data.dart';
import 'package:kalm/model/tutorial_bank_model/tutorial_bank_model.dart';
import 'package:kalm/utilities/bank_properties.dart';
import 'package:kalm/utilities/clipboard.dart';
import 'package:kalm/utilities/date_format.dart';
import 'package:kalm/utilities/html_style.dart';
import 'package:kalm/utilities/parse_to_currency.dart';
import 'package:kalm/widget/box_border.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'dart:math' as math;

class BankTransferPage extends StatelessWidget {
  final _controller = Get.put(BankTranferController());
  late StreamSubscription<DateTime?>? streamSubscription;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankTranferController>(dispose: (ds) {
      if (streamSubscription != null) {
        streamSubscription?.cancel();
      }
    }, initState: (st) {
      streamSubscription = _controller.stream().listen((event) {
        _controller.setTransactionTime(PRO
            .pendingPaymentResModel?.pendingData?.otherResponse?.transactionTime
            ?.add(const Duration(days: 1))
            .difference(DateTime.now()));
      });
      _controller.getTutorial(context);
    }, builder: (_) {
      return SAFE_AREA(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                _transactionTime(_, context),
                SPACE(),
                _bank(_, context),
                SPACE(),
                _virtualAccount(_, context),
                SPACE(),
                _totalPayment(_, context),
                SPACE(),
                _tutorial(_)
              ],
            ),
          )
        ],
      ));
    });
  }

  Column _tutorial(BankTranferController _) {
    return Column(
      children: [
        Column(
          children: List.generate(_.tutorModel?.length ?? 0, (i) {
            return Column(
              children: [
                InkWell(
                  onTap: () => _.onChangeOpenTutor(i),
                  child: Card(
                    color: _.openTutorController[i] ? ORANGEKALM : BLUEKALM,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                          width: Get.width,
                          child: TEXT(_.tutorModel![i].title,
                              style: COSTUM_TEXT_STYLE(color: Colors.white))),
                    ),
                  ),
                ),
                if (_.openTutorController[i])
                  Column(
                      children: List.generate(
                          _.tutorModel![i].data?.length ?? 0, (j) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: BOX_BORDER(Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TEXT("${j + 1}.",
                                  style: COSTUM_TEXT_STYLE(
                                      fontWeight: FontWeight.bold)),
                              SPACE(),
                              SizedBox(
                                  width: Get.width / 1.4,
                                  child: HTML_VIEW(_.tutorModel![i].data![j]))
                            ],
                          ))),
                    );
                  }))
              ],
            );
          }),
        ),
      ],
    );
  }

  Container _bank(BankTranferController _, BuildContext context) {
    return BOX_BORDER(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TEXT("${bankName(context)} Virtual Account",
              style: COSTUM_TEXT_STYLE(fonstSize: 20)),
          Image.asset(bankAssetIcon(context), scale: 15),
        ],
      ),
    ));
  }

  Container _totalPayment(BankTranferController _, BuildContext context) {
    return BOX_BORDER(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TEXT("Total Pembayaran",
                  style: COSTUM_TEXT_STYLE(color: Colors.grey)),
              SPACE(),
              TEXT('Rp. ${CURRENCY(_.response(context)?.package?.price)}',
                  style: COSTUM_TEXT_STYLE(fonstSize: 20)),
            ],
          ),
        ],
      ),
    ));
  }

  Container _virtualAccount(BankTranferController _, BuildContext context) {
    return BOX_BORDER(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TEXT("Virtual Account",
                  style: COSTUM_TEXT_STYLE(color: Colors.grey)),
              SPACE(),
              TEXT(_.vaNumber(context),
                  style: COSTUM_TEXT_STYLE(fonstSize: 20)),
            ],
          ),
          InkWell(
              onTap: () async {
                await Clipboard.setData(
                    ClipboardData(text: _.vaNumber(context, listen: false)));
                SUCCESS_SNACK_BAR('Perhatian',
                    "Berhasil disalin ${_.vaNumber(context, listen: false)}");
              },
              child: TEXT("Salin"))
        ],
      ),
    ));
  }

  Container _transactionTime(BankTranferController _, BuildContext context) {
    return BOX_BORDER(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TEXT("Batas akhir transaksi",
              style: COSTUM_TEXT_STYLE(color: Colors.grey)),
          SPACE(),
          Builder(builder: (context) {
            try {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TEXT(DATE_FORMAT(_
                      .response(context)
                      ?.otherResponse
                      ?.transactionTime!
                      .add(const Duration(days: 1)))),
                  TEXT(_.remainingTransactionTime ?? ""),
                ],
              );
            } catch (e) {
              return Container();
            }
          }),
        ],
      ),
    ));
  }
}

class BankTranferController extends GetxController
    with GetSingleTickerProviderStateMixin {
  List<TutorialBankModel>? tutorModel;
  PendingData? response(BuildContext context, {bool listen = true}) {
    return STATE(context, isListen: listen).pendingPaymentResModel?.pendingData;
  }

  Future<void> getTutorial(BuildContext context) async {
    var _ref = await PRO.database.ref("bank_tutorial").child("tutorial").once();
    var _m = _ref.snapshot.value as List<Object?>;
    var _r = _m.map((e) {
      return Map<String, dynamic>.from(e as Map<Object?, Object?>);
    }).toList();
    // debugPrint(jsonEncode(_model[0]), wrapWidth: 1024);
    var _tutor = _r.map((e) {
      return TutorialBankModel(
          title: e['title'],
          name: e['name'],
          data: List<String>.from(e['data'] as List<Object?>));
    }).toList();
    tutorModel = _tutor
        .where(
            (e) => e.name == bankName(context, isListen: false)?.toLowerCase())
        .toList();
    openTutorController = List.generate(tutorModel?.length ?? 0, (i) => false);
    update();
  }

  late List<bool> openTutorController;
  void onChangeOpenTutor(int i) {
    for (var j = 0; j < openTutorController.length; j++) {
      if (i == j) {
        if (openTutorController[j]) {
          openTutorController[j] = false;
        } else {
          openTutorController[j] = true;
        }
      } else {
        openTutorController[j] = false;
      }
    }
    update();
  }

  DateTime? get remainingTime =>
      PRO.pendingPaymentResModel?.pendingData?.otherResponse?.transactionTime
          ?.add(const Duration(days: 1));

  Stream<DateTime?> stream() {
    return Stream.periodic(const Duration(seconds: 1), (i) {
      try {
        remainingTime?.subtract(const Duration(seconds: 1));
        return remainingTime!;
      } catch (e) {
        return null;
      }
    });
  }

  String? remainingTransactionTime;
  void setTransactionTime(Duration? duration) {
    if (duration == null) {
      return;
    } else if (duration.isNegative) {
      return;
    }
    remainingTransactionTime = DURATION_FORMAT(duration);
    update();
  }

  String? vaNumber(BuildContext context, {bool listen = true}) {
    if (response(context, listen: listen)?.otherResponse?.vaNumbers != null) {
      return response(context, listen: listen)
          ?.otherResponse
          ?.vaNumbers
          ?.first
          .vaNumber;
    } else if (response(context, listen: listen)
            ?.otherResponse
            ?.permataVaNumber !=
        null) {
      return response(context, listen: listen)?.otherResponse?.permataVaNumber;
    } else {
      return "${response(context, listen: listen)?.otherResponse?.billKey}${response(context, listen: listen)?.otherResponse?.billerCode}";
    }
  }
}

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/payment_data_res_model/payment_data_res_model.dart';
import 'package:kalm/utilities/date_format.dart';
import 'package:kalm/utilities/parse_to_currency.dart';
import 'package:kalm/widget/box_border.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/image_cache.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class GopayPage extends StatelessWidget {
  final _controller = Get.put(GopayController());
  late StreamSubscription<DateTime?>? streamSubscription;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GopayController>(dispose: (ds) {
      if (streamSubscription != null) {
        streamSubscription?.cancel();
      }
    }, initState: (st) {
      streamSubscription = _controller.stream().listen((event) {
        _controller.setTransactionTime(PRO
            .pendingPaymentResModel?.pendingData?.otherResponse?.transactionTime
            ?.add(const Duration(minutes: 15))
            .difference(DateTime.now()));
      });
    }, builder: (_) {
      return SAFE_AREA(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                Image.asset("assets/icon/gopay.png", scale: 10),
                SPACE(),
                _totalPayment(_),
                SPACE(),
                _transactionTime(_, context),
                SPACE(),
                SizedBox(
                  width: Get.width / 1.5,
                  child: Column(
                    children: [
                      if (_.response(context) != null)
                        BUTTON('Lanjutkan', onPressed: () async {
                          await PRO.gopaySubmit(context);
                        }),
                      BUTTON('Kembali', onPressed: () async {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }),
                    ],
                  ),
                ),
                SPACE(),
                _qrCode(_)
              ],
            ),
          )
        ],
      ));
    });
  }

  Builder _qrCode(GopayController _) {
    return Builder(builder: (context) {
      try {
        return BOX_BORDER(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TEXT(
                  "Atau Anda dapat melakukan pembayaran dengan melakukan Scan QR berikut",
                  textAlign: TextAlign.center),
              IMAGE_CACHE(_.barCode(context)!, width: 250, height: 250),
            ],
          ),
        ));
      } catch (e) {
        return Container();
      }
    });
  }

  Container _transactionTime(GopayController _, BuildContext context) {
    return BOX_BORDER(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TEXT("Batas Akhir Pembayaran"),
              SPACE(),
              TEXT(_.remainingTransactionTime ?? ''),
            ],
          ),
          if (_.response(context) != null)
            BUTTON("Cek Status", onPressed: () async {
              _.setLoading(true);
              await PRO.getPendingPayment();
              _.setLoading(false);
              // debugPrint("${_.response(context, listen: false)?.toJson()}",
              //     wrapWidth: 1024);
            })
        ],
      ),
    ));
  }

  Container _totalPayment(GopayController _) {
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
                          "Rp. ${CURRENCY(double.parse(_.response(context)!.grossAmount!))}",
                          style: Get.textTheme.headline1),
                      SPACE(),
                      if (!_.loadingCheck) TEXT("Menunggu pembayaran")
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

class GopayController extends GetxController {
  PaymentDataResModel? response(BuildContext context, {bool listen = true}) {
    return STATE(context, isListen: listen)
        .pendingPaymentResModel
        ?.pendingData
        ?.otherResponse;
  }

  String? deepLink(BuildContext context, {bool listen = true}) {
    try {
      return STATE(context, isListen: listen)
          .pendingPaymentResModel
          ?.pendingData
          ?.otherResponse
          ?.actions
          ?.where((e) => e.url!.startsWith("gopay"))
          .first
          .url;
    } catch (e) {
      return null;
    }
  }

  String? barCode(BuildContext context, {bool listen = true}) {
    try {
      return STATE(context, isListen: listen)
          .pendingPaymentResModel
          ?.pendingData
          ?.otherResponse
          ?.actions
          ?.where((e) => e.name == "generate-qr-code")
          .first
          .url;
    } catch (e) {
      return null;
    }
  }

  DateTime? get remainingTime =>
      PRO.pendingPaymentResModel?.pendingData?.otherResponse?.transactionTime
          ?.add(const Duration(minutes: 15));
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

  bool loadingCheck = false;
  void setLoading(bool loading) {
    loadingCheck = loading;
    update();
  }
}

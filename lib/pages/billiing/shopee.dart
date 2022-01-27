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
import 'package:kalm/widget/loading.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShopeePage extends StatelessWidget {
  final _controller = Get.put(ShopeeController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopeeController>(dispose: (ds) {
      if (_controller.streamSubscription != null) {
        _controller.streamSubscription?.cancel();
      }
    }, initState: (st) {
      _controller.streamSubscription = _controller.stream().listen((event) {
        _controller.setTransactionTime(PRO
            .pendingPaymentResModel?.pendingData?.otherResponse?.transactionTime
            ?.add(const Duration(minutes: 10))
            .difference(DateTime.now()));
      });
    }, builder: (_) {
      // print(_.response(context)?.toJson());
      return SAFE_AREA(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                _totalPayment(_),
                SPACE(),
                _transactionTime(_, context),
                SPACE(),
                SizedBox(
                  width: Get.width / 1.5,
                  child: Column(
                    children: [
                      BUTTON("Selanjutnya", onPressed: () async {
                        await PRO.shopeeDeepLink(context);
                      }),
                      BUTTON("Kembali", onPressed: () {
                        Navigator.pop(context);
                      }),
                    ],
                  ),
                ),
                SPACE(height: 30),
              ],
            ),
          )
        ],
      ));
    });
  }

  Stack _test(ShopeeController _, BuildContext context) {
    return Stack(
      children: [
        WebView(
          initialUrl: _.response(context)?.actions?.map((e) => e.url).first,
          onProgress: (p) => _.setLoadingProgress(p),
          javascriptMode: JavascriptMode.unrestricted,
        ),
        if (_.loading != 100)
          Center(child: SizedBox(height: 100, width: 100, child: Loading().LOADING_ICON(context)))
      ],
    );
  }

  Container _transactionTime(ShopeeController _, BuildContext context) {
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
              TEXT(_.remainingTransactionTime ?? ""),
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

  Container _totalPayment(ShopeeController _) {
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
                      TEXT("Rp. ${CURRENCY(double.parse(_.response(context)!.grossAmount!))}",
                          style: Get.textTheme.headline1),
                      SPACE(),
                      if (!_.loadingCheck) TEXT("Menunggu pembayaran")
                    ],
                  );
                } catch (e) {
                  return TEXT('Pembayaran Gagal atau waktu habis',
                      style: COSTUM_TEXT_STYLE(fontWeight: FontWeight.bold, color: ORANGEKALM));
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

class ShopeeController extends GetxController {
  StreamSubscription<DateTime?>? streamSubscription;
  PaymentDataResModel? response(BuildContext context, {bool listen = true}) {
    return STATE(context, isListen: listen).pendingPaymentResModel?.pendingData?.otherResponse;
  }

  int? loading = 0;
  void setLoadingProgress(int p) {
    loading = p;
    update();
  }

  DateTime? get remainingTime =>
      PRO.pendingPaymentResModel?.pendingData?.otherResponse?.transactionTime
          ?.add(const Duration(minutes: 10));
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

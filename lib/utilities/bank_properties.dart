import 'package:flutter/material.dart';
import 'package:kalm/controller/user_controller.dart';

String bankAssetIcon(BuildContext context) {
  if (STATE(context)
          .pendingPaymentResModel
          ?.pendingData
          ?.otherResponse
          ?.vaNumbers !=
      null) {
    var _name = STATE(context)
        .pendingPaymentResModel
        ?.pendingData
        ?.otherResponse
        ?.vaNumbers
        ?.first
        .bank;
    switch (_name) {
      case "bca":
        return "assets/icon/bca.png";
      case "bri":
        return "assets/icon/bri.png";
      case "bni":
        return "assets/icon/bni.png";
      default:
        return "";
    }
  } else {
    if (STATE(context)
            .pendingPaymentResModel
            ?.pendingData
            ?.otherResponse
            ?.permataVaNumber !=
        null) {
      return "assets/icon/permata.png";
    } else if (STATE(context)
            .pendingPaymentResModel
            ?.pendingData
            ?.otherResponse
            ?.billerCode !=
        null) {
      return "assets/icon/mandiri.png";
    } else {
      return 'assets/icon/accept.png';
    }
  }
}

String? bankName(BuildContext context, {bool isListen = true}) {
  var _payment = STATE(context, isListen: isListen)
      .pendingPaymentResModel
      ?.pendingData
      ?.otherResponse;
  var _anotherPayment = STATE(context, isListen: isListen)
      .pendingPaymentResModel
      ?.pendingData
      ?.anotherResponse;
  // print(_payment?.paymentType);
  if (_payment?.vaNumbers != null) {
    var _name = _payment?.vaNumbers?.first.bank?.toLowerCase();
    switch (_name) {
      case "bca":
        return "BCA";
      case "bri":
        return "BRI";
      case "bni":
        return "BNI";
      default:
        return null;
    }
  } else {
    if (_payment?.permataVaNumber != null) {
      return "PERMATA";
    } else if (_payment?.billerCode != null) {
      return "MANDIRI";
    } else if ((_payment?.paymentType != null) &&
        _payment?.paymentType == "gopay") {
      return "GOPAY";
    } else if ((_payment?.paymentType != null) &&
        _payment?.paymentType == "shopeepay") {
      return "SHOPEE";
    } else if ((_payment?.paymentType != null) &&
        _payment?.paymentType == "shopeepay") {
      return "SHOPEE";
    } else if (_anotherPayment != null) {
      return "INDODANA";
    } else {
      return null;
    }
  }
}

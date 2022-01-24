import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/widget/loading.dart';
import 'package:kalm/widget/snack_bar.dart';

// API STG V2
// String CMS = 'https://kalm-stg.cranium.id/';
// String BASE_URL = 'https://kalm-stg.cranium.id/api/v2/';
// String IMAGE_URL = "https://kalm-stg.cranium.id/files/";
// String COUNSELOR_IMAGE_URL = 'https://kalm-stg.cranium.id/files/counselor-files/';
// String KARS = 'https://kalm-stg.cranium.id/kars';

// String CMS;
// String BASE_URL;
// String IMAGE_URL;
// String COUNSELOR_IMAGE_URL;
// String KARS;

// API PROD V3
String CMS = 'https://v3.kalm-app.com/';
String BASE_URL = 'https://v3.kalm-app.com/api/v2/';
String IMAGE_URL = "https://v3.kalm-app.com/files/";
String COUNSELOR_IMAGE_URL = 'https://v3.kalm-app.com/files/counselor-files/';
String KARS = 'https://v3.kalm-app.com/kars';

Map<String, String> OCRHeader = {
  "X-API-Key": "OpBIsDd5M62q8NzzR5Ptz7t24ligE9LGaciqQlT7",
  "Content-Type": "multipart/form-data"
};
Future<ConnectivityResult> _checkNetwork() async {
  return await (Connectivity().checkConnectivity());
}

class Api {
  BaseOptions _baseDioOption({
    String? customBaseUrl,
  }) =>
      BaseOptions(connectTimeout: 60000, baseUrl: customBaseUrl ?? BASE_URL);
  String? _unknowError(dynamic error) {
    try {
      return error['message'];
    } catch (e) {
      return null;
    }
  }

  Future<WrapResponse?> POST(
    String url,
    dynamic body, {
    bool useLoading = true,
    bool useToken = false,
    bool useSnackbar = true,
    Map<String, String>? customHeader,
    String? customBaseUrl,
  }) async {
    // check user networt
    var _net = await _checkNetwork();

    try {
      useLoading ? Loading.show() : null;
      var _execute = Dio(_baseDioOption(customBaseUrl: customBaseUrl)).post(url,
          data: body,
          // calculate receiving data progresss
          onReceiveProgress: (int sent, int total) => PRO.onReceiveProgresss(sent, total),
          // calculate send data progresss
          onSendProgress: (int sent, int total) => PRO.onSendProgresss(sent, total),
          // Header
          options: Options(
              headers: (useToken
                  ? {
                      "Content-Type": 'application/json',
                      "Authorization": "Bearer ${PRO.userData?.token}",
                    }
                  : {
                      "Content-Type": 'application/json',
                    })));
      // Execute
      var _res = await _execute;
      Loading.hide();
      return WrapResponse(
          message: _res.statusMessage, statusCode: _res.statusCode, data: _res.data);
    } on DioError catch (e) {
      Loading.hide();
      if (e.type == DioErrorType.response) {
        if (e.response?.statusCode == 401) {
          useSnackbar
              ? ERROR_SNACK_BAR("${e.response?.statusCode}",
                  _unknowError(e.response?.data) ?? e.response?.statusMessage)
              : null;
          PRO.clearAllData();
          return null;
        } else if (e.response!.statusCode! >= 400 && e.response!.statusCode! != 401) {
          useSnackbar
              ? ERROR_SNACK_BAR("${e.response?.statusCode}",
                  _unknowError(e.response?.data) ?? e.response?.statusMessage)
              : null;
          return WrapResponse(
              message: e.response?.statusMessage ?? e.message,
              statusCode: e.response?.statusCode ?? 0,
              data: e.response?.data);
        } else {
          useSnackbar
              ? ERROR_SNACK_BAR('${e.response?.statusCode}', e.response?.statusMessage)
              : null;
          return WrapResponse(
              message: e.response?.statusMessage ?? e.message,
              statusCode: e.response?.statusCode ?? 0,
              data: e.response?.data);
        }
      } else if (e.type == DioErrorType.connectTimeout) {
        useSnackbar ? ERROR_SNACK_BAR("Perhatian", "Koneksi tidak stabil") : null;
        return WrapResponse(message: "connection timeout", statusCode: e.response?.statusCode ?? 0);
      } else if (_net == ConnectivityResult.none) {
        ERROR_SNACK_BAR("Perhatian", "Pastikan Anda terhubung ke Internet");
        return WrapResponse(message: "connection timeout", statusCode: 000);
      } else {
        ERROR_SNACK_BAR("Perhatian", "Terjadi Kesalahan");
        return WrapResponse(message: "connection timeout", statusCode: 999);
      }
    }
  }

  Future<WrapResponse?> PUT(
    String url,
    dynamic body, {
    bool useLoading = true,
    bool useToken = false,
    bool useSnackbar = true,
  }) async {
    var _net = await _checkNetwork();
    try {
      useLoading ? Loading.show() : null;
      var _execute = Dio(_baseDioOption()).put(url,
          data: body,
          // onReceiveProgress: (int sent, int total) => PRO.onSendProgress(sent, total),
          // onSendProgress: (int sent, int total) => PRO.onSendProgress(sent, total),
          options: Options(
              headers: useToken
                  ? {
                      "Content-Type": 'application/json',
                      "Authorization": "Bearer ${PRO.userData?.token}",
                      'Accept': 'application/json'
                    }
                  : {
                      "Content-Type": 'application/json',
                    }));
      var _res = await _execute;
      Loading.hide();
      return WrapResponse(
          message: _res.statusMessage, statusCode: _res.statusCode, data: _res.data);
    } on DioError catch (e) {
      // print(e.requestOptions.data);
      Loading.hide();
      ERROR_SNACK_BAR("ERROR", "${e.response?.data}");
      if (e.type == DioErrorType.response) {
        if (e.response!.statusCode! == 401) {
          useSnackbar
              ? ERROR_SNACK_BAR("${e.response?.statusCode}", e.response?.statusMessage)
              : null;
          PRO.clearAllData();
          return null;
        } else if (e.response!.statusCode! >= 400 && e.response!.statusCode! != 401) {
          useSnackbar
              ? ERROR_SNACK_BAR("${e.response?.statusCode}",
                  _unknowError(e.response?.data) ?? e.response?.statusMessage)
              : null;
          return WrapResponse(
              message: e.response?.statusMessage ?? e.message,
              statusCode: e.response?.statusCode ?? 0,
              data: e.response?.data);
        } else {
          useSnackbar
              ? ERROR_SNACK_BAR("${e.response?.statusCode}",
                  _unknowError(e.response?.data) ?? e.response?.statusMessage)
              : null;
          return WrapResponse(
              message: e.response?.statusMessage ?? e.message,
              statusCode: e.response?.statusCode ?? 0,
              data: e.response?.data);
        }
      } else if (e.type == DioErrorType.connectTimeout) {
        useSnackbar ? ERROR_SNACK_BAR("Perhatian", "Koneksi tidak stabil") : null;
        return WrapResponse(message: "connection timeout", statusCode: e.response?.statusCode ?? 0);
      } else if (_net == ConnectivityResult.none) {
        ERROR_SNACK_BAR("Perhatian", "Pastikan Anda terhubung ke Internet");
        return WrapResponse(message: "connection timeout", statusCode: 000);
      } else {
        ERROR_SNACK_BAR("Perhatian", "Terjadi Kesalahan");
        return WrapResponse(message: "connection timeout", statusCode: 999);
      }
    }
  }

  Future<WrapResponse?> GET(
    String url, {
    bool useLoading = true,
    bool useToken = false,
    bool useSnackbar = true,
    String? customBaseUrl,
  }) async {
    var _net = await _checkNetwork();
    try {
      useLoading ? Loading.show() : null;
      var _execute = Dio(_baseDioOption(customBaseUrl: customBaseUrl)).get(url,
          onReceiveProgress: (int sent, int total) => PRO.onReceiveProgresss(sent, total),
          options: Options(
              headers: useToken
                  ? {
                      "Content-Type": 'application/json',
                      "Authorization": "Bearer ${PRO.userData?.token}",
                    }
                  : {
                      "Content-Type": 'application/json',
                    }));
      var _res = await _execute;
      Loading.hide();
      return WrapResponse(
          message: _res.statusMessage, statusCode: _res.statusCode, data: _res.data);
    } on DioError catch (e) {
      Loading.hide();
      if (e.type == DioErrorType.response) {
        if (e.response!.statusCode! == 401) {
          useSnackbar
              ? ERROR_SNACK_BAR("${e.response?.statusCode}", e.response?.statusMessage)
              : null;
          await PRO.clearAllData();
          return null;
        } else if (e.response!.statusCode! >= 400 && e.response!.statusCode! != 401) {
          useSnackbar
              ? ERROR_SNACK_BAR("${e.response?.statusCode}",
                  _unknowError(e.response?.data) ?? e.response?.statusMessage)
              : null;
          return WrapResponse(
              message: e.response?.statusMessage ?? e.message,
              statusCode: e.response?.statusCode ?? 0,
              data: e.response?.data);
        } else {
          useSnackbar
              ? ERROR_SNACK_BAR("${e.response?.statusCode}",
                  _unknowError(e.response?.data) ?? e.response?.statusMessage)
              : null;
          return WrapResponse(
              message: e.response?.statusMessage ?? e.message,
              statusCode: e.response?.statusCode ?? 0,
              data: e.response?.data);
        }
      } else if (e.type == DioErrorType.connectTimeout) {
        useSnackbar ? ERROR_SNACK_BAR("Perhatian", "Koneksi tidak stabil") : null;
        return WrapResponse(message: "connection timeout", statusCode: e.response?.statusCode ?? 0);
      } else if (_net == ConnectivityResult.none) {
        ERROR_SNACK_BAR("Perhatian", "Pastikan Anda terhubung ke Internet");
        return WrapResponse(message: "connection timeout", statusCode: 000);
      } else {
        ERROR_SNACK_BAR("Perhatian", "Terjadi Kesalahan");
        return WrapResponse(message: "connection timeout", statusCode: 999);
      }
    }
  }
}

/// user/
String SESSION(String code) => 'user/$code';

/// inspirational-quote?lang=id&roles=$USER_ROLE"
String INSPIRATION_QOUTE = "inspirational-quote?lang=id&roles=10";

/// article?lang=id&main=1&is_counselor=${USER_ROLE == "10" ? "0" : "1"}
String USER_ARTICLE = "article?lang=id&main=1&is_counselor=0";
String ARTICLE_DATA = "article?lang=id";

/// inspirational/
const String INSPIRATIONAL_QUOTE = "inspirational/";

String PROMO_CHECK({@required String? subsId, @required String? promo}) =>
    'check-subscription-promo/$subsId/$promo';

/// articles/
const String ARTICLE = "articles/";

/// questionnaire-sign-up?user_role=$USER_ROLE
String QUESTIONER = "questionnaire-sign-up?user_role=10";

String POST_QUESTIONER = "auth/questionnaire-sign-up";
String UPDATE_QUESTIONER = "auth/questionnaire-update/${PRO.userData?.code}";

/// flash-page?role=$USER_ROLE
String FLASHPAGE = "flash-page?role=10";

/// auth/register
const String REGISTER = 'auth/register';

const String USER_SUBSCRIBE = 'user/subscribe';
const String SETTING_CONTACT = "setting/contact";
String CONTACT_US = "page/32lang=id";
String ABOUT_KALM = "page/30lang=id";
const String FAQ_CATEGORY = 'faq?category=10';
String HOW_TO = 'page/12?lang=id';
String PRIVACY = 'page/33?lang=id';
String TERM_AND_CONDITION_CATEGORY = 'term-condition?category=10&lang=id';
String CHECK_VOUCHER(String voucher) => "user/voucher/check/$voucher";
const String ASSIGN_VOUCHER = "user/voucher/assign";
const String FORGOT_PASSWORD = 'auth/forgot-password';
const String RESEND_CODE = "auth/resend-activation-code";
const String AUTH = 'auth/login';

/// get-countries
const String GET_COUNTRIES = 'get-countries';
String TNC_DATA(String counCOde) => "counselor/term-conditions/for-user/$counCOde";

/// get-states/${id}
String GET_STATES({@required int? id}) => 'get-states/${id.toString()}';
String GET_COUNSELOR(String code) => "user/counselor-detail-info/$code";
const String EMAIL_SUBSCRIPTION =
    'counselor/setting/notification-setting/email-client-send-message';
const String NOTIF_SUBSCRIPTION =
    'counselor/setting/notification-setting/notification-client-send-message';
String REQUEST_CHANGE_COUNSELOR = 'user/change-counselor-request/${PRO.userData?.code}';
String PAGE_DIR(int page) => 'page/$page?lang=id';

/// get-cities/${id}
String GET_CITIES({@required int? id}) => 'get-cities/${id.toString()}';
const String POST_MATCHUP = "matchup";
const String ACTIVATION_CODE = "auth/register-activation-code";
String MATCHUP = "matchup?lang=id";
const String GET_EXPERIECE = "user-experience";
const String ASSIGN_UNIQCODE = "assign-unique-code";
const String PENDING_UNIQCODE = "pending-unique-code";
const String CHECK_UNIQCODE = "check-unique-code/";
const String PENDING_PAYMENT = "user/subscription/pending";
String DELETE_PAYMENT({@required String? id}) => "user/subscription/cancel/$id";
String USER_UPDATE = 'user/update/${PRO.userData?.code}';
String UPDATE_PROFILE_IMAGE = 'user/update-photo/${PRO.userData?.code}';
String GET_SUBSCRIPTION_LIST = "get-subscriptions?lang=id";
String GRATITUDE_JOURNAL = "user/gratitude-journal/${PRO.userData?.code}";
String GRATITUDE_WALL(String code) => 'user/gratitude-walls/${PRO.userData?.code}';

String ACC_TNC(String counselorCode) => 'matchup/user/accept/$counselorCode';
String REJECT_TNC = 'user/change-counselor-request/${PRO.userData?.code}';
const String DIRECTORY_SORTED = "directory-sorted";
String GET_TO_KNOW = "user/get-to-know/${PRO.userData?.code}";
String CHANGE_PASSWORD = "auth/change-password/${PRO.userData?.code}";
String WONDER_PUSH_NOTIF = "push-notification";

///Payment Gateway
const String PAYMENT_LIST_API = "payment/list";
//STG
// const String PAYMENT_GATEWAY = 'https://kalm-payment.cranium.id/api/v3/';
//LIVE
const String PAYMENT_GATEWAY = 'https://api3.kalm-app.com/api/v3/';
const String MIDTRANS_CC = "midtrans/credit-card";
const String MIDTRANS_BANK_TF = "midtrans/bank-transfer";
const String INDODANA_TRANSACTION = "indodana/purchase-transaction";
const String INDODANA_INSTALLMENT = "indodana/get-installment";
const String XENDIT_CREATE = "xendit/create/ovo";
const String XENDIT_GET = "xendit/get/ovo";
const String GOPAY = "midtrans/gopay";
const String SHOPEE = "midtrans/shopee";

class WrapResponse {
  String? message;
  int? statusCode;
  dynamic data;
  WrapResponse({
    this.message,
    this.statusCode,
    this.data,
  });
  WrapResponse.fromJson(Map<String, dynamic> json) {
    message = json['message']?.toString();
    statusCode = json['code'];
    data = json['data'];
  }
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['status_code'] = statusCode;
    _data['data'] = data;
    return _data;
  }
}

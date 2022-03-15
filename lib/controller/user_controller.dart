import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/model/about_res_model/about_res_model.dart';
import 'package:kalm/model/article_res_model/article_res_model.dart';
import 'package:kalm/model/bank_payload.dart';
import 'package:kalm/model/contact_us_res_model/contact_us_res_model.dart';
import 'package:kalm/model/counselor_data.dart';
import 'package:kalm/model/country_res_model/country_res_model.dart';
import 'package:kalm/model/directory_page_res_model/directory_res_model.dart';
import 'package:kalm/model/directory_res_model/directory_res_model.dart';
import 'package:kalm/model/faq_res_model/faq_res_model.dart';
import 'package:kalm/model/firebase_wording_model.dart';
import 'package:kalm/model/gratitude_res_model/gratitude_res_model.dart';
import 'package:kalm/model/how_to_res_model/how_to_res_model.dart';
import 'package:kalm/model/indodana_res_model/indodana_res_model.dart';
import 'package:kalm/model/ors_history_res_model/ors_data.dart';
import 'package:kalm/model/ors_history_res_model/ors_history_res_model.dart';
import 'package:kalm/model/ors_res_model/ors_res_model.dart';
import 'package:kalm/model/ovo_res_model/ovo_res_model.dart';
import 'package:kalm/model/payment_list_res_model/payment_list_res_model.dart';
import 'package:kalm/model/pending_kalmselor_code_model/pending_kalmselor_code_model.dart';
import 'package:kalm/model/pending_payment_res_model/pending_payment_res_model.dart';
import 'package:kalm/model/quote_res_model/quote_res_model.dart';
import 'package:kalm/model/register_payload.dart';
import 'package:kalm/model/state_res_model/address_res_item.dart';
import 'package:kalm/model/subscription_list_res_model/subscription_list_res_model.dart';
import 'package:kalm/model/survey_res_model.dart';
import 'package:kalm/model/tnc_res_model/tnc_res_model.dart';
import 'package:kalm/model/user_matchup_payload.dart';
import 'package:kalm/model/user_matchup_res_model/matchup_datum.dart';
import 'package:kalm/model/user_matchup_res_model/user_matchup_res_model.dart';
import 'package:kalm/model/user_model/user_data.dart';
import 'package:kalm/model/user_model/user_model.dart';
import 'package:kalm/model/user_questioner_payload.dart';
import 'package:kalm/model/user_quetioner_res_model/user_quetioner_res_model.dart';
import 'package:kalm/model/wonderpush_payload.dart';
import 'package:kalm/pages/auth/login.dart';
import 'package:kalm/pages/billiing/bank_transfer.dart';
import 'package:kalm/pages/billiing/gopay.dart';
import 'package:kalm/pages/billiing/indodana.dart';
import 'package:kalm/pages/billiing/ovo.dart';
import 'package:kalm/pages/billiing/shopee.dart';
import 'package:kalm/utilities/deep_link_redirect.dart';
import 'package:kalm/utilities/util.dart';
import 'package:kalm/widget/dialog.dart';
import 'package:kalm/widget/loading.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_controller.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

PR(_res) => debugPrint(jsonEncode(_res), wrapWidth: 1024);
UserController PRO = Provider.of(Get.context!, listen: false);
UserController STATE(BuildContext context, {bool isListen = true}) =>
    Provider.of<UserController>(context, listen: isListen);
GetStorage _box = GetStorage();
String? get PIN_LOCK => _box.read(PIN_CODE_STORAGE);
const String _email = "admin@kalm.com";
const String _password = "a79d76e843a8248e207504c983a3a2ef";
const String USER_STORAGE = "USER";
const String PIN_CODE_STORAGE = "PIN_CODE_STORAGE";
const String USER_ORS_STORAGE = "USER_ORS";
const String SURVEY_STORAGE = "SURVEY";

class UserController extends ChangeNotifier {
  int initialIndex = 0;
  PersistentTabController tabController = PersistentTabController(initialIndex: 0);
  void updateInitialIndexTab(int index) {
    tabController.index = index;
    notifyListeners();
    tabController.jumpToTab(index);
  }

  void onChangeTab(int index) {
    tabController.index = index;
    notifyListeners();
    TAB_CHANGE_DEBOUNCER(index, () async {
      switch (index) {
        case 0:
          await getHomeArticles();
          await getQuote();
          break;
        case 1:
          await getGratitudeJournal(useLoading: false);
          break;
        case 2:
          print('chat');
          // await _updateRead();
          break;
        case 3:
          await getVideos();
          await getDirectoryArticles();
          await getDirectoryPlace();
          break;
        case 4:
          print('setting');
          break;
        default:
      }
    }, second: 10);
  }

  final database = FirebaseDatabase.instance;

  Future<void> pushNotif(String? message) async {
    var _body = WonderpushPayload(
        content: message ?? "new message",
        userId: counselorData?.counselor?.id,
        title: "${userData?.firstName} ${userData?.lastName}");
    var _res = await Api().POST(WONDER_PUSH_NOTIF, _body.toJson(),
        useLoading: false, useClearData: false, useSnackbar: false);
    if (_res?.statusCode == 200) {
    } else {
      return;
    }
  }

  late FirebaseAuth firebaseAuth;
  late FirebaseWordingModel firebaseWordingModel;
  late DatabaseReference wording;
  late DatabaseReference orsRef;
  late DatabaseReference orsResultRef;

  Future<void> firebaseSignin() async {
    firebaseAuth = FirebaseAuth.instance;
    UserCredential _user =
        await firebaseAuth.signInWithEmailAndPassword(email: _email, password: _password);
  }

  List<OrsResModel>? orsResModel;
  List<OrsResultModel>? orsResultModel;
  Future<void> getOrsFirebase() async {
    orsRef = database.ref("ors_main/");
    orsResultRef = database.ref("ors_data/");
    var _snapOrs = await orsRef.once();
    var _modelOrs = List<dynamic>.from(_snapOrs.snapshot.value as dynamic);
    var _snapOrsResult = await orsResultRef.once();
    var _modelOrsResult = List<dynamic>.from(_snapOrsResult.snapshot.value as dynamic);
    orsResModel = List.generate(
        _modelOrs.length, (i) => OrsResModel.fromJson(_modelOrs[i] as Map<Object?, Object?>));
    orsResultModel = List.generate(_modelOrsResult.length,
        (i) => OrsResultModel.fromJson(_modelOrsResult[i] as Map<Object?, Object?>));
    notifyListeners();
  }

  List<OrsHistoryData>? orsHistoryData;
  Future<void> getOrs() async {
    var _res = await Api().GET(GET_ORS, useToken: true);
    if (_res?.statusCode == 200) {
      orsHistoryData = OrsHistoryResModel.fromJson(_res?.data).orsData;
      notifyListeners();
      Loading.hide();
    } else {
      Loading.hide();
      return;
    }
  }

  SurveyResModel? surveyResModel;
  Future<void> getSurvey() async {
    var _surveyRef = database.ref("survey/");
    var _snap = await _surveyRef.once();
    var _model = Map<String, dynamic>.from(_snap.snapshot.value as dynamic);
    surveyResModel = SurveyResModel.fromJson(_model);
    notifyListeners();
  }

  List<dynamic>? get localOrs => _box.read(USER_ORS_STORAGE);
  Future<void> saveOrs(List<double> data, {bool isDelete = false}) async {
    if (isDelete) {
      await _box.remove(USER_ORS_STORAGE);
      return;
    }
    await _box.write(USER_ORS_STORAGE, data);
  }

  bool get isSurvey => _box.read(SURVEY_STORAGE) ?? false;
  Future<void> saveSurvey(bool isSurvey) async {
    await _box.write(SURVEY_STORAGE, isSurvey);
  }

  Future<void> updateWording() async {
    try {
      if (firebaseAuth.currentUser == null) {
        ERROR_SNACK_BAR("Perhatian", 'Error 900');
        return;
      }
      // else {
      //   wording = database.ref("wording");
      //   var _snap = await wording.get();
      //   firebaseWordingModel = FirebaseWordingModel.fromJson(
      //       Map<String, dynamic>.from(_snap.value as Map<Object?, Object?>));
      //   notifyListeners();
      // }
    } catch (e) {
      ERROR_SNACK_BAR("Perhatian", 'Error 900');
    }
  }

  String? APP_VERSION;
  DatabaseReference get versionRef => FirebaseDatabase.instance.ref('version/user');
  Future<void> checkAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      APP_VERSION = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      notifyListeners();
      versionRef.onValue.listen(
        (DatabaseEvent event) async {
          var _data = Map<String, dynamic>.from(event.snapshot.value as dynamic);
          if (Platform.isAndroid) {
            var _androidVersion = int.parse((_data['android'] as String).replaceAll(".", ""));
            var _androidLocalVersion = int.parse(APP_VERSION!.replaceAll(".", ""));
            if (_androidLocalVersion < _androidVersion) {
              await SHOW_DIALOG(_data['message'],
                  onAcc: () async => await GO_TO_STORE(), barrierDismissible: false);
            } else {
              return;
            }
          } else {
            var _iosVersion = int.parse((_data['ios'] as String).replaceAll(".", ""));
            var _iosLocalVersion = int.parse(APP_VERSION!.replaceAll(".", ""));
            if (_iosLocalVersion < _iosVersion) {
              await SHOW_DIALOG(_data['message'],
                  onAcc: () async => await GO_TO_STORE(), barrierDismissible: false);
            } else {
              return;
            }
          }
        },
        onError: (Object o) {
          final error = o as FirebaseException;
          print('Error: ${error.code} ${error.message}');
        },
      );
    } catch (e) {
      print(e);
    }
  }

  DatabaseReference get matchupRef =>
      FirebaseDatabase.instance.ref('user_matchup/${userData?.code}');
  late DatabaseReference chatRef;
  Future<void> getChat() async {
    try {
      if (counselorData?.matchupId == null) {
        ERROR_SNACK_BAR("Perhatian", "Terjadi Kesalahan");
        return;
      } else {
        chatRef = database.ref('chats/${counselorData?.matchupId}');
        await chatRef.keepSynced(true);
        notifyListeners();
      }
    } catch (e) {
      ERROR_SNACK_BAR("Perhatian", "Terjadi Kesalahan");
      return;
    }
  }

  bool get isHavePackages {
    return userData?.userSubcription != null && userData?.userSubscriptionList != null;
  }

  bool get isChatting {
    return (counselorData?.counselor != null) &&
        counselorData?.matchupId != null &&
        userData?.userSubcription != null &&
        userData?.userHasActiveCounselor?.isReadTnc == 1;
  }


  bool get isShowTnc {
    return counselorData?.counselor != null &&
        userData?.userSubcription != null &&
        userData?.userHasActiveCounselor?.isReadTnc == 0;
  }

  CounselorData? counselorData;
  Future<void> getCounselor({bool useLoading = false}) async {
    print('GET COUNSELOR');
    var _res =
        await Api().GET(GET_COUNSELOR(userData!.code!), useToken: true, useLoading: useLoading);
    // PR(_res?.data['data']['user_counselor_optional_files']);
    if (_res?.statusCode == 200) {
      counselorData = CounselorData.fromJson(_res?.data);
      await getTncData(useLoading: useLoading);
      notifyListeners();
      await getChat();
    } else {
      return;
    }
  }

  bool get isPendingKalmselorCode => pendingKalmselorCodeModel?.data != null;
  PendingKalmselorCodeModel? pendingKalmselorCodeModel;
  Future<void> getPendingKalmselorCode() async {
    var _res =
        await Api().GET(PENDING_UNIQCODE, useLoading: false, useToken: true, useSnackbar: false);
    if (_res?.statusCode == 200) {
      pendingKalmselorCodeModel = PendingKalmselorCodeModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  TncResModel? tncResModel;
  Future<void> getTncData({bool useLoading = true}) async {
    try {
      var _res = await Api()
          .GET(TNC_DATA(counselorData!.counselor!.code!), useToken: true, useLoading: useLoading);
      // debugPrint(jsonEncode(_res?.data), wrapWidth: 1024);
      if (_res?.statusCode == 200) {
        tncResModel = TncResModel.fromJson(_res?.data);
        notifyListeners();
      } else {
        return;
      }
    } catch (e) {
      ERROR_SNACK_BAR("Perhatian", "Kalmselor tidak ditemukan");
    }
  }

  Future<void> updateSession({
    bool useLoading = false,
  }) async {
    try {
      var _res =
          await Api().GET(SESSION(PRO.userData!.code!), useToken: true, useLoading: useLoading);
      // PR(_res?.data['data']['user_setting']);
      if (_res?.statusCode == 200) {
        await saveLocalUser(UserModel.fromJson(_res?.data).data);
        userData = UserModel.fromJson(_res?.data).data;
        notifyListeners();
        if (userData?.userHasActiveCounselor == null) {
          await getPendingKalmselorCode();
        } else {
          await getCounselor(useLoading: useLoading);
          pendingKalmselorCodeModel = null;
        }
      } else {
        return;
        // userData = null;
        // notifyListeners();
      }
    } catch (e) {}
  }

  SubscriptionListResModel? subscriptionListResModel;
  Future<void> getSubSubcriptionList({bool useLoading = true}) async {
    var _res = await Api().GET(GET_SUBSCRIPTION_LIST, useLoading: useLoading);
    if (_res?.statusCode == 200) {
      subscriptionListResModel = SubscriptionListResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  ContactUsResModel? contactUsResModel;
  Future<void> getContactUs() async {
    var _res = await Api().GET(CONTACT_US);
    if (_res?.statusCode == 200) {
      contactUsResModel = ContactUsResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  PendingPaymentResModel? pendingPaymentResModel;
  Future<void> getPendingPayment({bool useLoading = false, bool useSnackbar = true}) async {
    var _res = await Api()
        .GET(PENDING_PAYMENT, useLoading: useLoading, useToken: true, useSnackbar: useSnackbar);
    if (_res?.statusCode == 200) {
      pendingPaymentResModel = PendingPaymentResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      await cancelPayment();
      return;
    }
  }

  Future<void> submitPayment(String paymentName, BuildContext context) async {
    // print(pendingPaymentResModel?.toJson());
    var _bankPayload = BankPayload(
        bank: paymentName.toLowerCase(),
        orderId: '${pendingPaymentResModel?.pendingData?.id}',
        amount: pendingPaymentResModel?.pendingData?.package?.price,
        userCode: userData?.code);
    var _name = paymentName.toLowerCase();
    if (_name != "credit card" &&
        _name != "indodana" &&
        _name != "ovo" &&
        _name != "gopay" &&
        _name != "shopee") {
      var _res = await Api().POST("", _bankPayload.toJson(),
          useToken: true, customBaseUrl: "$PAYMENT_GATEWAY$MIDTRANS_BANK_TF");
      if (_res?.statusCode == 200) {
        await getPendingPayment(useLoading: true);
        Loading.hide();
        await pushNewScreen(context, screen: BankTransferPage());
      } else {
        return;
      }
    } else {
      switch (_name) {
        case "gopay":
          var _gopayPayload = _bankPayload.toJson();
          _gopayPayload.remove("bank");
          await _gopay(_gopayPayload, context);
          break;
        case "indodana":
          var _indo = _bankPayload.toJson();
          _indo.remove("bank");
          await _indodanaGet(_indo);
          Loading.hide();
          pushNewScreen(context, screen: IndodanaPage());
          break;
        case "ovo":
          await pushNewScreen(context, screen: OvoPage());
          break;
        case "shopee":
          var _shop = _bankPayload.toJson();
          _shop.remove("bank");
          await _shopee(_shop);
          Loading.hide();
          await pushNewScreen(context, screen: ShopeePage());
          break;
        default:
          print(_name);
      }
    }
  }

  Future<void> _gopay(dynamic _gopayPayload, BuildContext context) async {
    var _res = await Api()
        .POST("", _gopayPayload, useToken: true, customBaseUrl: "$PAYMENT_GATEWAY$GOPAY");
    if (_res?.statusCode == 200) {
      await getPendingPayment(useLoading: true);
      Loading.hide();
      await pushNewScreen(context, screen: GopayPage());
    } else {
      Loading.hide();
      return;
    }
  }

  Future<void> gopaySubmit(context) async {
    final _redirectUrl = pendingPaymentResModel?.pendingData?.otherResponse?.actions
        ?.where((element) => element.url!.startsWith("gojek"))
        .first
        .url;
    final _transactionStatus =
        pendingPaymentResModel?.pendingData?.otherResponse?.transactionStatus;
    try {
      if (Platform.isAndroid) {
        try {
          if (await canLaunch(_redirectUrl!)) {
            await launch(_redirectUrl, enableJavaScript: true);
          } else if (_transactionStatus == "pending") {
            await launch(_redirectUrl, enableJavaScript: true);
          } else {
            await cancelPayment();
          }
        } catch (e) {
          GO_TO_STORE(appId: "com.gojek.app");
        }
      } else if (Platform.isIOS) {
        try {
          if (await launchUniversalLinkIos(_redirectUrl!)) {
            return;
          } else if (_transactionStatus == "pending") {
            if (await launchUniversalLinkIos(_redirectUrl)) {
              return;
            } else {
              GO_TO_STORE(appId: "944875099");
              return;
            }
          } else {
            await cancelPayment();
          }
        } catch (e) {
          GO_TO_STORE(appId: "944875099");
        }
      } else {
        await cancelPayment();
      }
    } catch (e) {
      await cancelPayment();
    }
  }

  IndodanaResModel? indodanaResModel;
  Future<void> _indodanaGet(dynamic _indo) async {
    var _res = await Api()
        .POST("", _indo, useToken: true, customBaseUrl: "$PAYMENT_GATEWAY$INDODANA_INSTALLMENT");
    if (_res?.statusCode == 200) {
      await getPendingPayment(useLoading: true);
      indodanaResModel = IndodanaResModel.fromJson(_res?.data);
      notifyListeners();
      // debugPrint(jsonEncode(_res?.data), wrapWidth: 1024);
    } else {
      return;
    }
  }

  Future<void> indodanaCreate(String installmentId) async {
    var _bankPayload = BankPayload(
            orderId: '${pendingPaymentResModel?.pendingData?.id}',
            amount: pendingPaymentResModel?.pendingData?.package?.price,
            userCode: userData?.code)
        .toJson();
    _bankPayload.putIfAbsent("installment_id", () => installmentId);
    _bankPayload.remove("bank");
    var _res = await Api().POST("", _bankPayload,
        useToken: true, customBaseUrl: "$PAYMENT_GATEWAY$INDODANA_TRANSACTION");
    if (_res?.statusCode == 200) {
      await getPendingPayment(useLoading: true);
      // debugPrint(jsonEncode(_res?.data), wrapWidth: 1024);
    } else {
      return;
    }
  }

  Future<void> indodanaDeeplink(BuildContext context, {String? installmentId}) async {
    var _data = pendingPaymentResModel?.pendingData?.anotherResponse;
    if (_data != null) {
      try {
        if (Platform.isAndroid) {
          if (await canLaunch(_data.redirectUrl!)) {
            await launch(_data.redirectUrl!);
          } else {
            await getPendingPayment(useLoading: true);
            Loading.hide();
            ERROR_SNACK_BAR("Perhatian", "Terjadi Kesalahan");
            Navigator.pop(context);
            Navigator.pop(context);
          }
        } else {
          if (await launchUniversalLinkIos(_data.redirectUrl!)) {
          } else {
            await getPendingPayment(useLoading: true);
            Loading.hide();
            ERROR_SNACK_BAR("Perhatian", "Terjadi Kesalahan");
            Navigator.pop(context);
            Navigator.pop(context);
          }
        }
      } catch (e) {
        await getPendingPayment(useLoading: true);
        Loading.hide();
        ERROR_SNACK_BAR("Perhatian", "Terjadi Kesalahan");
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } else {
      await indodanaCreate(installmentId!);
      await getPendingPayment(useLoading: true);
      await indodanaDeeplink(context);
      Loading.hide();
    }
  }

  OvoResModel? ovoResModel;
  Future<void> ovoCreate(String phone, BuildContext context) async {
    var _bankPayload = BankPayload(
      orderId: '${pendingPaymentResModel?.pendingData?.id}',
      amount: pendingPaymentResModel?.pendingData?.package?.price,
    ).toJson();
    _bankPayload.remove("bank");
    _bankPayload.remove("user_code");
    _bankPayload.putIfAbsent("phone", () => phone);
    var _res = await Api()
        .POST("", _bankPayload, useToken: true, customBaseUrl: "$PAYMENT_GATEWAY$XENDIT_CREATE");
    if (_res?.statusCode == 200) {
      ovoResModel = OvoResModel.fromJson(_res?.data);
      notifyListeners();
      // await Future.delayed(const Duration(seconds: 2));
      // await getPendingPayment(useLoading: true);
    } else {
      ovoResModel = null;
      notifyListeners();
      await cancelPayment();
      Navigator.pop(context);
      Navigator.pop(context);
      return;
    }
  }

  Future<void> ovoGet() async {
    var _bankPayload = BankPayload(
      orderId: '${pendingPaymentResModel?.pendingData?.id}',
      amount: pendingPaymentResModel?.pendingData?.package?.price,
    ).toJson();
    _bankPayload.removeWhere((key, value) => key != "order_id");
    var _res = await Api().POST("", _bankPayload,
        useToken: true, customBaseUrl: "$PAYMENT_GATEWAY$XENDIT_GET", useLoading: false);
    if (_res?.statusCode == 200) {
      ovoResModel = OvoResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      ovoResModel = null;
      notifyListeners();
      return;
    }
  }

  Future<void> _shopee(dynamic shopee) async {
    var _res =
        await Api().POST("", shopee, useToken: true, customBaseUrl: "$PAYMENT_GATEWAY$SHOPEE");
    if (_res?.statusCode == 200) {
      await getPendingPayment(useLoading: true);
      // debugPrint(jsonEncode(_res?.data), wrapWidth: 1024);
    } else {
      return;
    }
  }

  Future<void> shopeeDeepLink(BuildContext context) async {
    try {
      var _url =
          pendingPaymentResModel?.pendingData?.otherResponse!.actions!.map((e) => e.url).first!;
      if (Platform.isAndroid) {
        if (await canLaunch(_url!)) {
          await launch(_url);
        } else {
          await PRO.getPendingPayment(useLoading: true);
          Loading.hide();
          ERROR_SNACK_BAR("Perhatian", "Terjadi Kesalahan");
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } else {
        if (await launchUniversalLinkIos(_url!)) {
        } else {
          await PRO.getPendingPayment(useLoading: true);
          Loading.hide();
          ERROR_SNACK_BAR("Perhatian", "Terjadi Kesalahan");
          Navigator.pop(context);
          Navigator.pop(context);
        }
      }
    } catch (e) {
      await PRO.getPendingPayment(useLoading: true);
      Loading.hide();
      ERROR_SNACK_BAR("Perhatian", "Terjadi Kesalahan");
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  PaymentListResModel? paymentListResModel;
  Future<void> getPaymentList() async {
    var _res =
        await Api().GET("", customBaseUrl: "$PAYMENT_GATEWAY$PAYMENT_LIST_API", useToken: true);
    PR(_res?.data);
    if (_res?.statusCode == 200) {
      paymentListResModel = PaymentListResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  Future<void> cancelPayment() async {
    try {
      var _res = await Api().POST(
          DELETE_PAYMENT(id: pendingPaymentResModel!.pendingData!.id!.toString()), {},
          useToken: true);
      if (_res?.statusCode == 200) {
        SUCCESS_SNACK_BAR("Perhatian", _res?.data['message']);
        await getPendingPayment(useLoading: true);
      } else {
        return;
      }
    } catch (e) {
      print("didnt have pending paymant");
    }
  }

  UserData? userData;
  void readLocalUser({bool isPrint = false}) {
    try {
      var _user = _box.read(USER_STORAGE);
      userData = UserData.fromJson(_user);
      isPrint ? PR(userData?.toJson()) : null;
      !isPrint ? notifyListeners() : null;
    } catch (e) {
      // print("Welcome");
    }
  }

  Future<void> saveLocalUser(UserData? data) async {
    // Write to local storage
    await _box.write(USER_STORAGE, data?.toJson());
    // Update state
    userData = data;
    notifyListeners();
  }

  Future<void> savePinCode(String pin) async {
    // Write to local storage
    await _box.write(PIN_CODE_STORAGE, pin);
    // Update state
    notifyListeners();
  }

  Future<void> clearAllData() async {
    userData = null;
    counselorData = null;
    pendingPaymentResModel = null;
    pendingKalmselorCodeModel = null;
    pendingPaymentResModel = null;
    ovoResModel = null;
    tncResModel = null;
    indodanaResModel = null;
    notifyListeners();
    await _box.remove(USER_STORAGE);
    await _box.remove(PIN_CODE_STORAGE);
    await Get.offAll(LoginPage());
  }

  RegisterPayload? registerPayload;
  void updateRegisterPayload(RegisterPayload? payload) {
    registerPayload = payload;
    notifyListeners();
  }

  int sendProgress = 0;
  void onSendProgresss(int send, int total) {
    var _send = ((send / total) * 100).toInt();
    // print("SEND $_send");
    sendProgress = _send;
    notifyListeners();
  }

  int receiveProgress = 0;
  void onReceiveProgresss(int send, int total) {
    var _receive = ((total / send) * 100).toInt();
    // print("RECEIVE $_receive");
    receiveProgress = _receive;
    notifyListeners();
  }

  QuoteResModel? quoteResModel;
  Future<void> getQuote() async {
    print("get quote");
    var _res = await Api().GET(INSPIRATION_QOUTE, useLoading: false);
    if (_res?.statusCode == 200) {
      quoteResModel = QuoteResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  ArticleResModel? articleHomeResModel;
  Future<void> getHomeArticles() async {
    print("get home article");
    var _res = await Api().GET(USER_ARTICLE, useLoading: false);
    if (_res?.statusCode == 200) {
      articleHomeResModel = ArticleResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  ArticleResModel? articleDirectoryResModel;
  Future<void> getDirectoryArticles() async {
    print("get directory article");
    var _res = await Api().GET(ARTICLE_DATA, useLoading: false);
    if (_res?.statusCode == 200) {
      articleDirectoryResModel = ArticleResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  DirectoryResModel? directoryResModel;
  Future<void> getDirectoryPlace() async {
    print("get directory");
    var _res = await Api().GET(DIRECTORY_SORTED, useLoading: false);
    if (_res?.statusCode == 200) {
      directoryResModel = DirectoryResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  List<String?>? videoList;
  Future<void> getVideos() async {
    print("get videos");
    var _res = await Api().GET(PAGE_DIR(10), useLoading: false);
    var _res2 = await Api().GET(PAGE_DIR(12), useLoading: false);
    var _vid1 = DirectoryPageResModel.fromJson(_res?.data);
    var _vid2 = DirectoryPageResModel.fromJson(_res2?.data);
    videoList = [youtubeFindId(_vid1.data?.file), youtubeFindId(_vid2.data?.file)];
    notifyListeners();
  }

  String? youtubeFindId(String? url) {
    try {
      return url?.replaceAll("https://youtu.be/", "").replaceAll("https://youtube.com/", "");
    } catch (e) {
      return null;
    }
  }

  CountryResModel? countryResModel;
  Future<void> getCountry({bool useLoading = true}) async {
    stateResItem = null;
    cityResItem = null;
    var _res = await Api().GET(GET_COUNTRIES, useToken: true, useLoading: useLoading);
    if (_res?.statusCode == 200) {
      countryResModel = CountryResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  AddressResItem? stateResItem;
  Future<void> getStates(int? countryId) async {
    cityResItem = null;
    var _res = await Api().GET(GET_STATES(id: countryId), useToken: true, useLoading: false);
    if (_res?.statusCode == 200) {
      stateResItem = AddressResItem.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  AddressResItem? cityResItem;
  Future<void> getCity(int? stateId) async {
    var _res = await Api().GET(GET_CITIES(id: stateId), useToken: true, useLoading: false);
    // PR(_res?.data);
    if (_res?.statusCode == 200) {
      cityResItem = AddressResItem.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  AboutResModel? aboutResModel;
  Future<void> getAboutUs() async {
    var _res = await Api().GET(ABOUT_KALM);
    if (_res?.statusCode == 200) {
      aboutResModel = AboutResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  UserQuetionerResModel? userQuestionerResModel;
  List<UserQuestionerPayload?>? payloaditem;
  Future<void> getUserQuestioner({bool useLoading = true}) async {
    var _res = await Api().GET(QUESTIONER, useToken: true, useLoading: useLoading);
    if (_res?.statusCode == 200) {
      userQuestionerResModel = UserQuetionerResModel.fromJson(_res?.data);
      payloaditem = List.generate(userQuestionerResModel!.questionerData!.length, (i) => null);
      notifyListeners();
    } else {
      return;
    }
  }

  List<MatchupData>? userMatchupResModel;
  List<UserMatchupPayload?> userMatchupPayload = [];
  Future<void> getUserMatchup({bool useLoading = true}) async {
    var _res = await Api().GET(MATCHUP, useToken: true, useLoading: useLoading);
    if (_res?.statusCode == 200) {
      userMatchupResModel = UserMatchupResModel.fromJson(_res?.data)
          .matchupData
          ?.where((e) => e.id == 5 || e.id == 1)
          .toList();
      userMatchupPayload = List.generate(userMatchupResModel!.length, (index) {
        return null;
      });
      notifyListeners();
    } else {
      return;
    }
  }

  int? statusTestDebug;
  void changeStatusTestDebug(int i) {
    statusTestDebug = i;
    notifyListeners();
  }

  bool keyboardVisibility = false;
  void updateKeyboardVisibility(bool visible) {
    keyboardVisibility = visible;
    notifyListeners();
  }

  FaqResModel? faqResModel;
  Future<void> getFaq() async {
    var _res = await Api().GET(FAQ_CATEGORY);
    if (_res?.statusCode == 200) {
      faqResModel = FaqResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  HowToResModel? howToResModel;
  Future<void> getHowTo() async {
    var _res = await Api().GET(HOW_TO);
    if (_res?.statusCode == 200) {
      howToResModel = HowToResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  HowToResModel? privacyPolicyResModel;
  Future<void> getPrivacyPolicy() async {
    var _res = await Api().GET(PRIVACY);
    if (_res?.statusCode == 200) {
      privacyPolicyResModel = HowToResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  HowToResModel? termAndConditionResModel;
  Future<void> getTermAndCondition() async {
    var _res = await Api().GET(TERM_AND_CONDITION_CATEGORY);
    if (_res?.statusCode == 200) {
      termAndConditionResModel = HowToResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  late List<List<TextEditingController>> gratitudeEditingController;
  GratitudeResModel? gratitudeJournalResModel;
  Future<void> getGratitudeJournal({bool useLoading = true}) async {
    var _res = await Api().GET(GRATITUDE_JOURNAL, useToken: true, useLoading: useLoading);
    if (_res?.statusCode == 200) {
      gratitudeJournalResModel = GratitudeResModel.fromJson(_res?.data);
      gratitudeEditingController =
          List.generate(gratitudeJournalResModel?.gratitudeData?.length ?? 0, (i) {
        var _data = gratitudeJournalResModel!.gratitudeData![i];
        if (_data.response != null) {
          return List.generate(
              _data.response?.length ?? 0, (j) => TextEditingController(text: _data.response![j]));
        } else {
          return List.generate(3, (j) => TextEditingController());
        }
      });
      notifyListeners();
    } else {
      return;
    }
  }

  late List<List<TextEditingController>> gratitudeHistoryEditingController;
  GratitudeResModel? gratitudeJournalHistoryResModel;
  Future<void> getGratitudeJournalHistory({bool useLoading = true}) async {
    var _res = await Api().GET(GRATITUDE_WALL, useToken: true, useLoading: useLoading);
    if (_res?.statusCode == 200) {
      gratitudeJournalHistoryResModel = GratitudeResModel.fromJson(_res?.data);
      gratitudeHistoryEditingController = List.generate(
          gratitudeJournalHistoryResModel?.gratitudeJournalHistoryResModel?.length ?? 0, (i) {
        var _data = gratitudeJournalHistoryResModel!.gratitudeJournalHistoryResModel![i];
        if (_data.answer != null) {
          return List.generate(
              _data.answer?.length ?? 0, (j) => TextEditingController(text: _data.answer![j]));
        } else {
          return List.generate(3, (j) => TextEditingController());
        }
      });
      notifyListeners();
    } else {
      return;
    }
  }
}

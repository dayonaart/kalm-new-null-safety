import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/address_payload.dart';
import 'package:kalm/model/user_model/user_model.dart';
import 'package:kalm/model/user_questioner_payload.dart';
import 'package:kalm/model/user_quetioner_res_model/questioner_data.dart';
import 'package:kalm/model/user_quetioner_res_model/user_quetioner_res_model.dart';
import 'package:kalm/pages/questioner_page.dart/user_questioner_match_up_page.dart';
import 'package:kalm/utilities/date_format.dart';
import 'package:kalm/utilities/util.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/date_picker.dart';
import 'package:kalm/widget/dialog.dart';
import 'package:kalm/widget/loading.dart';
import 'package:kalm/widget/loading_content.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'package:kalm/widget/textfield.dart';
import 'package:url_launcher/url_launcher.dart';

class UserQustionerPage extends StatelessWidget {
  List<UserQuestionerPayload?>? existingAnswer;
  UserQustionerPage({Key? key, this.existingAnswer}) : super(key: key);
  final _controller = Get.put(UserQustionerController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserQustionerController>(initState: (st) async {
      await PRO.getUserQuestioner(useLoading: false);
      await PRO.getCountry(useLoading: false);
      if (PRO.userData?.status == 1) {
        await PRO.getStates(PRO.userData?.countryId);
        await PRO.getCity(PRO.userData?.stateId);
        for (var i = 0; i < existingAnswer!.length; i++) {
          if (i == 0) {
            try {
              _controller.selectingTempCountry = ADDRESS_ROOT()
                  ?.where((e) => e.id == PRO.userData?.countryId)
                  .first
                  .name;
              _controller.selectingTempState = STATES_DATA()
                  ?.where((e) => e.id == PRO.userData?.stateId)
                  .first
                  .name;
              _controller.selectingTempCity = CITIES_DATA()
                  ?.where((e) => e.id == PRO.userData?.cityId)
                  .first
                  .name;
            } catch (e) {}
          } else if (i == 1) {
            _controller.selectedDate = PRO.userData!.dob;
          } else {
            _controller.updatePayload(existingAnswer![i]!, i);
          }
        }
      }
    }, builder: (_) {
      return SAFE_AREA(
          canBack: existingAnswer != null,
          child: Builder(builder: (context) {
            if ((_.userQuestionerResModel(context: context) == null) &&
                _.userQuestionerResModel(context: context)?.questionerData ==
                    null) {
              return LOADING;
            } else {
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        TEXT("Bantu Kami mengenal Anda lebih baik",
                            style: Get.textTheme.headline1,
                            textAlign: TextAlign.center),
                        SPACE(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _
                              .userQuestionerResModel(context: context)!
                              .questionerData!
                              .map((e) {
                            var _index = _
                                .userQuestionerResModel(context: context)
                                ?.questionerData
                                ?.indexWhere((element) =>
                                    element.question == e.question);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _question(_index, e),
                                SPACE(height: 20),
                                _answer(_, e, _index!),
                                SPACE(height: 20),
                              ],
                            );
                          }).toList(),
                        ),
                        SPACE(height: 20),
                        if (existingAnswer == null)
                          SizedBox(
                              width: Get.width / 1.5,
                              child: BUTTON("Selanjutnya",
                                  onPressed: () async =>
                                      await _.submit(context),
                                  verticalPad: 15,
                                  circularRadius: 30))
                      ],
                    ),
                  )
                ],
              );
            }
          }));
    });
  }

  Row _question(int? _index, QuestionerData e) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: BLUEKALM,
          radius: 15,
          child: TEXT('${_index! + 1}',
              style: COSTUM_TEXT_STYLE(color: Colors.white)),
        ),
        SPACE(),
        Expanded(child: TEXT(e.question)),
      ],
    );
  }

  Builder _answer(UserQustionerController _, QuestionerData e, int i) {
    return Builder(builder: (context) {
      try {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 5,
                mainAxisExtent: 40,
                crossAxisCount:
                    (e.answer?.length ?? 2) < 4 ? (e.answer?.length ?? 2) : 2),
            children: e.answer!.map((ans) {
              return OUTLINE_BUTTON(ans.answer ?? "",
                  onPressed: existingAnswer != null
                      ? null
                      : () => _.updatePayload(
                          UserQuestionerPayload(
                              questionnaireId: e.id,
                              answer: ans.id,
                              answerDescription: ans.answer,
                              question: e.question),
                          i),
                  backgroundColor: (_.payloaditem()?[i]?.answer == ans.id)
                      ? existingAnswer != null
                          ? Colors.grey
                          : BLUEKALM
                      : Colors.white,
                  textColor: (_.payloaditem()?[i]?.answer == ans.id)
                      ? Colors.white
                      : BLUEKALM);
            }).toList(),
          ),
        );
      } catch (err) {
        if (i == 0) {
          return _selectAddress(_, context);
        } else {
          return _dobQuestion(_, e, i);
        }
      }
    });
  }

  Column _selectAddress(UserQustionerController _, BuildContext context) {
    return Column(
      children: [
        CupertinoTextField(
          controller: TextEditingController(text: _.selectingTempCountry),
          placeholder: "Pilih Negara",
          readOnly: true,
          onTap: existingAnswer != null
              ? null
              : () async {
                  _.selectingTempCountry = PRO.countryResModel?.data![0].name;
                  await _bottomSheetAddress(_,
                      title: "Pilih Negara",
                      condition: "country",
                      data: PRO.countryResModel?.data,
                      onSelecting: (i, st) => _.selectTempCountry(i, st),
                      onSelected: () => _.selectAddress("country"));
                  await PRO.getStates(_.addressPayload['country']);
                },
        ),
        if (_.addressPayload['country'] != 3)
          CupertinoTextField(
            controller: TextEditingController(text: _.selectingTempState),
            placeholder: "Pilih Wilayah",
            readOnly: true,
            onTap: existingAnswer != null
                ? null
                : STATE(context).stateResItem == null
                    ? null
                    : () async {
                        _.selectingTempState = PRO.stateResItem?.data![0].name;
                        await _bottomSheetAddress(_,
                            title: "Pilih Wilayah",
                            condition: "state",
                            data: PRO.stateResItem?.data,
                            onSelecting: (i, st) => _.selectTempState(i, st),
                            onSelected: () => _.selectAddress("state"));
                        await PRO.getCity(_.addressPayload['state']);
                      },
          ),
        if (_.addressPayload['country'] != 3)
          CupertinoTextField(
            controller: TextEditingController(text: _.selectingTempCity),
            placeholder: "Pilih kota",
            readOnly: true,
            onTap: existingAnswer != null
                ? null
                : STATE(context).cityResItem == null
                    ? null
                    : () async {
                        _.selectingTempCity = PRO.cityResItem?.data![0].name;
                        await _bottomSheetAddress(_,
                            title: "Pilih Kota",
                            condition: "city",
                            data: PRO.cityResItem?.data,
                            onSelecting: (i, st) => _.selectTempCity(i, st),
                            onSelected: () => _.selectAddress("city"));
                      },
          ),
      ],
    );
  }

  String? addressCondition(String? condition) {
    if (condition == "country") {
      return _controller.selectingTempCountry;
    } else if (condition == "state") {
      return _controller.selectingTempState;
    } else {
      return _controller.selectingTempCity;
    }
  }

  Future<void> _bottomSheetAddress(
    UserQustionerController _, {
    @required String? condition,
    @required String? title,
    @required List<dynamic>? data,
    required void Function(int i, void Function(void Function()) st)
        onSelecting,
    void Function()? onSelected,
  }) async {
    await Get.bottomSheet(StatefulBuilder(builder: (context, st) {
      return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        height: Get.height / 4,
        child: Column(
          children: [
            SPACE(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TEXT(title),
                  OUTLINE_BUTTON("Pilih",
                      useExpanded: false, onPressed: onSelected),
                ],
              ),
            ),
            Expanded(
              child: ListWheelScrollView.useDelegate(
                itemExtent: 40,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (i) => onSelecting(i, st),
                childDelegate: ListWheelChildListDelegate(
                  children: List.generate(data?.length ?? 0, (i) {
                    return Container(
                        width: Get.width / 1.2,
                        decoration: BoxDecoration(
                            border: data?[i].name == addressCondition(condition)
                                ? Border.all(width: 0.5, color: BLUEKALM)
                                : null,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: TEXT(data?[i].name),
                        ));
                  }),
                ),
              ),
            ),
          ],
        ),
      );
    }), isDismissible: false);
  }

  Column _dobQuestion(UserQustionerController _, QuestionerData e, int i) {
    return Column(
      children: [
        CupertinoTextField(
          placeholder: "Tanggal Lahir",
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          prefix: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.date_range_outlined,
              color: BLUEKALM,
            ),
          ),
          suffix: Builder(builder: (context) {
            try {
              if (VALIDATE_DOB_MATURE(_.selectedDate)! <= 12.999) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.dangerous_outlined,
                    color: Colors.red,
                  ),
                );
              } else {
                return Container();
              }
            } catch (e) {
              return Container();
            }
          }),
          readOnly: true,
          onTap: existingAnswer != null
              ? null
              : () async {
                  _datePicker(_, e, i);
                },
          controller: TextEditingController(text: DATE_FORMAT(_.selectedDate)),
        ),
        Builder(builder: (context) {
          try {
            if (VALIDATE_DOB_MATURE(_.selectedDate)! <= 12.999) {
              return Column(
                children: [
                  SPACE(),
                  ERROR_VALIDATION_FIELD(_.dobAlertMessage(e.description),
                      useOverFlow: false),
                ],
              );
            } else {
              return Container();
            }
          } catch (e) {
            return Container();
          }
        }),
        Builder(builder: (context) {
          try {
            if (VALIDATE_DOB_MATURE(_.selectedDate)! >= 12.999 &&
                VALIDATE_DOB_MATURE(_.selectedDate)! < 14) {
              return Column(
                children: [
                  SPACE(),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 0.5, color: BLUEKALM)),
                    child: Row(
                      children: [
                        Checkbox(
                            value: _.validateDob13,
                            onChanged: (val) => _.updateDob13(val!)),
                        Expanded(
                            child: TEXT(
                                "Saya berusia 13 tahun keatas dan ingin menggunakan aplikasi ini"))
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          } catch (e) {
            return Container();
          }
        })
      ],
    );
  }

  void _datePicker(UserQustionerController _, QuestionerData e, int i) {
    Get.bottomSheet(
      DatePicker(
        onSubmit: (date) {
          _.setInitialDateContoller(date);
          _.updatePayload(
              UserQuestionerPayload(
                  questionnaireId: e.id,
                  answer: 0,
                  answerDescription: (VALIDATE_DOB_MATURE(date)! <= 12.999)
                      ? null
                      : date.toIso8601String(),
                  question: e.question),
              i);
          if ((VALIDATE_DOB_MATURE(date)! <= 12.999)) {
            _.validateDob13 = false;
          }
        },
        title: "Pilih Tanggal",
        height: Get.height / 3,
        controller: _.dateController,
        locale: DatePickerLocale.id_ID,
        pickerDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: BLUEKALM, width: 2.0)),
        config: DatePickerConfig(
            isLoop: false, selectedTextStyle: COSTUM_TEXT_STYLE()),
        onChanged: (date) {},
      ),
    );
  }
}

class UserQustionerController extends GetxController {
  UserQuetionerResModel? userQuestionerResModel({BuildContext? context}) {
    try {
      return STATE(context!).userQuestionerResModel;
    } catch (e) {
      return PRO.userQuestionerResModel;
    }
  }

  List<UserQuestionerPayload?>? payloaditem() {
    return PRO.payloaditem;
  }

  late DatePickerController dateController;
  bool validateDob13 = false;

  String? dobAlertMessage(String? desc) {
    try {
      return "${desc?.replaceRange(0, desc.indexOf("Anda"), '')}";
    } catch (err) {
      return desc;
    }
  }

  void updateDob13(bool val) {
    validateDob13 = val;
    update();
  }

  DateTime? selectedDate;
  void updatePayload(UserQuestionerPayload _payloadItem, int i) {
    payloaditem()![i] = _payloadItem;
    if (i == 4 && payloaditem()![4]?.answer == 1) {
      // ERROR_SNACK_BAR("Perhatian!", userQuetionerResModel?.questionerData![i].description);
      payloaditem()![i] = null;
      SHOW_DIALOG(
          "${userQuestionerResModel()?.questionerData![i].description}\n\nHubungi 199",
          onAcc: () async {
        final Uri launchUri = Uri(
          scheme: 'tel',
          path: "199",
        );
        Get.back();
        await launch(launchUri.toString());
      });
    }
    update();
  }

  void setInitialDateContoller(DateTime initialDate) {
    selectedDate = initialDate;
    update();
    dateController = DatePickerController(
        initialDateTime: initialDate,
        minYear: 1900,
        maxYear: DateTime.now().year);
  }

  String? selectingTempCountry;
  void selectTempCountry(int i, void Function(void Function()) st) {
    st(() {
      selectingTempCountry = PRO.countryResModel?.data![i].name;
    });
    update();
  }

  String? selectingTempState;
  void selectTempState(int i, void Function(void Function()) st) {
    st(() {
      selectingTempState = PRO.stateResItem?.data![i].name;
    });
    update();
  }

  String? selectingTempCity;
  void selectTempCity(int i, void Function(void Function()) st) {
    st(() {
      selectingTempCity = PRO.cityResItem?.data![i].name;
    });
    update();
  }

  Map<String, int?> addressPayload = AddressPayload().toJson();
  void selectAddress(String condition) {
    if (condition == 'country') {
      selectingTempState = null;
      selectingTempCity = null;
      var _seleted = PRO.countryResModel?.data!
          .where((e) => e.name == selectingTempCountry)
          .first;
      addressPayload.update('country', (value) => _seleted!.id!);
      addressPayload.update('state', (value) => null);
      addressPayload.update('city', (value) => null);
    } else if (condition == 'state') {
      selectingTempCity = null;
      var _seleted = PRO.stateResItem?.data!
          .where((e) => e.name == selectingTempState)
          .first;
      addressPayload.update('state', (value) => _seleted!.id!);
      addressPayload.update('city', (value) => null);
    } else {
      var _seleted = PRO.cityResItem?.data!
          .where((e) => e.name == selectingTempCity)
          .first;
      addressPayload.update('city', (value) => _seleted!.id!);
    }
    updatePayload(
        UserQuestionerPayload(
            questionnaireId: userQuestionerResModel()!.questionerData![0].id,
            answer: 0,
            answerDescription: addressPayload,
            question: userQuestionerResModel()!.questionerData![0].question),
        0);
    update();
    Get.back();
  }

  Future<void> submit(BuildContext context) async {
    if (payloaditem()!.every((e) => e == null)) {
      ERROR_SNACK_BAR(null, "Pastikan Anda telah mengisi jawaban kuisioner");
      return;
    } else if (payloaditem()!.contains(null)) {
      var _nullAnswer = payloaditem()?.indexOf(null);
      if (_nullAnswer == 0 && payloaditem()![0] == null) {
        ERROR_SNACK_BAR("Wajib diisi semua!",
            userQuestionerResModel()?.questionerData![_nullAnswer!].question);
      } else if (AddressPayload.fromJson(payloaditem()![0]?.answerDescription)
              .toJson()
              .containsValue(null) &&
          AddressPayload.fromJson(payloaditem()![0]?.answerDescription)
                  .country !=
              3) {
        ERROR_SNACK_BAR("Wajib diisi semua!",
            userQuestionerResModel()?.questionerData![0].question);
        return;
      } else {
        ERROR_SNACK_BAR("Wajib diisi!",
            userQuestionerResModel()?.questionerData![_nullAnswer!].question);
      }
      return;
    } else if (selectedDate != null &&
        VALIDATE_DOB_MATURE(selectedDate)! <= 12.999) {
      ERROR_SNACK_BAR(
          "Perhatian!",
          dobAlertMessage(
              userQuestionerResModel()!.questionerData![1].description));
      return;
    } else if (selectedDate != null &&
        (VALIDATE_DOB_MATURE(selectedDate)! >= 12.999 &&
            VALIDATE_DOB_MATURE(selectedDate)! <= 14) &&
        !validateDob13) {
      ERROR_SNACK_BAR("Perhatian!", "Anda Belum menyetujui syarat usia Anda");
      return;
    }

    var _res = await Api().POST(POST_QUESTIONER,
        {"role": "10", "data": payloaditem()?.map((e) => e?.toJson()).toList()},
        useToken: true);
    if (_res?.statusCode == 200) {
      await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
      Loading.hide();
      pushReplacementNewScreen(context, screen: UserQustionerMatchupPage());
    } else {
      Loading.hide();
      return;
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    dateController = DatePickerController(
        initialDateTime: DateTime.now(),
        minYear: 1900,
        maxYear: DateTime.now().year);
  }
}

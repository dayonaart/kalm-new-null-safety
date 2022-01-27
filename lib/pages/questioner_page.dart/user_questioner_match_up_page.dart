import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/user_matchup_payload.dart';
import 'package:kalm/model/user_matchup_res_model/matchup_answer.dart';
import 'package:kalm/model/user_matchup_res_model/matchup_datum.dart';
import 'package:kalm/model/user_model/user_model.dart';
import 'package:kalm/tab_pages/chat_page.dart';
import 'package:kalm/utilities/text_input_formatter.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/dialog.dart';
import 'package:kalm/widget/loading.dart';
import 'package:kalm/widget/loading_content.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class UserQustionerMatchupPage extends StatelessWidget {
  List<int>? gridAnswer;
  List<int>? languageAnswer;
  bool? isEdit;

  UserQustionerMatchupPage({
    Key? key,
    this.gridAnswer,
    this.languageAnswer,
    this.isEdit = true,
  }) : super(key: key);
  final _controller = Get.put(UserQustionerMatchupController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserQustionerMatchupController>(initState: (st) async {
      await PRO.getUserMatchup(useLoading: false);
      if (gridAnswer != null) {
        _controller.updateExistingPayload(gridAnswer, languageAnswer);
      }
      Loading.hide();
    }, builder: (_) {
      return SAFE_AREA(
          canBack: gridAnswer != null,
          child: Builder(builder: (context) {
            if ((_.userMatchupResModel(context: context) == null)) {
              return LOADING;
            } else {
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _.userMatchupResModel(context: context)!.map((a) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 0.5, color: BLUEKALM)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: TEXT(a.question,
                                        style: COSTUM_TEXT_STYLE(
                                            fonstSize: 18, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                if (a.id == 5)
                                  Column(
                                    children: a.matchupAnswers!.map((b) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SPACE(height: 20),
                                          Container(
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    topRight: Radius.circular(10)),
                                                border: Border.all(width: 1, color: BLUEKALM)),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              child: TEXT(b.answer,
                                                  style: COSTUM_TEXT_STYLE(
                                                      fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.only(
                                                      bottomLeft: Radius.circular(10),
                                                      bottomRight: Radius.circular(10)),
                                                  border: Border.all(width: 0.5, color: BLUEKALM)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: _gridAnswer(a.id, b),
                                              ))
                                        ],
                                      );
                                    }).toList(),
                                  )
                                else
                                  _languageAnswer(a.matchupAnswers)
                              ],
                            );
                          }).toList(),
                        ),
                        if (isEdit!)
                          Column(
                            children: [
                              if (PRO.userData?.status == 1) _kalmselorCode(_),
                              SPACE(height: 20),
                              BUTTON("Selanjutnya",
                                  onPressed: _.userMatchupPayload().contains(null)
                                      ? null
                                      : () async => await _.submit(context),
                                  verticalPad: 15,
                                  circularRadius: 30)
                            ],
                          )
                      ],
                    ),
                  ),
                ],
              );
            }
          }));
    });
  }

  Column _kalmselorCode(UserQustionerMatchupController _) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SPACE(height: 20),
        TEXT("Kalmselor Code ( Opsional )"),
        SPACE(height: 5),
        SizedBox(
          height: 50,
          child: CupertinoTextField(
            controller: _.kalmselorCodeController,
            placeholder: "XXX-XXX",
            textCapitalization: TextCapitalization.characters,
            textAlignVertical: TextAlignVertical.center,
            style: COSTUM_TEXT_STYLE(color: BLUEKALM, fonstSize: 20, fontWeight: FontWeight.w600),
            inputFormatters: [CustomInputFormatter(mask: "xxx-xxx", separator: "-")],
            decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: BLUEKALM),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SPACE(),
        InkWell(
          onTap: () => _.onChangeKalmselorCodeHint(),
          child: Row(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TEXT("!"),
                ),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 0.2)),
              ),
              SPACE(height: 5),
              TEXT('Kalmselor Code')
            ],
          ),
        ),
        AnimatedContainer(
          height: _.kalmselorCodeHint ? 60 : 0,
          duration: const Duration(milliseconds: 500),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TEXT(
                  "Masukan Kalmselor Code milik Kalmselor\npilihan Anda untuk segera terhubung"),
            ),
          ),
        )
      ],
    );
  }

  String _languangeAnswer(List<MatchupAnswer?>? answer) {
    try {
      return answer!
          .singleWhere((e) => e!.id == _controller.userMatchupPayload().first!.answer!.first)!
          .answer!;
    } catch (e) {
      return "Pilih Bahasa";
    }
  }

  _languageAnswer(List<MatchupAnswer?>? matchupAnswers) {
    return Column(
      children: [
        SPACE(),
        CupertinoTextField(
          style: COSTUM_TEXT_STYLE(color: BLUEKALM),
          controller: TextEditingController(text: _languangeAnswer(matchupAnswers)),
          readOnly: true,
          onTap: !isEdit!
              ? null
              : () async {
                  int? _answer = 1;
                  await Get.bottomSheet(StatefulBuilder(builder: (context, st) {
                    return Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                      height: Get.height / 4.5,
                      child: Column(
                        children: [
                          SPACE(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TEXT("Pilih Bahasa"),
                                OUTLINE_BUTTON("Pilih",
                                    useExpanded: false,
                                    onPressed: () => _controller.updatePayload(
                                        _controller.userMatchupResModel()!.first.id, _answer)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 40,
                              physics: const FixedExtentScrollPhysics(),
                              onSelectedItemChanged: (i) {
                                st(() {
                                  _answer = matchupAnswers?[i]?.id;
                                });
                              },
                              childDelegate: ListWheelChildListDelegate(
                                children: matchupAnswers!.map((e) {
                                  return Container(
                                      width: Get.width / 1.2,
                                      decoration: BoxDecoration(
                                          border: e?.id == _answer
                                              ? Border.all(width: 0.5, color: BLUEKALM)
                                              : null,
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Center(
                                        child: TEXT(e?.answer),
                                      ));
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }), isDismissible: true);
                },
        ),
        SPACE(height: 20),
      ],
    );
  }

  GridView _gridAnswer(int? qId, MatchupAnswer b) {
    return GridView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisExtent: 40, mainAxisSpacing: 5),
      children: b.answerChildren!.map((c) {
        return InkWell(
          onTap: () {
            if (!isEdit!) {
              return;
            } else {
              _controller.updatePayload(qId, c.id);
            }
          },
          child: SizedBox(
              child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                      decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: _activeColorAnswer(_controller.answerPayload.contains(c.id)),
                  )),
                ),
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: BLUEKALM),
                    borderRadius: BorderRadius.circular(5)),
              ),
              SPACE(),
              SizedBox(width: Get.width / 3.5, child: TEXT(c.answer, textAlign: TextAlign.start)),
            ],
          )),
        );
      }).toList(),
    );
  }

  Color _activeColorAnswer(bool condition) {
    switch (condition) {
      case true:
        if (!isEdit!) {
          return Colors.grey;
        } else {
          return ORANGEKALM;
        }
      case false:
        return Colors.white;
      default:
        return Colors.white;
    }
  }
}

class UserQustionerMatchupController extends GetxController {
  List<MatchupData>? userMatchupResModel({BuildContext? context}) {
    try {
      return STATE(context!).userMatchupResModel;
    } catch (e) {
      return PRO.userMatchupResModel;
    }
  }

  List<UserMatchupPayload?> userMatchupPayload() {
    return PRO.userMatchupPayload;
  }

  List<int?> answerPayload = [];
  TextEditingController kalmselorCodeController = TextEditingController();
  bool kalmselorCodeHint = false;
  void onChangeKalmselorCodeHint() {
    kalmselorCodeHint = !kalmselorCodeHint;
    update();
  }

  void updateExistingPayload(List<int?>? gridAnswer, List<int?>? languageAnswer) {
    answerPayload = gridAnswer!;
    userMatchupPayload()[0] = UserMatchupPayload(question: 1, answer: languageAnswer);
    userMatchupPayload()[1] = UserMatchupPayload(question: 1, answer: gridAnswer);
    update();
  }

  void updatePayload(int? qId, int? answer) {
    int? i = userMatchupResModel()?.indexWhere((a) => a.id == qId);
    if (i == 0) {
      userMatchupPayload()[i!] = UserMatchupPayload(question: qId, answer: [answer]);
      Get.back();
    } else {
      if (answerPayload.contains(answer)) {
        answerPayload.remove(answer);
      } else {
        answerPayload.add(answer);
      }
      userMatchupPayload()[i!] = UserMatchupPayload(question: qId, answer: answerPayload);
    }
    update();
  }

  Future<UserModel?> _checkKalmselorCode() async {
    var _checkCode = await Api().GET(CHECK_UNIQCODE + kalmselorCodeController.text, useToken: true);
    if (_checkCode?.statusCode == 200) {
      return UserModel.fromJson(_checkCode!.data);
    } else {
      return null;
    }
  }

  Future<bool> _assignKalmselorCode() async {
    var _assignCode = await Api()
        .POST(ASSIGN_UNIQCODE, {"unique_code": kalmselorCodeController.text}, useToken: true);
    // print(_assignCode?.toJson());
    if (_assignCode?.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> submit(BuildContext context) async {
    if (kalmselorCodeController.text.isNotEmpty) {
      var _res = await _checkKalmselorCode();
      if (_res == null) {
        return;
      } else {
        await SHOW_DIALOG("${_res.message}\n${_res.data?.firstName} ${_res.data?.lastName ?? ""}",
            customButton: BUTTON("Selanjutnya", onPressed: () async {
              Get.back();
              if (await _assignKalmselorCode()) {
                await _finalSubmit(context);
              } else {
                Loading.hide();
                return;
              }
            }));
      }
      return;
    } else {
      await _finalSubmit(context);
    }
  }

  Future<void> _finalSubmit(BuildContext context) async {
    var _payload = userMatchupPayload().map((e) {
      if (e?.question == 5) {
        e?.answer?.sort((a, b) {
          return a!.compareTo(b!);
        });
        return e?.toJson();
      } else {
        return e?.toJson();
      }
    }).toList();
    // print(_payload);
    var _res = await Api()
        .POST(MATCHUP, {"user_code": PRO.userData?.code, "data": _payload}, useToken: true);
    if (_res?.statusCode == 200) {
      await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
      Loading.hide();
      Navigator.pop(context);
    } else {
      Loading.hide();
      return;
    }
  }
}

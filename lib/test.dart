import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/model/matchup_model/matchup_model.dart';
import 'package:kalm/model/matchup_res_model.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:get/get.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class TestPage extends StatelessWidget {
  final _c = Get.put(QController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QController>(builder: (_) {
      debugPrint("${_.finalData?.map((e) => jsonEncode(e.toJson())).toList()}",
          wrapWidth: 1024);
      return SAFE_AREA(
          child: SizedBox(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SPACE(height: 20),
            SizedBox(
                width: Get.width / 2,
                child: BUTTON("Query", onPressed: () async {
                  await _.getMatchupJson(context);
                })),
            if (_.finalData != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SPACE(height: 20),
                    if (_.totalData != null)
                      TEXT("TOTAL DATA ${_.totalData}",
                          style: Get.textTheme.headline1),
                    SPACE(height: 20),
                    SizedBox(
                      height: Get.height / 1.5,
                      width: Get.width,
                      child: ListView(
                        children: _.finalData!.map((e) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: BLUEKALM)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Builder(builder: (context) {
                                  try {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SPACE(),
                                        TEXT(e.question,
                                            style: Get.textTheme.bodyText2),
                                        SPACE(),
                                        TEXT("# ${e.answer}",
                                            style: Get.textTheme.bodyText1),
                                        SPACE(),
                                        Row(
                                          children: [
                                            TEXT("TOTAL : "),
                                            TEXT(
                                              "${e.total}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: ORANGEKALM,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  } catch (err) {
                                    return Text(
                                      "${e.toJson()}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    );
                                  }
                                }),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ));
    });
  }
}

class QController extends GetxController {
  Future<List<List<int>?>>? getAsset(BuildContext context) async {
    String data = await rootBundle.loadString('assets/icon/kalm.json');
    var jsonResult = json.decode(data) as List<dynamic>;
    var datas = List.generate(
        jsonResult.length, (i) => MatchupModel.fromJson(jsonResult[i]));
    datas.removeWhere((e) => e.matchupJson == null);
    // ignore: unused_local_variable
    var _fixTipeData = datas
        .map((e) => e.matchupJson?.map((d) {
              return d.answer?.map((e) {
                if (e.runtimeType == int) {
                  return e as int;
                } else {
                  return int.parse(e);
                }
              }).toList();
            }).last)
        .toList();
    return _fixTipeData;
  }

  List<DataMatchModel>? finalData;
  int? totalData;
  Future<void> getMatchupJson(BuildContext context) async {
    var _local = await getAsset(context);
    var _res = await Api().GET(MATCHUP, useToken: true);
    var matchUpdata = MatchupResModel.fromJson(_res!.data);
    var matchDataRes =
        matchUpdata.data?.where((e) => (e.category == 2 || e.id == 5)).toList();
    finalData = matchDataRes
        ?.map((e) {
          return e.matchupAnswers
              ?.map((d) {
                return d.answerChildren
                    ?.map((f) => "${f.id}--${f.answer}--${d.answer}")
                    .toList()
                    .join(",");
              })
              .toList()
              .join(',');
        })
        .toList()
        .join(",")
        .split(",")
        .map((w) {
          var _sp = w.split("--").map<dynamic>((e) {
            try {
              return int.parse(e);
            } catch (err) {
              return e;
            }
          }).toList();
          var _total = _local?.where((t) => t!.contains(_sp.first));
          return DataMatchModel(
              answer: _sp[1],
              answerId: _sp[0],
              total: _total?.length,
              question: _sp[2]);
        })
        .toList();
    finalData?.sort((a, b) {
      return b.total!.compareTo(a.total!);
    });
    totalData = _local?.length;
    update();
  }
}

class DataMatchModel {
  int? answerId;
  String? answer;
  String? question;
  int? total;

  DataMatchModel({
    this.answerId,
    this.answer,
    this.total,
    this.question,
  });

  factory DataMatchModel.fromJson(Map<String, dynamic> json) => DataMatchModel(
      answerId: json['answerId'],
      answer: json['answer'] as String?,
      total: json['total']);

  Map<String, dynamic> toJson() => {
        'answerId': answerId,
        'answer': answer,
        'question': question,
        'total': total,
      };
}

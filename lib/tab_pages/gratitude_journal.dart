import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/pages/gratitude_journal_history.dart';
import 'package:kalm/utilities/date_format.dart';
import 'package:kalm/utilities/util.dart';
import 'package:kalm/widget/box_border.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/loading.dart';
import 'package:kalm/widget/loading_content.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class GratitudeJournalPage extends StatelessWidget {
  final _controller = Get.put(GratitudeJournalController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GratitudeJournalController>(initState: (st) async {
      await PRO.getGratitudeJournal(useLoading: false);
    }, builder: (_) {
      return SAFE_AREA(
          canBack: false,
          child: Builder(builder: (context) {
            if (STATE(context).gratitudeJournalResModel == null) {
              return LOADING;
            } else {
              return _gratitude(_, context);
            }
          }));
    });
  }

  ListView _gratitude(GratitudeJournalController _, BuildContext context) {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SPACE(),
              TEXT("GRATITUDE JOURNAL", style: Get.textTheme.headline2),
              SPACE(),
              TEXT(DATE_FORMAT(DateTime.now())),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    PRO.gratitudeJournalResModel?.gratitudeData?.length ?? 0,
                    (i) {
                  var _data = PRO.gratitudeJournalResModel!.gratitudeData![i];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SPACE(height: 15),
                      TEXT(_data.question),
                      SPACE(height: 15),
                      BOX_BORDER(
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: List.generate(
                                PRO.gratitudeEditingController[i].length, (j) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, right: 5),
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: ORANGEKALM,
                                      child: TEXT("${(j + 1)}",
                                          style: COSTUM_TEXT_STYLE(
                                              color: Colors.white)),
                                    ),
                                  ),
                                  Expanded(child: _textField(i, j, _)),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              SPACE(height: 20),
              SizedBox(
                  width: Get.width / 1.5,
                  child:
                      BUTTON("Gratitude Journal History", onPressed: () async {
                    if (PRO.gratitudeJournalHistoryResModel == null) {
                      await PRO.getGratitudeJournalHistory();
                      Loading.hide();
                      await pushNewScreen(context,
                          screen: GratitudeJournalHistoryPage());
                    } else {
                      await pushNewScreen(context,
                          screen: GratitudeJournalHistoryPage());
                    }
                  }, verticalPad: 15, circularRadius: 30))
            ],
          ),
        ),
      ],
    );
  }

  CupertinoTextField _textField(int i, int j, GratitudeJournalController _) {
    return CupertinoTextField(
      maxLines: null,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      textInputAction: TextInputAction.newline,
      textAlignVertical: TextAlignVertical.center,
      controller: PRO.gratitudeEditingController[i][j],
      onChanged: (v) =>
          TEXTFIELD_DEBOUNCER(v, () async => await _.submit(), second: 3),
    );
  }
}

class GratitudeJournalController extends GetxController {
  Future<void> submit() async {
    var _answer = PRO.gratitudeEditingController
        .map((e) => e.map((t) {
              return t.text.splitMapJoin(";");
            }).join(";"))
        .toList();
    var _payload = {
      "date": DateTime.now().toIso8601String(),
      "data": List.generate(_answer.length, (i) {
        return {"id": (i + 1), "answer": _answer[i]};
      })
    };
    var _res = await Api()
        .POST(GRATITUDE_JOURNAL, _payload, useToken: true, useLoading: false);
    if (_res?.statusCode == 200) {
      await PRO.getGratitudeJournal(useLoading: false);
      Loading.hide();
      SUCCESS_SNACK_BAR("Perhatian", _res?.data['message']);
    } else {
      Loading.hide();
      return;
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/gratitude_journal_history_res_model/gratitude_journal_history.dart';
import 'package:kalm/utilities/date_format.dart';
import 'package:kalm/utilities/date_picker.dart';
import 'package:kalm/widget/box_border.dart';
import 'package:kalm/widget/expansion_tile.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'package:collection/collection.dart' as collection;

class GratitudeJournalHistoryPage extends StatelessWidget {
  final _controller = Get.put(GratitudeJournalHistoryController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GratitudeJournalHistoryController>(builder: (_) {
      return SAFE_AREA(
          child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 40,
                    child: CupertinoTextField(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: BLUEKALM)),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 10, right: 5),
                        child: Icon(Icons.search_rounded),
                      ),
                      controller: _.searchController,
                      placeholder: "Search ...",
                      suffix: IconButton(
                          onPressed: () async {
                            var _datetime =
                                await DATE_PICKER(showUserAge: false);
                            _.searchByDate(_datetime);
                          },
                          icon: const Icon(Icons.date_range_outlined,
                              color: BLUEKALM)),
                      onChanged: (val) => _controller.searchOnChange(val),
                    )),
                SPACE(),
                if (_.queryData.entries.isEmpty)
                  SizedBox(
                    width: Get.width,
                    child: Column(
                      children: [
                        TEXT("Pencarian tidak ditemukan"),
                        const Icon(Icons.not_interested_outlined,
                            color: ORANGEKALM, size: 100),
                      ],
                    ),
                  ),
                Column(
                    children: _.queryData.entries.map((y) {
                  return CostumExpansionTile(
                    headerBackgroundColorStart: BLUEKALM,
                    header: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TEXT(y.key,
                          style: COSTUM_TEXT_STYLE(color: Colors.white)),
                    ),
                    children: y.value.entries.map((m) {
                      return CostumExpansionTile(
                        headerBackgroundColorStart: ORANGEKALM,
                        header: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TEXT(m.key,
                              style: COSTUM_TEXT_STYLE(color: Colors.white)),
                        ),
                        children: m.value.entries.map((d) {
                          return CostumExpansionTile(
                            initiallyExpanded: true,
                            headerBackgroundColorStart: GREENKALM,
                            expandedBackgroundColor: Colors.grey[200],
                            header: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TEXT(d.key,
                                  style:
                                      COSTUM_TEXT_STYLE(color: Colors.white)),
                            ),
                            children: d.value.map((data) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  children: [
                                    TEXT(data.gratitudeQuestion,
                                        style: Get.textTheme.bodyText2),
                                    SPACE(),
                                    BOX_BORDER(
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: List.generate(
                                              data.answer?.length ?? 0, (i) {
                                            return _textField(
                                                i, data.answer?[i]);
                                          }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  );
                }).toList())
              ],
            ),
          ),
          // BUTTON("title", onPressed: () => print(_.queryData))
        ],
      ));
    });
  }

  Padding _textField(int g, String? text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 5),
            child: CircleAvatar(
              radius: 10,
              backgroundColor: ORANGEKALM,
              child: TEXT("${(g + 1)}",
                  style: COSTUM_TEXT_STYLE(color: Colors.white)),
            ),
          ),
          Expanded(
            child: CupertinoTextField(
              readOnly: true,
              maxLines: null,
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: BLUEKALM),
                  color: _backgroundTextSearch(text)),
              style: COSTUM_TEXT_STYLE(
                  color: _backgroundTextSearch(text) == null
                      ? Colors.black
                      : _colorTextSearch(text)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              textInputAction: TextInputAction.newline,
              controller: TextEditingController(text: text),
            ),
          ),
        ],
      ),
    );
  }

  Color _colorTextSearch(String? text) {
    try {
      return text!.toLowerCase().contains(_controller.searchController.text) &&
              _controller.searchController.text.isNotEmpty
          ? Colors.white
          : Colors.black;
    } catch (e) {
      return Colors.black;
    }
  }

  Color? _backgroundTextSearch(String? text) {
    try {
      return text!.toLowerCase().contains(_controller.searchController.text) &&
              _controller.searchController.text.isNotEmpty
          ? BLUEKALM
          : Colors.white;
    } catch (e) {
      return null;
    }
  }
}

class GratitudeJournalHistoryController extends GetxController {
  TextEditingController searchController = TextEditingController();
  List<GratitudeJournalHistoryData>? get data =>
      PRO.gratitudeJournalHistoryResModel?.gratitudeJournalHistoryResModel;
  Map<String, Map<String, Map<String, List<GratitudeJournalHistoryData>>>>
      get queryData {
    searchData?.sort((a, b) {
      return DateTime.parse(a.createdAt!)
          .compareTo(DateTime.parse(b.createdAt!));
    });
    return collection
        .groupBy<GratitudeJournalHistoryData, String>(searchData ?? data!, (y) {
      return DateTime.parse(y.createdAt!).year.toString();
    }).map((y, month) {
      return MapEntry(
          y,
          collection.groupBy<GratitudeJournalHistoryData, String>(month, (e) {
            return DATE_FORMAT(DateTime.parse(e.createdAt!), pattern: "MMMM")!;
          }).map((d, day) {
            return MapEntry(
                d,
                collection.groupBy<GratitudeJournalHistoryData, String>(day,
                    (e) {
                  return DateTime.parse(e.createdAt!).day.toString();
                }));
          }));
    });
  }

  List<GratitudeJournalHistoryData>? searchData;
  void searchOnChange(val) {
    try {
      if (val.isNotEmpty) {
        searchData = data?.where((e) {
          print(e.date);
          return e.answer!.join(";").toLowerCase().contains(val);
        }).toList();
      } else {
        searchData = data;
      }
      update();
    } catch (e) {
      searchData = data;
      update();
    }
  }

  void searchByDate(DateTime? dateTime) {
    try {
      if (dateTime != null) {
        searchData = data?.where((e) {
          return DateTime.parse(e.date!).isAtSameMomentAs(dateTime);
        }).toList();
      } else {
        searchData = data;
      }
      update();
    } catch (e) {
      searchData = data;
      update();
    }
  }
}

class GratitudeQuery {
  String? year;
  String? month;
  List<String?>? answer;

  GratitudeQuery({
    this.year,
    this.month,
    this.answer,
  });
  Map<String, dynamic> toJson() => {
        'year': year,
        'month': month,
        'answer': answer?.map((e) => e).toList(),
      };
}

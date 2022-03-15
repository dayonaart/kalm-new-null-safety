import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/ors_history_res_model/ors_data.dart';
import 'package:kalm/model/ors_res_model/ors_res_model.dart';
import 'package:kalm/utilities/date_format.dart';
import 'package:kalm/utilities/date_picker.dart';
import 'package:kalm/widget/box_border.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:collection/collection.dart' as collection;

class OrsHistoryPage extends StatelessWidget {
  final _controller = Get.put(OrsHistoryController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrsHistoryController>(builder: (_) {
      // print(_.orsDatas?.map((e) => e.value));
      // print(PRO.orsResModel?.length);
      return SAFE_AREA(
          child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Column(
            children: [
              _chart(_),
              _legend(_),
            ],
          )
        ],
      ));
    });
  }

  SfCartesianChart _chart(OrsHistoryController _) {
    return SfCartesianChart(
        plotAreaBackgroundImage: const AssetImage('assets/wave/wave.png'),
        primaryXAxis: CategoryAxis(
            borderColor: BLUEKALM,
            borderWidth: 1,
            title: AxisTitle(
                text: "ORS HISTORY", textStyle: Get.textTheme.headline1)),
        series: <LineSeries<OrsHistoryData, String>>[
          for (var i = 0; i < _.activeOrsController.length; i++)
            if (!_.activeOrsController[i])
              LineSeries(
                  dataSource: [],
                  xValueMapper: (OrsHistoryData d, j) {
                    return DATE_FORMAT(DateTime.parse(d.date!));
                  },
                  yValueMapper: (OrsHistoryData d, j) {
                    return d.value![i];
                  })
            else
              LineSeries<OrsHistoryData, String>(
                  width: _.lineWidth,
                  color: _.legendColors(i),
                  dataSource: _.orsDatas!,
                  xValueMapper: (OrsHistoryData d, j) {
                    try {
                      return DATE_FORMAT(DateTime.parse(d.date!));
                    } catch (e) {
                      return null;
                    }
                  },
                  yValueMapper: (OrsHistoryData d, j) {
                    try {
                      return d.value![i];
                    } catch (e) {
                      return null;
                    }
                  },
                  dataLabelSettings: DataLabelSettings(
                      isVisible: _.dataLabelVisible, color: _.legendColors(i)))
        ]);
  }

  Padding _legend(OrsHistoryController _) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(_.orsResModel?.length ?? 0, (i) {
              return Column(
                children: [
                  InkWell(
                    onTap: () => _.changeActiveOrs(i),
                    child: Row(
                      children: [
                        BOX_BORDER(
                            Card(
                                color: !_.activeOrsController[i]
                                    ? Colors.grey
                                    : _.legendColors(i)),
                            width: 20,
                            height: 20),
                        SPACE(),
                        TEXT(_.orsResModel?[i].title),
                      ],
                    ),
                  ),
                  SPACE()
                ],
              );
            }),
          ),
          SizedBox(
            height: Get.height / 4.5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_searchByDate(_), SPACE(width: 5), _options(_)],
            ),
          ),
        ],
      ),
    );
  }

  Expanded _options(OrsHistoryController _) {
    return Expanded(
        child: BOX_BORDER(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(_.orsResModel?.length ?? 0, (i) {
              return TEXT(_.orsResModel![i].title,
                  style: COSTUM_TEXT_STYLE(fonstSize: 12));
            }),
          ),
          SPACE(),
          InkWell(
            onTap: () => _.changeLabelVisible(),
            child: Row(
              children: [
                BOX_BORDER(
                    Card(color: _.dataLabelVisible ? ORANGEKALM : Colors.grey),
                    width: 20,
                    height: 20),
                SPACE(),
                TEXT("Show label", style: COSTUM_TEXT_STYLE(fonstSize: 12))
              ],
            ),
          ),
          SPACE(),
          InkWell(
            onTap: () => _.changeLineSize(true),
            child: Row(
              children: [
                BOX_BORDER(const Icon(Icons.add, size: 20, color: Colors.white),
                    width: 20, height: 20, fillColor: ORANGEKALM),
                SPACE(),
                TEXT("Increase Lines Size",
                    style: COSTUM_TEXT_STYLE(fonstSize: 12))
              ],
            ),
          ),
          SPACE(),
          InkWell(
            onTap: () => _.changeLineSize(false),
            child: Row(
              children: [
                BOX_BORDER(
                    const Icon(Icons.remove, size: 20, color: Colors.white),
                    width: 20,
                    height: 20,
                    fillColor: BLUEKALM),
                SPACE(),
                TEXT("Decrease Lines Size",
                    style: COSTUM_TEXT_STYLE(fonstSize: 12))
              ],
            ),
          ),
        ],
      ),
    )));
  }

  Expanded _searchByDate(OrsHistoryController _) {
    return Expanded(
      child: BOX_BORDER(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TEXT("Search by Date"),
            SPACE(height: 5),
            CupertinoTextField(
                readOnly: true,
                onTap: () async => await _.startDatePick(),
                placeholder: "Start date",
                controller: _.startDateController),
            SPACE(),
            CupertinoTextField(
                readOnly: true,
                onTap: () async => await _.endDatePick(),
                placeholder: "End date",
                controller: _.endDateController),
            SPACE(),
            BUTTON("Search", onPressed: () => _.search())
          ],
        ),
      )),
    );
  }
}

class OrsHistoryController extends GetxController {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  double lineWidth = 1;
  void changeLineSize(bool increase) {
    if (increase) {
      lineWidth += 1;
    } else {
      lineWidth -= 1;
    }
    if (lineWidth < 1) {
      lineWidth = 1;
    } else if (lineWidth >= 10) {
      lineWidth = 10;
    }
    update();
  }

  bool dataLabelVisible = true;
  void changeLabelVisible() {
    dataLabelVisible = !dataLabelVisible;
    update();
  }

  Future<void> startDatePick() async {
    try {
      startDate = await DATE_PICKER(showUserAge: false);
      assert(startDate != null);
      startDateController.text = DATE_FORMAT(startDate!)!;
    } catch (e) {
      return;
    }
  }

  Future<void> endDatePick() async {
    try {
      endDate = await DATE_PICKER(showUserAge: false);
      assert(endDate != null);
      endDateController.text = DATE_FORMAT(endDate!)!;
    } catch (e) {
      return;
    }
  }

  DateTime? startDate;

  DateTime? endDate;

  void search() {
    startDateController.clear();
    endDateController.clear();
    update();
  }

  List<String>? getBetweenDays({
    @required DateTime? startDate,
    @required DateTime? endDate,
  }) {
    try {
      List<String> _date = [];
      for (int i = 0; i <= endDate!.difference(startDate!).inDays; i++) {
        _date.add(DATE_FORMAT(startDate.add(Duration(days: i)))!);
      }
      return _date;
    } catch (e) {
      return null;
    }
  }

  List<OrsResModel>? orsResModel = PRO.orsResModel;
  List<bool> activeOrsController =
      List.generate(PRO.orsResModel?.length ?? 0, (i) => true);
  List<OrsHistoryData>? get orsDatas {
    try {
      return PRO.orsHistoryData?.map((e) {
        if (getBetweenDays(startDate: startDate, endDate: endDate)!
            .contains(DATE_FORMAT(DateTime.parse(e.createdAt!)))) {
          return e;
        } else {
          return OrsHistoryData();
        }
      }).toList();
    } catch (e) {
      return PRO.orsHistoryData;
    }
  }

  void changeActiveOrs(int i) {
    activeOrsController[i] = !activeOrsController[i];
    update();
  }

  Color? legendColors(int i) {
    switch (i) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.pink;
      default:
        return Colors.black;
    }
  }
}

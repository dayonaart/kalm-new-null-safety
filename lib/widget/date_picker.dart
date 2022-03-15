import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/utilities/date_format.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class DatePicker extends StatefulWidget {
  DatePicker({
    Key? key,
    required this.controller,
    this.height = 300.0,
    required this.onChanged,
    this.pickerDecoration = const BoxDecoration(color: Colors.black12),
    this.locale = DatePickerLocale.ko_kr,
    this.config,
    this.title,
    this.showUserAge = true,
    this.onSubmit,
  }) : super(key: key);

  /// This widget's year selection and animation state.
  final DatePickerController controller;

  /// If non-null, requires the child to have exactly this height.
  final double height;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<DateTime> onChanged;

  /// An immutable description of how to paint a box.
  final BoxDecoration pickerDecoration;

  /// Set calendar language
  final DatePickerLocale locale;

  /// Date Picker configuration
  final DatePickerConfig? config;
  final String? title;
  final bool showUserAge;
  final void Function(DateTime)? onSubmit;
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DatePickerConfig _config;
  List _month = [];
  List<int> _day = [];
  List<int> _year = [];

  int _selectedYear = 0;
  var _selectedMonth;
  int _selectedDay = 0;

  late int _monthIndex;
  late int _dayIndex;
  late int _yearIndex;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? DatePickerConfig();

    _year = [
      for (int i = widget.controller.minYear;
          i <= widget.controller.maxYear;
          i++)
        i
    ];
    _month = widget.locale.month;
    _selectedDate = widget.controller.initialDateTime;
    _selectedYear = widget.controller.initialDateTime.year;
    _selectedMonth = widget.controller.initialDateTime.month;
    _selectedDay = widget.controller.initialDateTime.day;

    _day = [
      for (int i = 1;
          i <= getMonthlyDate(month: _selectedMonth, year: _selectedYear);
          i++)
        i
    ];

    _yearIndex =
        widget.controller.initialDateTime.year - widget.controller.minYear;
    _selectedYear = _year[_yearIndex];

    _monthIndex = widget.controller.monthController.initialItem;
    _selectedMonth = _month[_monthIndex];

    _dayIndex = widget.controller.dayController.initialItem;
    _selectedDay = _day[_dayIndex];
  }

  void _scrollToSelectedDay() {
    int selectedDayIndex = _day.indexOf(_selectedDay);
    if (selectedDayIndex != -1) {
      widget.controller.dayController.jumpTo(0.1);
      widget.controller.dayController
          .jumpTo(selectedDayIndex * _config.itemExtent);
    } else {
      widget.controller.dayController.jumpTo(0.1);
      widget.controller.dayController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TEXT(widget.title, style: Get.textTheme.headline1),
                        SPACE(),
                        if (_selectedDate != null && widget.showUserAge)
                          TEXT(_userAge())
                      ],
                    ),
                  ),
                  if (_selectedDate != null)
                    SizedBox(
                        height: 50,
                        width: 50,
                        child: OUTLINE_BUTTON("Pilih", onPressed: () {
                          widget.onSubmit!(_selectedDate!);
                          Get.back();
                        }))
                ],
              ),
            ),
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollUpdateNotification) {
                DateTime date = DateTime.parse(
                    "$_selectedYear-${dateFormatter(_monthIndex + 1)}-${dateFormatter(_selectedDay)}");
                if (date != _selectedDate) {
                  setState(() {
                    _selectedDate = date;
                  });
                  widget.onChanged(DateTime.parse(
                      "$_selectedYear-${dateFormatter(_monthIndex + 1)}-${dateFormatter(_selectedDay)}"));
                }
              }
              return false;
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: BLUEKALM)),
              height: widget.height / 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: _config.itemExtent,
                        decoration: widget.pickerDecoration,
                      ),
                    ),
                    widget.locale == DatePickerLocale.ko_kr
                        ? _koKRDatePicker()
                        : _enUSDatePicker()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _userAge() {
    try {
      if (VALIDATE_DOB_MATURE(_selectedDate)!.toString().contains('999')) {
        return "Usia Anda ${(VALIDATE_DOB_MATURE(_selectedDate)!.toInt() + 1)} Tahun";
      } else {
        return "Usia Anda ${VALIDATE_DOB_MATURE(_selectedDate)?.toInt()} Tahun";
      }
    } catch (e) {
      return null;
    }
  }

  Widget _enUSDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DateScrollView(
            width: 120.0,
            controller: widget.controller.monthController,
            itemIndex: _monthIndex,
            item: _month,
            config: _config,
            onChanged: (value) {
              setState(() {
                _monthIndex = value;
                _selectedMonth = _month[value];
                _day = [
                  for (int i = 1;
                      i <=
                          getMonthlyDate(
                              month: _monthIndex + 1, year: _selectedYear);
                      i++)
                    i
                ];
              });
              _scrollToSelectedDay();
            }),
        const SizedBox(
          width: 16.0,
        ),
        DateScrollView(
            controller: widget.controller.dayController,
            itemIndex: _dayIndex,
            item: _day,
            config: _config,
            onChanged: (value) {
              setState(() {
                _dayIndex = value;
                _selectedDay = _day[value];
              });
            }),
        const SizedBox(
          width: 16.0,
        ),
        DateScrollView(
            width: 70.0,
            controller: widget.controller,
            itemIndex: _yearIndex,
            item: _year,
            config: _config,
            onChanged: (value) {
              setState(() {
                _yearIndex = value;
                _selectedYear = _year[value];
                _day = [
                  for (int i = 1;
                      i <=
                          getMonthlyDate(
                              month: _monthIndex + 1, year: _selectedYear);
                      i++)
                    i
                ];
              });
              _scrollToSelectedDay();
            }),
      ],
    );
  }

  Widget _koKRDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DateScrollView(
          width: 70.0,
          controller: widget.controller,
          itemIndex: _yearIndex,
          item: _year,
          config: _config,
          label: "년",
          onChanged: (value) {
            setState(() {
              _yearIndex = value;
              _selectedYear = _year[value];
              _day = [
                for (int i = 1;
                    i <=
                        getMonthlyDate(
                            month: _monthIndex + 1, year: _selectedYear);
                    i++)
                  i
              ];
            });
            _scrollToSelectedDay();
          },
        ),
        const SizedBox(
          width: 16.0,
        ),
        DateScrollView(
            width: 45.0,
            controller: widget.controller.monthController,
            itemIndex: _monthIndex,
            item: _month,
            config: _config,
            label: "월",
            onChanged: (value) {
              setState(() {
                _monthIndex = value;
                _selectedMonth = _month[value];
                _day = [
                  for (int i = 1;
                      i <=
                          getMonthlyDate(
                              month: _monthIndex + 1, year: _selectedYear);
                      i++)
                    i
                ];
              });
              _scrollToSelectedDay();
            }),
        const SizedBox(
          width: 16.0,
        ),
        DateScrollView(
          width: 45.0,
          controller: widget.controller.dayController,
          itemIndex: _dayIndex,
          item: _day,
          config: _config,
          label: "일",
          onChanged: (value) {
            setState(() {
              _dayIndex = value;
              _selectedDay = _day[value];
            });
          },
        ),
      ],
    );
  }
}

enum DatePickerLocale {
  id_ID,
  en_us,
  ko_kr,
  fr_fr,
}

extension DatePickerLocaleExtension on DatePickerLocale {
  dynamic get month {
    switch (this) {
      case DatePickerLocale.id_ID:
        return [
          'Januari',
          'Februari',
          'Maret',
          'April',
          'Mei',
          'Juni',
          'Juli',
          'Agustus',
          'September',
          'October',
          'November',
          'Desember'
        ];
      case DatePickerLocale.en_us:
        return [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December'
        ];
      case DatePickerLocale.ko_kr:
        return [for (int i = 1; i <= 12; i++) i];
      case DatePickerLocale.fr_fr:
        return [
          'Janvier',
          'Février',
          'Mars',
          'Avril',
          'Mai',
          'Juin',
          'Juillet',
          'Août',
          'Septembre',
          'Octobre',
          'Novembre',
          'Décembre'
        ];
      default:
        return "";
    }
  }
}

class DatePickerConfig {
  DatePickerConfig({
    this.itemExtent = 45.0,
    this.diameterRatio = 3.0,
    this.perspective = 0.01,
    this.textStyle = const TextStyle(fontSize: 18.0, color: Colors.grey),
    this.selectedTextStyle = const TextStyle(
        fontSize: 20.0,
        color: BLUEKALM,
        fontWeight: FontWeight.bold,
        fontFamily: "fonts/AlexBrush-Regular.ttf"),
    this.isLoop = true,
  }) : assert(itemExtent > 0);

  /// Size of each child in the main axis
  final double itemExtent;

  /// {@macro flutter.rendering.wheelList.diameterRatio}
  final double diameterRatio;

  /// {@macro flutter.rendering.wheelList.perspective}
  final double perspective;

  /// An opaque object that determines the size, position, and rendering of selected text.
  final TextStyle selectedTextStyle;

  /// An opaque object that determines the size, position, and rendering of text.
  final TextStyle textStyle;

  /// The loop iterates on an explicit list of values
  final bool isLoop;
}

String dateFormatter(int value) {
  return value.toString().length > 1 ? value.toString() : "0$value";
}

class DatePickerController extends FixedExtentScrollController {
  DatePickerController({
    required this.initialDateTime,
    this.minYear = 2010,
    this.maxYear = 2050,
  })  : monthController =
            FixedExtentScrollController(initialItem: initialDateTime.month - 1),
        dayController =
            FixedExtentScrollController(initialItem: initialDateTime.day - 1),
        assert(initialDateTime.year >= minYear),
        super(
          initialItem: initialDateTime.year - minYear,
        );

  /// Minimum year that the picker can be scrolled
  final int minYear;

  /// Maximum year that the picker can be scrolled
  final int maxYear;

  /// This widget's month selection and animation state.
  final FixedExtentScrollController monthController;

  /// This widget's day selection and animation state.
  final FixedExtentScrollController dayController;

  /// The initial date and/or time of the picker.
  final DateTime initialDateTime;

  @override
  void dispose() {
    monthController.dispose();
    dayController.dispose();

    super.dispose();
  }
}

int getMonthlyDate({required int month, required int year}) {
  int day = 0;

  switch (month) {
    case 1:
      day = 31;
      break;
    case 2:
      day = (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 ? 29 : 28;
      break;
    case 3:
      day = 31;
      break;
    case 4:
      day = 30;
      break;
    case 5:
      day = 31;
      break;
    case 6:
      day = 30;
      break;
    case 7:
      day = 31;
      break;
    case 8:
      day = 31;
      break;
    case 9:
      day = 30;
      break;
    case 10:
      day = 31;
      break;
    case 11:
      day = 30;
      break;
    case 12:
      day = 31;
      break;

    default:
      day = 30;
      break;
  }

  return day;
}

// ignore: must_be_immutable
class DateScrollView extends StatelessWidget {
  DateScrollView({
    Key? key,
    this.width = 45.0,
    required this.onChanged,
    this.itemIndex = 0,
    required this.item,
    required this.controller,
    this.label = "",
    required this.config,
  }) : super(key: key);

  /// If non-null, requires the child to have exactly this Width.
  final double width;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<int> onChanged;

  /// The index of the currently selected date.
  final int itemIndex;

  /// This is a list of dates.
  final List item;

  /// A controller for scroll views whose items have the same size.
  final FixedExtentScrollController controller;

  final String label;

  /// Date Picker configuration
  final DatePickerConfig config;

  List<Widget> _date = [];

  @override
  Widget build(BuildContext context) {
    _date = List<Widget>.generate(
      item.length,
      (index) => Container(
        alignment: Alignment.center,
        child: TEXT("${item[index]}$label",
            style: itemIndex == index
                ? COSTUM_TEXT_STYLE(
                    fontWeight: FontWeight.bold, color: BLUEKALM)
                : config.textStyle),
      ),
    );

    return SizedBox(
      width: width,
      child: ListWheelScrollView.useDelegate(
        itemExtent: config.itemExtent,
        diameterRatio: config.diameterRatio,
        controller: controller,
        physics: const FixedExtentScrollPhysics(),
        perspective: config.perspective,
        onSelectedItemChanged: onChanged,
        childDelegate: config.isLoop
            ? ListWheelChildLoopingListDelegate(
                children: _date,
              )
            : ListWheelChildListDelegate(
                children: _date,
              ),
      ),
    );
  }
}

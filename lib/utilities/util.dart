import 'dart:async';

import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/country_res_model/country_data.dart';
import 'package:kalm/model/state_res_model/address_item_data.dart';
import 'package:kalm/model/user_quetioner_res_model/answer.dart';
import 'package:kalm/model/user_quetioner_res_model/questioner_data.dart';

Timer? _debouncer;
void TEXTFIELD_DEBOUNCER(String v, void Function() callback, {int? second}) {
  if (_debouncer?.isActive ?? false) _debouncer?.cancel();
  _debouncer = Timer(Duration(seconds: second ?? 3), callback);
}

List<CountryData>? ADDRESS_ROOT() {
  try {
    return PRO.countryResModel?.data;
  } catch (e) {
    return null;
  }
}

List<String> GENDER_LIST = ['Perempuan', 'Laki-Laki'];

String GENDER(int i) {
  try {
    if (i == 0) {
      return 'Perempuan';
    } else {
      return 'Laki-Laki';
    }
  } catch (e) {
    return "Pilih Jenis Kelamin";
  }
}

String RELIGION(int i) {
  try {
    switch (i) {
      case 1:
        return "Islam";
      case 2:
        return "Protestan";
      case 3:
        return "Katolik";
      case 4:
        return "Hindu";
      case 5:
        return "Budha";
      default:
        return "Pilih Agama";
    }
  } catch (e) {
    return "Pilih Agama";
  }
}

List<String> RELIGION_LIST = [
  'Islam',
  'Protestan',
  "Katolik",
  "Hindu",
  'Budha'
];

List<QuestionerData>? get _questionerData =>
    PRO.userQuestionerResModel?.questionerData;

String? DOB_ALERT_MESSAGE() {
  var _desc = _questionerData?.firstWhere((e) => e.id == 2).description;
  try {
    return "${_desc?.replaceRange(0, _desc.indexOf("Anda"), '')}";
  } catch (err) {
    return _desc;
  }
}

String? STATE_NAME(int id) {
  try {
    return PRO.stateResItem?.data?.firstWhere((e) => e.id == id).name;
  } catch (e) {
    return "";
  }
}

List<AddressItemData>? STATES_DATA() {
  try {
    return PRO.stateResItem?.data?.toList();
  } catch (e) {
    return null;
  }
}

String? CITY_NAME(int id) {
  try {
    return PRO.cityResItem?.data?.firstWhere((e) => e.id == id).name;
  } catch (e) {
    return "";
  }
}

List<AddressItemData>? CITIES_DATA() {
  try {
    return PRO.cityResItem?.data?.toList();
  } catch (e) {
    return null;
  }
}

List<Answer>? MARITAL_LIST() {
  try {
    return _questionerData?.map((e) => e).toList()[10].answer;
  } catch (e) {
    return null;
  }
}

String? MARITAL(int i) {
  try {
    return _questionerData
        ?.map((e) => e)
        .toList()[10]
        .answer
        ?.map((e) => e.answer)
        .toList()[(i - 1)];
  } catch (e) {
    return "";
  }
}

String? AMOUNT_OF_CHILD(int i) {
  try {
    return _questionerData
        ?.map((e) => e)
        .toList()[11]
        .answer
        ?.map((e) => e.answer)
        .toList()[(i - 1)];
  } catch (e) {
    return "";
  }
}

List<Answer>? AMOUNT_OF_CHILD_LIST() {
  try {
    return _questionerData?.map((e) => e).toList()[11].answer;
  } catch (e) {
    return null;
  }
}

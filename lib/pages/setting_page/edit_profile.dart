import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/user_model/user_data.dart';
import 'package:kalm/model/user_model/user_model.dart';
import 'package:kalm/model/user_quetioner_res_model/answer.dart';
import 'package:kalm/utilities/date_format.dart';
import 'package:kalm/utilities/date_picker.dart';
import 'package:kalm/utilities/util.dart';
import 'package:kalm/widget/box_border.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/image_cache.dart';
import 'package:kalm/widget/loading.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'dart:math' as math;

import 'package:kalm/widget/textfield.dart';

class EditProfilePage extends StatelessWidget {
  final _controller = Get.put(EditProfileController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(initState: (st) async {
      _controller.updateTextFieldController();
      if (PRO.userQuestionerResModel == null) {
        await PRO.getUserQuestioner();
        await PRO.getCountry();
        await PRO.getStates(PRO.userData?.countryId ?? 1);
        await PRO.getCity(PRO.userData?.stateId ?? 1);
        _controller.updateTextFieldController(useUpdate: true);
        Loading.hide();
      }
    }, builder: (_) {
      // print(PRO.userData?.maritalStatus);
      // print(PRO.userData?.stateId);
      return SAFE_AREA(
          child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SPACE(),
                _profileImage(_, context),
                SPACE(),
                Builder(builder: (context) {
                  return BOX_BORDER(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      child: Column(
                        children: List.generate(_.placeholder.length, (i) {
                          if (i == 4) {
                            ///GENDER
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: _gridQuestion(_, i),
                            );
                          } else if (i == 5) {
                            ///RELIGION
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: _gridQuestion(_, i),
                            );
                          } else if (i == 9) {
                            ///ADDRESS
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: _addresField(_, i),
                            );
                          } else if (i == 10) {
                            ///MARITAL
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: _gridQuestion(_, i),
                            );
                          } else if (i == 11) {
                            ///AMOUNT_CHILD
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: _gridQuestion(_, i),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: _fields(_, i),
                            );
                          }
                        }),
                      ),
                    ),
                  );
                }),
                SPACE(),
                SizedBox(
                    width: Get.width / 1.3,
                    child: BUTTON("Update",
                        onPressed: () async => await _.submit(context),
                        verticalPad: 12,
                        circularRadius: 20))
                // BUTTON("DEBUG",
                //     onPressed: () =>
                //         PRO.changeStatusTestDebug(int.parse(_.textController.last.text)))
              ],
            ),
          )
        ],
      ));
    });
  }

  Column _gridQuestion(EditProfileController _, int i) {
    return Column(
      children: [
        _fields(_, i),
        SPACE(height: 5),
        BOX_BORDER(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: 30),
                children: _gridSelection(i)),
          ),
        )
      ],
    );
  }

  List<Widget> _gridSelection(int i) {
    switch (i) {
      case 4:
        return _genderGridQuestion(i);
      case 5:
        return _religionGridQuestion(i);
      case 10:
        return _maritalGridQuestion(i);
      case 11:
        return _amountChildGridQuestion(i);
      default:
        return [];
    }
  }

  List<Widget> _genderGridQuestion(int i) {
    return List.generate(GENDER_LIST.length, (j) {
      var _data = GENDER_LIST[j];
      return InkWell(
        onTap: () => _controller.updateGender(j, i),
        child: Row(
          children: [
            SizedBox(
                height: 20,
                width: 20,
                child: BOX_BORDER(Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _controller.textController[i].text == _data
                            ? ORANGEKALM
                            : Colors.white),
                  ),
                ))),
            SPACE(),
            TEXT(_data),
          ],
        ),
      );
    });
  }

  List<Widget> _religionGridQuestion(int i) {
    return List.generate(RELIGION_LIST.length, (j) {
      var _data = RELIGION_LIST[j];
      return InkWell(
        onTap: () => _controller.updateReligion(j, i),
        child: Row(
          children: [
            SizedBox(
                height: 20,
                width: 20,
                child: BOX_BORDER(Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _controller.textController[i].text == _data
                            ? ORANGEKALM
                            : Colors.white),
                  ),
                ))),
            SPACE(),
            TEXT(_data),
          ],
        ),
      );
    });
  }

  List<Widget> _maritalGridQuestion(int i) {
    return List.generate(MARITAL_LIST()?.length ?? 0, (j) {
      var _data = MARITAL_LIST()![j];
      return InkWell(
        onTap: () => _controller.updateMarital(_data, i),
        child: Row(
          children: [
            SizedBox(
                height: 20,
                width: 20,
                child: BOX_BORDER(Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _controller.textController[i].text == _data.answer
                            ? ORANGEKALM
                            : Colors.white),
                  ),
                ))),
            SPACE(),
            TEXT(_data.answer),
          ],
        ),
      );
    });
  }

  List<Widget> _amountChildGridQuestion(int i) {
    return List.generate(AMOUNT_OF_CHILD_LIST()?.length ?? 0, (j) {
      var _data = AMOUNT_OF_CHILD_LIST()![j];
      return InkWell(
        onTap: () => _controller.updateAmountChild(_data, i),
        child: Row(
          children: [
            SizedBox(
                height: 20,
                width: 20,
                child: BOX_BORDER(Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _controller.textController[i].text == _data.answer
                            ? ORANGEKALM
                            : Colors.white),
                  ),
                ))),
            SPACE(),
            TEXT(_data.answer),
          ],
        ),
      );
    });
  }

  Column _fields(EditProfileController _, int i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TEXT(_.placeholder[i]),
        SPACE(height: 5),
        CupertinoTextField(
          // minLines: i == 12 ? 3 : 1,
          // maxLines: i == 12 ? 5 : 2,
          onTap: i == 7 ? () async => await _.updateDob(i) : null,
          readOnly: _.readOnly[i],
          placeholder: _.placeholder[i],
          controller: _.textController[i],
          onChanged: _.onChange()[i],
          inputFormatters: _.inputFormatter()[i] == null ? null : [_.inputFormatter()[i]!],
          focusNode: _.focusNodes[i],
          onSubmitted: _.onSubmitted()[i],
          keyboardType: _.textInputType[i],
          textInputAction: i == 12 ? TextInputAction.newline : TextInputAction.next,
        ),
        if (i == 7)
          Builder(builder: (context) {
            try {
              if (_.dob13 != null) {
                return Column(
                  children: [
                    SPACE(),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 0.5, color: BLUEKALM)),
                      child: Row(
                        children: [
                          Checkbox(value: _.dob13, onChanged: (val) => _.updateDob13(val!)),
                          Expanded(
                              child: TEXT(
                                  "Saya berusia 13 tahun keatas dan ingin menggunakan aplikasi ini"))
                        ],
                      ),
                    ),
                  ],
                );
              } else if (VALIDATE_DOB_MATURE(_.selectedDob)! <= 12.999) {
                return Column(
                  children: [
                    SPACE(),
                    ERROR_VALIDATION_FIELD(DOB_ALERT_MESSAGE(), useOverFlow: false),
                  ],
                );
              } else {
                return Container();
              }
            } catch (e) {
              return Container();
            }
          }),
      ],
    );
  }

  Container _addresField(EditProfileController _, int i) {
    return BOX_BORDER(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TEXT(_.placeholder[i]),
            SPACE(height: 5),
            if (_.addressController[0].text != "Lainnya")
              Column(
                children: List.generate(_.addressController.length, (j) {
                  return CupertinoTextField(
                    controller: _.addressController[j],
                    placeholder: _.addressPlaceholderBottomSheet(j),
                    onTap: () async => await _.bottomSheetAddress(j),
                    readOnly: true,
                    suffix: const Icon(Icons.arrow_drop_down_circle_outlined,
                        color: ORANGEKALM, size: 20),
                  );
                }),
              )
            else
              Column(
                children: List.generate(1, (j) {
                  return CupertinoTextField(
                    controller: _.addressController[j],
                    placeholder: _.addressPlaceholderBottomSheet(j),
                    onTap: () async => await _.bottomSheetAddress(j),
                    readOnly: true,
                    suffix: const Icon(Icons.arrow_drop_down_circle_outlined,
                        color: ORANGEKALM, size: 20),
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }

  Stack _profileImage(EditProfileController _, BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        CircleAvatar(
            backgroundColor: _.isPickingProgress ? Colors.white : BLUEKALM,
            radius: 80,
            child: Builder(builder: (context) {
              if (_.isPickingProgress) {
                return const SizedBox(
                  child: CupertinoActivityIndicator(radius: 15),
                );
              } else {
                return IMAGE_CACHE(
                  "$IMAGE_URL/users/${_.user(context)?.photo}",
                  width: 150,
                  height: 150,
                  circularRadius: 80,
                );
              }
            })),
        Positioned(
          width: 50,
          child: InkWell(
            onTap: _.isPickingProgress ? null : () async => await _.pickImage(),
            child: Container(
                decoration: const BoxDecoration(shape: BoxShape.circle, color: BLUEKALM),
                child: const Icon(Icons.camera, color: ORANGEKALM, size: 40)),
          ),
        )
      ],
    );
  }
}

class EditProfileController extends GetxController {
  UserData? user(BuildContext context) {
    return STATE(context).userData;
  }

  late List<TextEditingController> textController;
  late List<TextEditingController> addressController;
  DateTime? selectedDob;
  Map<String, dynamic> payload = {};

  List<String> placeholder = [
    'Nama Depan',
    "Nama Belakang",
    "Nomor Identitas",
    "Nomor NPWP",
    "Jenis Kelamin",
    "Agama",
    "Email",
    "Tanggal Lahir",
    "Nomor HP",
    "Alamat Lengkap",
    "Status Perkawinan",
    "Jumlah Anak",
    "Tentang Saya"
  ];
  List<String> payloadKey = [
    "first_name",
    "last_name",
    "id_number",
    "npwp_number",
    "gender",
    "religion",
    "email",
    "dob",
    "phone",
    "address",
    "marital_status",
    "amount_of_children",
    "about_me",
    "country_id",
    "state_id",
    "city_id",
  ];
  List<Function(String val)> onChange() {
    return List.generate(placeholder.length, (i) {
      return (v) {
        payload.update(payloadKey[i], (val) => v, ifAbsent: () {
          payload.putIfAbsent(payloadKey[i], () => v);
        });
      };
    });
  }

  List<Function(String val)> onSubmitted() {
    return List.generate(placeholder.length, (i) {
      return (v) {
        if (i == 12) {
          return;
        }
        try {
          focusNodes[i].unfocus();
          FocusScope.of(Get.context!).requestFocus(focusNodes[i + 1]);
        } catch (e) {
          focusNodes[i].unfocus();
        }
      };
    });
  }

  List<TextInputFormatter?> inputFormatter() {
    return List.generate(placeholder.length, (i) {
      switch (i) {
        case 2:
          return FilteringTextInputFormatter.digitsOnly;
        case 3:
          return FilteringTextInputFormatter.digitsOnly;
        case 8:
          return FilteringTextInputFormatter.digitsOnly;
        default:
          return null;
      }
    });
  }

  late List<FocusNode> focusNodes;
  bool isPickingProgress = false;
  Uint8List? _imageByte;
  String? _base64Image() {
    try {
      return ("data:image/jpeg;base64," + base64Encode(_imageByte!));
    } catch (e) {
      return null;
    }
  }

  Future<void> pickImage() async {
    try {
      var _picker = ImagePicker();
      var _pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      isPickingProgress = true;
      update();
      _imageByte = await _pickedFile?.readAsBytes();
      var _imageSize = (_imageByte!.lengthInBytes / 1024) / 1024;
      if (_imageSize > 2) {
        ERROR_SNACK_BAR("Perhatian", "File Maksimal 2Mb");
        isPickingProgress = false;
        update();
        return;
      } else if (_imageByte == null) {
        ERROR_SNACK_BAR("Perhatian", "Terjadi Kesalahan");
        isPickingProgress = false;
        update();
        return;
      }
      await uploadPhoto();
    } catch (e) {
      ERROR_SNACK_BAR("Perhatian", 'Cancel');
      isPickingProgress = false;
      update();
      return;
    }
  }

  Future<void> uploadPhoto() async {
    var _res = await Api().POST(UPDATE_PROFILE_IMAGE, {"photo_base64": _base64Image()},
        useToken: true, useLoading: false);
    // PR(_res?.data);
    if (_res?.statusCode == 200) {
      await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
      Loading.hide();
      isPickingProgress = false;
    } else {
      isPickingProgress = false;
      return;
    }
    update();
  }

  void updateTextFieldController({bool useUpdate = false}) {
    textController = List.generate(placeholder.length, (i) {
      try {
        switch (i) {
          //FIRST NAME
          case 0:
            return TextEditingController(text: PRO.userData?.firstName);
          //LAST NAME
          case 1:
            return TextEditingController(text: PRO.userData?.lastName);
          //NPWP
          case 2:
            return TextEditingController(text: PRO.userData?.idNumber);
          case 3:
            return TextEditingController(text: PRO.userData?.npwpNumber);
          //GENDER
          case 4:
            return TextEditingController(text: GENDER(PRO.userData!.gender!));
          //RELIGION
          case 5:
            return TextEditingController(text: RELIGION(PRO.userData!.religion!));
          //EMAIL
          case 6:
            return TextEditingController(text: PRO.userData?.email);
          //DOB
          case 7:
            selectedDob = PRO.userData?.dob;
            return TextEditingController(text: DATE_FORMAT(PRO.userData?.dob));
          //PHONE
          case 8:
            return TextEditingController(text: PRO.userData?.phone);
          //ADRRESS
          case 9:
            return TextEditingController(text: PRO.userData?.address);
          //MARITAL
          case 10:
            return TextEditingController(text: MARITAL(PRO.userData!.maritalStatus!));
          //AMOUNT OF CHILD
          case 11:
            return TextEditingController(text: AMOUNT_OF_CHILD(PRO.userData!.amountOfChildren!));
          //ABOUT
          case 12:
            return TextEditingController(text: PRO.userData?.aboutMe);
          default:
            return TextEditingController();
        }
      } catch (e) {
        return TextEditingController();
      }
    });
    try {
      var _user = PRO.userData?.toJson();
      for (var item in payloadKey) {
        payload.update(item, (v) => _user![item], ifAbsent: () {
          payload.putIfAbsent(item, () => _user![item]);
        });
      }
    } catch (e) {
      ERROR_SNACK_BAR("Perhatian", "$e");
    }
    addressController = List.generate(3, (i) {
      try {
        switch (i) {
          case 0:
            return TextEditingController(
                text: ADDRESS_ROOT()!.firstWhere((e) => e.id == PRO.userData!.countryId!).name);
          case 1:
            return TextEditingController(text: STATE_NAME(PRO.userData!.stateId!));
          case 2:
            return TextEditingController(text: CITY_NAME(PRO.userData!.cityId!));
          default:
            return TextEditingController();
        }
      } catch (e) {
        return TextEditingController();
      }
    });
    useUpdate ? update() : null;
  }

  late List<bool> readOnly;
  late List<TextInputType> textInputType;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    focusNodes = List.generate(placeholder.length, (i) => FocusNode());
    textInputType = List.generate(placeholder.length, (i) {
      switch (i) {
        case 2:
          return TextInputType.number;
        case 3:
          return TextInputType.number;
        case 6:
          return TextInputType.emailAddress;
        case 8:
          return TextInputType.number;
        case 12:
          return TextInputType.multiline;
        default:
          return TextInputType.text;
      }
    });
    readOnly = List.generate(placeholder.length, (i) {
      switch (i) {
        case 4:
          return true;
        case 5:
          return true;
        case 6:
          return true;
        case 7:
          return true;
        case 9:
          return true;
        case 10:
          return true;
        case 11:
          return true;
        default:
          return false;
      }
    });
  }

  int? get countryId {
    try {
      return ADDRESS_ROOT()?.firstWhere((e) => e.name == addressController[0].text).id;
    } catch (e) {
      return null;
    }
  }

  int? get stateId {
    try {
      return STATES_DATA()?.firstWhere((e) => e.name == addressController[1].text).id;
    } catch (e) {
      return null;
    }
  }

  int? get cityId {
    try {
      return CITIES_DATA()?.firstWhere((e) => e.name == addressController[2].text).id;
    } catch (e) {
      return null;
    }
  }

  Future<void> bottomSheetAddress(int index) async {
    int _selectedIndex = 0;
    await Get.bottomSheet(StatefulBuilder(builder: (context, st) {
      return BOX_BORDER(
          SizedBox(
            height: Get.height / 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TEXT(addressPlaceholderBottomSheet(index), style: Get.textTheme.headline1),
                      OUTLINE_BUTTON('Pilih', onPressed: () async {
                        switch (index) {
                          case 0:
                            try {
                              var _selectedCountry = ADDRESS_ROOT()![_selectedIndex];
                              addressController[0].text = _selectedCountry.name!;
                              payload.update('country_id', (value) => _selectedCountry.id);
                              payload.update('state_id', (value) => null);
                              payload.update('state_id', (value) => null);
                              update();
                              if (_selectedCountry.id == 3) {
                                Get.back();
                                return;
                              }
                              await PRO.getStates(_selectedCountry.id!);
                              addressController[1].clear();
                              addressController[2].clear();
                            } catch (e) {
                              ERROR_SNACK_BAR(
                                  "Perrhatian", 'Terjadi Kesalahan saat memilih Negara');
                              Get.back();
                            }
                            break;
                          case 1:
                            try {
                              var _selectedState = STATES_DATA()![_selectedIndex];
                              addressController[1].text = _selectedState.name!;
                              await PRO.getCity(_selectedState.id!);
                              addressController[2].clear();
                              payload.update('state_id', (value) => _selectedState.id);
                              payload.update('city_id', (value) => null);
                            } catch (e) {
                              ERROR_SNACK_BAR(
                                  "Perrhatian", 'Terjadi Kesalahan saat memilih Wilayah');
                              Get.back();
                            }
                            break;
                          case 2:
                            try {
                              var _selectedCity = CITIES_DATA()![_selectedIndex];
                              addressController[2].text = _selectedCity.name!;
                              payload.update('city_id', (value) => _selectedCity.id);
                            } catch (e) {
                              ERROR_SNACK_BAR(
                                  "Perrhatian", 'Terjadi Kesalahan saat memilih Wilayah');
                              Get.back();
                            }
                            break;
                          default:
                            break;
                        }
                        Get.back();
                      }, useExpanded: false)
                    ],
                  ),
                ),
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                      physics: const FixedExtentScrollPhysics(),
                      itemExtent: 40,
                      onSelectedItemChanged: (i) {
                        st(() {
                          _selectedIndex = i;
                          switch (index) {
                            case 0:
                              addressController[index].text = '${ADDRESS_ROOT()?[i].name}';
                              break;
                            case 1:
                              addressController[index].text = '${STATES_DATA()?[i].name}';
                              break;
                            case 2:
                              addressController[index].text = '${CITIES_DATA()?[i].name}';
                              break;
                            default:
                              break;
                          }
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                          childCount: _listWheelChildCount(index),
                          builder: (context, i) {
                            switch (index) {
                              case 1:
                                return _statesList(i, _selectedIndex);
                              case 2:
                                return _citiesList(i, _selectedIndex);
                              default:
                                return _countriesList(i, _selectedIndex);
                            }
                          })),
                ),
              ],
            ),
          ),
          fillColor: Colors.white);
    }), isDismissible: true);
  }

  String addressPlaceholderBottomSheet(int index) {
    switch (index) {
      case 1:
        return "Pilih Wilayah";
      case 2:
        return "Pilih Kota";
      default:
        return "Pilih Negara";
    }
  }

  Widget _countriesList(int i, int _selectedIndex) {
    var _data = ADDRESS_ROOT()![i];
    if (_selectedIndex == i) {
      return BOX_BORDER(Center(
          child: TEXT(_data.name,
              style:
                  COSTUM_TEXT_STYLE(color: BLUEKALM, fonstSize: 20, fontWeight: FontWeight.bold))));
    } else {
      return Center(child: TEXT(_data.name, style: COSTUM_TEXT_STYLE(color: Colors.grey)));
    }
  }

  Widget _statesList(int i, int _selectedIndex) {
    var _data = STATES_DATA()![i];
    if (_selectedIndex == i) {
      return BOX_BORDER(Center(
          child: TEXT(_data.name,
              style:
                  COSTUM_TEXT_STYLE(color: BLUEKALM, fonstSize: 20, fontWeight: FontWeight.bold))));
    } else {
      return Center(child: TEXT(_data.name, style: COSTUM_TEXT_STYLE(color: Colors.grey)));
    }
  }

  Widget _citiesList(int i, int _selectedIndex) {
    var _data = CITIES_DATA()![i];
    if (_selectedIndex == i) {
      return BOX_BORDER(Center(
          child: TEXT(_data.name,
              style:
                  COSTUM_TEXT_STYLE(color: BLUEKALM, fonstSize: 20, fontWeight: FontWeight.bold))));
    } else {
      return Center(child: TEXT(_data.name, style: COSTUM_TEXT_STYLE(color: Colors.grey)));
    }
  }

  int _listWheelChildCount(int i) {
    try {
      switch (i) {
        case 0:
          return ADDRESS_ROOT()!.length;
        case 1:
          return STATES_DATA()!.length;
        case 2:
          return CITIES_DATA()!.length;
        default:
          return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  bool? dob13;
  void updateDob13(bool check) {
    dob13 = check;
    update();
  }

  Future<void> updateDob(int i) async {
    try {
      selectedDob = await DATE_PICKER(initialDateTime: selectedDob ?? PRO.userData?.dob);
      textController[i].text = DATE_FORMAT(selectedDob!)!;
      payload.update('dob', (value) => selectedDob!.toIso8601String());
      if (VALIDATE_DOB_MATURE(selectedDob)! <= 12.999) {
        dob13 = null;
      } else if (VALIDATE_DOB_MATURE(selectedDob)! >= 12.999 &&
          VALIDATE_DOB_MATURE(selectedDob)! < 14) {
        dob13 = false;
      } else {
        dob13 = null;
      }
      update();
    } catch (e) {
      return;
    }
  }

  void updateMarital(Answer answer, int i) {
    try {
      payload.update(payloadKey[i], (v) => answer.id, ifAbsent: () {
        payload.putIfAbsent(payloadKey[i], () => answer.id);
      });
      textController[i].text = answer.answer!;
      update();
    } catch (e) {
      ERROR_SNACK_BAR("Perhatian", "$e");
    }
  }

  void updateReligion(int answer, int i) {
    try {
      payload.update(payloadKey[i], (v) => (answer + 1), ifAbsent: () {
        payload.putIfAbsent(payloadKey[i], () => (answer + 1));
      });
      textController[i].text = RELIGION_LIST[answer];
      update();
    } catch (e) {
      ERROR_SNACK_BAR("Perhatian", "$e");
    }
  }

  void updateGender(int answer, int i) {
    try {
      payload.update(payloadKey[i], (v) => answer, ifAbsent: () {
        payload.putIfAbsent(payloadKey[i], () => answer);
      });
      textController[i].text = GENDER_LIST[answer];
      update();
    } catch (e) {
      ERROR_SNACK_BAR("Perhatian", "$e");
    }
  }

  void updateAmountChild(Answer answer, int i) {
    try {
      payload.update(payloadKey[i], (v) => answer.id, ifAbsent: () {
        payload.putIfAbsent(payloadKey[i], () => answer.id);
      });
      textController[i].text = answer.answer!;
      update();
    } catch (e) {
      ERROR_SNACK_BAR("Perhatian", "$e");
    }
  }

  bool get addressValiation {
    if (cityId == 3) {
      return true;
    } else if (cityId != 3 && (stateId == null || cityId == null)) {
      return false;
    } else {
      return true;
    }
  }

  bool get dobValidation {
    try {
      if (selectedDob == null) {
        return false;
      } else if (VALIDATE_DOB_MATURE(selectedDob)! <= 12.999) {
        return false;
      } else if (VALIDATE_DOB_MATURE(selectedDob)! >= 12.999 &&
          VALIDATE_DOB_MATURE(selectedDob)! < 14) {
        return dob13!;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  bool get requiredFieldValidation {
    return textController[0].text.isNotEmpty && textController[8].text.isNotEmpty;
  }

  Future<void> submit(BuildContext context) async {
    if (!addressValiation) {
      ERROR_SNACK_BAR("Perhatian", "Alamat wajib diisi semua");
      return;
    } else if (!dobValidation) {
      ERROR_SNACK_BAR("Perhatian", "Usia Anda belum memenuhi syarat");
      return;
    } else if (!requiredFieldValidation) {
      ERROR_SNACK_BAR("Perhatian", "Pastikan Nama Depan Atau Nomer HP sudah diisi");
      return;
    }
    var _res = await Api().POST(USER_UPDATE, payload, useToken: true);
    if (_res?.statusCode == 200) {
      var _data = UserModel.fromJson(_res?.data);
      await PRO.saveLocalUser(_data.data);
      SUCCESS_SNACK_BAR("Perhatian", _data.message);
      Loading.hide();
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      return;
    }
  }
}

import 'dart:convert';

import 'package:kalm/model/matchup_model/matchup_json.dart';
import 'package:kalm/model/user_model/user_counselor_optional_files.dart';
import 'package:kalm/model/user_model/user_has_active_counselor.dart';
import 'package:kalm/model/user_model/user_notification_setting.dart';
import 'package:kalm/model/user_model/user_subcription.dart';
import 'package:kalm/model/user_model/user_subscription_list.dart';

class UserData {
  int? id;
  String? code;
  int? balance;
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  DateTime? dob;
  int? gender;
  String? address;
  int? cityId;
  int? stateId;
  int? countryId;
  String? postalCode;
  String? timezoneId;
  String? phone;
  String? photo;
  String? photoBackground;
  String? aboutMe;
  String? idNumber;
  String? npwpNumber;
  int? maritalStatus;
  int? religion;
  int? amountOfChildren;
  int? isPinCodeActive;
  int? isMatchupCounterNotified;
  String? firebaseToken;
  String? onesignalToken;
  String? token;
  int? status;
  dynamic role;
  dynamic deviceNumber;
  int? deviceType;
  String? createdAt;
  String? updatedAt;
  Map<String, dynamic>? city;
  Map<String, dynamic>? state;
  Map<String, dynamic>? country;
  dynamic activationCode;
  List<MatchupJson?>? matchupJson;
  UserSubcription? userSubcription;
  List<UserSubscriptionList?>? userSubscriptionList;
  UserHasActiveCounselor? userHasActiveCounselor;
  List<UserCounselorOptionalFiles?>? userCounselorOptionalFiles;
  bool? hasBuyPackage;
  UserNotificationSetting? userNotificationSetting;
  UserData({
    this.id,
    this.code,
    this.balance,
    this.firstName,
    this.middleName,
    this.lastName,
    this.email,
    this.dob,
    this.gender,
    this.address,
    this.cityId,
    this.stateId,
    this.countryId,
    this.postalCode,
    this.timezoneId,
    this.phone,
    this.photo,
    this.photoBackground,
    this.aboutMe,
    this.idNumber,
    this.npwpNumber,
    this.maritalStatus,
    this.religion,
    this.amountOfChildren,
    this.isPinCodeActive,
    this.isMatchupCounterNotified,
    this.firebaseToken,
    this.onesignalToken,
    this.token,
    this.status,
    this.role,
    this.deviceNumber,
    this.deviceType,
    this.createdAt,
    this.updatedAt,
    this.city,
    this.state,
    this.country,
    this.activationCode,
    this.matchupJson,
    this.userSubcription,
    this.userSubscriptionList,
    this.userHasActiveCounselor,
    this.userCounselorOptionalFiles,
    this.hasBuyPackage,
    this.userNotificationSetting,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] as int?;
      code = json['code'] as String?;
      balance = json['balance'] as int?;
      firstName = json['first_name'] as String?;
      middleName = json['middle_name'] as String?;
      lastName = json['last_name'] as String?;
      email = json['email'] as String?;
      dob = json['dob'] == null ? null : DateTime.parse(json['dob']);
      gender = json['gender'].runtimeType == int ? json['gender'] : int.parse(json['gender']);
      address = json['address'] as String?;
      cityId = json['city_id'] as int?;
      stateId = json['state_id'] as int?;
      countryId = json['country_id'] as int?;
      postalCode = json['postal_code'] as String?;
      timezoneId = json['timezone_id'] as String?;
      phone = json['phone'] as String?;
      photo = json['photo'] as String?;
      photoBackground = json['photo_background'] as String?;
      aboutMe = json['about_me'] as String?;
      idNumber = json['id_number'] as String?;
      npwpNumber = json['npwp_number'] as String?;
      isPinCodeActive = json['is_pin_code_active'] as int?;
      isMatchupCounterNotified = json['is_matchup_counter_notified'] as int?;
      firebaseToken = json['firebase_token'] as String?;
      onesignalToken = json['onesignal_token'] as String?;
      token = json['token'] as String?;
      status = json['status'] as int?;
      role = json['role'].toString();
      deviceNumber = json['device_number'].toString();
      deviceType = json['device_type'] as int?;
      createdAt = json['created_at'] as String?;
      updatedAt = json['updated_at'] as String?;
      city = json['city'];
      state = json['state'];
      country = json['country'];
      activationCode = json['activation_code'].toString();
      maritalStatus = json['marital_status'] == null
          ? null
          : json['marital_status'].runtimeType == int
              ? json['marital_status']
              : int.parse(json['marital_status']);
      religion = json['religion'] == null
          ? null
          : json['religion'].runtimeType == int
              ? json['religion']
              : int.parse(json['religion']);
      amountOfChildren = json['amount_of_children'].runtimeType == int
          ? json['amount_of_children']
          : int.parse(json['amount_of_children']);
      matchupJson = json['matchup_json'] == null
          ? null
          : List.generate(jsonDecode(json['matchup_json']).length, (i) {
              return MatchupJson.fromJson(jsonDecode(json['matchup_json'])[i]);
            });
      userSubcription = json['user_subscription'] == null
          ? null
          : UserSubcription.fromJson(json['user_subscription']);
      userSubscriptionList = json['user_subscription_list'] == null
          ? null
          : List.generate(json['user_subscription_list'].length, (i) {
              return UserSubscriptionList.fromJson(json['user_subscription_list'][i]);
            });
      userHasActiveCounselor = json['user_has_active_counselor'] != null
          ? UserHasActiveCounselor.fromJson(json['user_has_active_counselor'])
          : null;
      userCounselorOptionalFiles = json['user_counselor_optional_files'] == null
          ? null
          : List.generate((json['user_counselor_optional_files'] as List<dynamic>).length, (i) {
              return UserCounselorOptionalFiles.fromJson(
                  (json['user_counselor_optional_files'] as List<dynamic>)[i]);
            });
      hasBuyPackage = (json['ever_bought_package_subscription']) ?? false;
      userNotificationSetting = json['user_setting'] != null
          ? UserNotificationSetting.fromJson(json['user_setting'])
          : null;
    } catch (e) {
      // print(e);
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'balance': balance,
        'first_name': firstName,
        'middle_name': middleName,
        'last_name': lastName,
        'email': email,
        'dob': dob?.toIso8601String(),
        'gender': gender,
        'address': address,
        'city_id': cityId,
        'state_id': stateId,
        'country_id': countryId,
        'postal_code': postalCode,
        'timezone_id': timezoneId,
        'phone': phone,
        'photo': photo,
        'photo_background': photoBackground,
        'about_me': aboutMe,
        'id_number': idNumber,
        'npwp_number': npwpNumber,
        'marital_status': maritalStatus,
        'religion': religion,
        'amount_of_children': amountOfChildren,
        'is_pin_code_active': isPinCodeActive,
        'is_matchup_counter_notified': isMatchupCounterNotified,
        'firebase_token': firebaseToken,
        'onesignal_token': onesignalToken,
        'token': token,
        'status': status,
        'role': role,
        'device_number': deviceNumber,
        'device_type': deviceType,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'city': city,
        'state': state,
        'country': country,
        'activation_code': activationCode,
        'matchup_json': matchupJson?.map((e) => e?.toJson()).toList(),
        'user_subscription': userSubcription?.toJson(),
        'user_subscription_list': userSubscriptionList?.map((e) => e?.toJson()).toList(),
        'user_has_active_counselor': userHasActiveCounselor?.toJson(),
        'user_counselor_optional_files': userCounselorOptionalFiles?.map((e) => e?.toJson()),
        'ever_bought_package_subscription': hasBuyPackage,
        'user_setting': userNotificationSetting?.toJson(),
      };
}

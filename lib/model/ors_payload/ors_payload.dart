import 'ors_value.dart';

class OrsPayload {
  String? userCode;
  String? date;
  OrsValue? value;

  OrsPayload({this.userCode, this.date, this.value});

  factory OrsPayload.fromJson(Map<String, dynamic> json) => OrsPayload(
        userCode: json['user_code'] as String?,
        date: json['date'] as String?,
        value: json['value'] == null
            ? null
            : OrsValue.fromJson(json['value'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'user_code': userCode,
        'date': date,
        'value': value?.toJson(),
      };
}

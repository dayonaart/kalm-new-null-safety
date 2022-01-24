import 'data.dart';

class OvoResModel {
  OvoResData? data;

  OvoResModel({this.data});

  factory OvoResModel.fromJson(Map<String, dynamic> json) => OvoResModel(
        data: json['data'] == null
            ? null
            : OvoResData.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
      };
}

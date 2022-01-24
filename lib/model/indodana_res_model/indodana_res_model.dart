import 'indodana.dart';

class IndodanaResModel {
  Indodana? indodana;

  IndodanaResModel({this.indodana});

  factory IndodanaResModel.fromJson(Map<String, dynamic> json) {
    return IndodanaResModel(
      indodana: json['data'] == null
          ? null
          : Indodana.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': indodana?.toJson(),
      };
}

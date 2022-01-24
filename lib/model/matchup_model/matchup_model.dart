import 'dart:convert';

import 'matchup_json.dart';

class MatchupModel {
  int? id;
  String? email;
  List<MatchupJson>? matchupJson;

  MatchupModel({this.id, this.email, this.matchupJson});

  factory MatchupModel.fromJson(Map<String, dynamic> json) {
    try {
      return MatchupModel(
        id: json['id'] as int?,
        email: json['email'] as String?,
        matchupJson: ((jsonDecode(json['matchup_json'])) as List<dynamic>?)
            ?.map((e) => MatchupJson.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      return MatchupModel(
          id: json['id'] as int?,
          email: json['email'] as String?,
          matchupJson: null);
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'matchup_json': matchupJson?.map((e) => e.toJson()).toList(),
      };
}

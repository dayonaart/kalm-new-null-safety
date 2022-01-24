import 'matchup_datum.dart';

class UserMatchupResModel {
  int? status;
  String? message;
  List<MatchupData>? matchupData;

  UserMatchupResModel({this.status, this.message, this.matchupData});

  factory UserMatchupResModel.fromJson(Map<String, dynamic> json) {
    return UserMatchupResModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      matchupData: (json['data'] as List<dynamic>?)
          ?.map((e) => MatchupData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': matchupData?.map((e) => e.toJson()).toList(),
      };
}

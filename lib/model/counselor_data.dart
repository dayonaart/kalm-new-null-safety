import 'package:kalm/model/user_model/user_data.dart';

class CounselorData {
  int? status;
  String? message;
  int? matchupId;
  int? isReadTnc;
  int? isReadTncUpdate;
  UserData? counselor;

  CounselorData({
    this.status,
    this.message,
    this.matchupId,
    this.isReadTnc,
    this.isReadTncUpdate,
    this.counselor,
  });

  factory CounselorData.fromJson(Map<String, dynamic> json) {
    return CounselorData(
        status: json['status'] as int?,
        message: json['message'] as String?,
        matchupId: json['matchup_id'] as int?,
        isReadTnc: json['is_read_tnc'] as int?,
        isReadTncUpdate: json['is_read_tnc_update'] as int?,
        counselor: UserData.fromJson(json['data']));
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'matchup_id': matchupId,
        'is_read_tnc': isReadTnc,
        'is_read_tnc_update': isReadTncUpdate,
        'counselor': counselor?.toJson()
      };
}

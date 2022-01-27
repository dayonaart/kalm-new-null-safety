import 'package:kalm/model/gratitude_journal_history_res_model/gratitude_journal_history.dart';
import 'gratitude_data.dart';

class GratitudeResModel {
  int? status;
  String? message;
  List<GratitudeData>? gratitudeData;
  List<GratitudeJournalHistoryData>? gratitudeJournalHistoryResModel;
  GratitudeResModel(
      {this.status, this.message, this.gratitudeData, this.gratitudeJournalHistoryResModel});

  factory GratitudeResModel.fromJson(Map<String, dynamic> json) {
    return GratitudeResModel(
        status: json['status'] as int?,
        message: json['message'] as String?,
        gratitudeData: json['data'].runtimeType == List
            ? (json['data'] as List<dynamic>?)
                ?.map((e) => GratitudeData.fromJson(e as Map<String, dynamic>))
                .toList()
            : null,
        gratitudeJournalHistoryResModel: json['data'].runtimeType == List
            ? (json['data'] as List<dynamic>?)
                ?.map((e) => GratitudeJournalHistoryData.fromJson(e as Map<String, dynamic>))
                .toList()
            : null);
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': gratitudeData?.map((e) => e.toJson()).toList(),
        'gratitude_history': gratitudeJournalHistoryResModel?.map((e) => e.toJson()).toList()
      };
}

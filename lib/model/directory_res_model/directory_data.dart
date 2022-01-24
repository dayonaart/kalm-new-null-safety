import 'data_item.dart';

class DirectoryData {
  String? title;
  List<DataItem>? dataItem;

  DirectoryData({this.title, this.dataItem});

  factory DirectoryData.fromJson(Map<String, dynamic> json) {
    return DirectoryData(
      title: json['title'] as String?,
      dataItem: (json['data'] as List<dynamic>?)
          ?.map((e) => DataItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'data': dataItem?.map((e) => e.toJson()).toList(),
      };
}

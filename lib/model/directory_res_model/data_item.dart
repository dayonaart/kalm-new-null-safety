import 'item.dart';

class DataItem {
  String? title;
  List<Item>? item;

  DataItem({this.title, this.item});

  factory DataItem.fromJson(Map<String, dynamic> json) => DataItem(
        title: json['title'] as String?,
        item: (json['data'] as List<dynamic>?)
            ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'data': item?.map((e) => e.toJson()).toList(),
      };
}

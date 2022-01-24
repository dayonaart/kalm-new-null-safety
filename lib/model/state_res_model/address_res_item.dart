import 'address_item_data.dart';

class AddressResItem {
  int? status;
  String? message;
  List<AddressItemData>? data;

  AddressResItem({this.status, this.message, this.data});

  factory AddressResItem.fromJson(Map<String, dynamic> json) => AddressResItem(
        status: json['status'] as int?,
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => AddressItemData.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}

import 'package:collection/collection.dart';

import 'quote_data.dart';

class QuoteResModel {
  int? status;
  String? message;
  Data? data;

  QuoteResModel({this.status, this.message, this.data});

  factory QuoteResModel.fromJson(Map<String, dynamic> json) => QuoteResModel(
        status: json['status'] as int?,
        message: json['message'] as String?,
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };

  QuoteResModel copyWith({
    int? status,
    String? message,
    Data? data,
  }) {
    return QuoteResModel(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! QuoteResModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;
}

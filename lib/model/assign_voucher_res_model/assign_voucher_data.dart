import 'original.dart';

class AssignVoucherData {
  Original? original;
  dynamic exception;

  AssignVoucherData({this.original, this.exception});

  factory AssignVoucherData.fromJson(Map<String, dynamic> json) =>
      AssignVoucherData(
        original: json['original'] == null
            ? null
            : Original.fromJson(json['original'] as Map<String, dynamic>),
        exception: json['exception'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'original': original?.toJson(),
        'exception': exception,
      };
}

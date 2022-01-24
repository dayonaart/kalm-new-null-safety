import 'payment.dart';

class Indodana {
  String? status;
  List<Payment>? payments;

  Indodana({this.status, this.payments});

  factory Indodana.fromJson(Map<String, dynamic> json) => Indodana(
        status: json['status'] as String?,
        payments: (json['payments'] as List<dynamic>?)
            ?.map((e) => Payment.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'payments': payments?.map((e) => e.toJson()).toList(),
      };
}

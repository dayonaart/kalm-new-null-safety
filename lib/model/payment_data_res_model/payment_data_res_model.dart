import 'action.dart';
import 'va_number.dart';

class PaymentDataResModel {
  String? statusCode;
  String? statusMessage;
  String? transactionId;
  String? orderId;
  String? merchantId;
  String? grossAmount;
  String? currency;
  String? paymentType;
  DateTime? transactionTime;
  String? transactionStatus;
  String? permataVaNumber;
  String? billKey;
  String? billerCode;
  List<VaNumber>? vaNumbers;
  List<Action>? actions;
  String? fraudStatus;

  PaymentDataResModel({
    this.statusCode,
    this.statusMessage,
    this.transactionId,
    this.orderId,
    this.merchantId,
    this.grossAmount,
    this.currency,
    this.paymentType,
    this.transactionTime,
    this.transactionStatus,
    this.permataVaNumber,
    this.billKey,
    this.billerCode,
    this.vaNumbers,
    this.actions,
    this.fraudStatus,
  });

  factory PaymentDataResModel.fromJson(Map<String, dynamic> json) {
    return PaymentDataResModel(
      statusCode: json['status_code'] as String?,
      statusMessage: json['status_message'] as String?,
      transactionId: json['transaction_id'] as String?,
      orderId: json['order_id'] as String?,
      merchantId: json['merchant_id'] as String?,
      grossAmount: json['gross_amount'] as String?,
      currency: json['currency'] as String?,
      paymentType: json['payment_type'] as String?,
      transactionTime: json['transaction_time'] != null
          ? DateTime.parse(json['transaction_time'])
          : null,
      transactionStatus: json['transaction_status'] as String?,
      permataVaNumber: json['permata_va_number'] as String?,
      billKey: json['bill_key'] as String?,
      billerCode: json['biller_code'] as String?,
      vaNumbers: (json['va_numbers'] as List<dynamic>?)
          ?.map((e) => VaNumber.fromJson(e as Map<String, dynamic>))
          .toList(),
      actions: (json['actions'] as List<dynamic>?)
          ?.map((e) => Action.fromJson(e as Map<String, dynamic>))
          .toList(),
      fraudStatus: json['fraud_status'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'status_code': statusCode,
        'status_message': statusMessage,
        'transaction_id': transactionId,
        'order_id': orderId,
        'merchant_id': merchantId,
        'gross_amount': grossAmount,
        'currency': currency,
        'payment_type': paymentType,
        'transaction_time': transactionTime,
        'transaction_status': transactionStatus,
        'permata_va_number': permataVaNumber,
        'bill_key': billKey,
        'biller_code': billerCode,
        'va_numbers': vaNumbers?.map((e) => e.toJson()).toList(),
        'actions': actions?.map((e) => e.toJson()).toList(),
        'fraud_status': fraudStatus,
      };
}

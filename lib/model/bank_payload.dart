class BankPayload {
  String? bank;
  String? orderId;
  int? amount;
  String? userCode;

  BankPayload({this.bank, this.orderId, this.amount, this.userCode});

  factory BankPayload.fromJson(Map<String, dynamic> json) => BankPayload(
        bank: json['bank'] as String?,
        orderId: json['order_id'] as String?,
        amount: json['amount'] as int?,
        userCode: json['user_code'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'bank': bank,
        'order_id': orderId,
        'amount': amount,
        'user_code': userCode,
      };
}

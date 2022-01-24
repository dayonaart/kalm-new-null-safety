class AnotherResponseData {
  String? status;
  String? redirectUrl;
  String? transactionId;

  AnotherResponseData({this.status, this.redirectUrl, this.transactionId});

  factory AnotherResponseData.fromJson(Map<String, dynamic> json) {
    return AnotherResponseData(
      status: json['status'] as String?,
      redirectUrl: json['redirectUrl'] as String?,
      transactionId: json['transactionId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'redirectUrl': redirectUrl,
        'transactionId': transactionId,
      };
}

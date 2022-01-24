class VaNumber {
  String? bank;
  String? vaNumber;

  VaNumber({this.bank, this.vaNumber});

  factory VaNumber.fromJson(Map<String, dynamic> json) => VaNumber(
        bank: json['bank'] as String?,
        vaNumber: json['va_number'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'bank': bank,
        'va_number': vaNumber,
      };
}

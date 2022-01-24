class Payment {
  int? downPayment;
  String? paymentType;
  int? amount;
  int? installmentAmount;
  int? rate;
  int? monthlyInstallment;
  int? discountedMonthlyInstallment;
  int? tenure;
  String? tenureTimeUnit;
  String? id;

  Payment({
    this.downPayment,
    this.paymentType,
    this.amount,
    this.installmentAmount,
    this.rate,
    this.monthlyInstallment,
    this.discountedMonthlyInstallment,
    this.tenure,
    this.tenureTimeUnit,
    this.id,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        downPayment: json['downPayment'] as int?,
        paymentType: json['paymentType'] as String?,
        amount: json['amount'] as int?,
        installmentAmount: json['installmentAmount'] as int?,
        rate: json['rate'] as int?,
        monthlyInstallment: json['monthlyInstallment'] as int?,
        discountedMonthlyInstallment:
            json['discountedMonthlyInstallment'] as int?,
        tenure: json['tenure'] as int?,
        tenureTimeUnit: json['tenureTimeUnit'] as String?,
        id: json['id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'downPayment': downPayment,
        'paymentType': paymentType,
        'amount': amount,
        'installmentAmount': installmentAmount,
        'rate': rate,
        'monthlyInstallment': monthlyInstallment,
        'discountedMonthlyInstallment': discountedMonthlyInstallment,
        'tenure': tenure,
        'tenureTimeUnit': tenureTimeUnit,
        'id': id,
      };
}

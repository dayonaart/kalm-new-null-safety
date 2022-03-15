class OrsValue {
  int? first;
  int? second;
  int? third;
  int? four;

  OrsValue({this.first, this.second, this.third, this.four});

  factory OrsValue.fromJson(Map<String, dynamic> json) => OrsValue(
        first: json['0'] as int?,
        second: json['1'] as int?,
        third: json['2'] as int?,
        four: json['3'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '0': first,
        '1': second,
        '2': third,
        '3': four,
      };
}

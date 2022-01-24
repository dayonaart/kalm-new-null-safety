class CountryData {
  int? id;
  String? name;
  String? code;
  int? status;
  int? order;

  CountryData({this.id, this.name, this.code, this.status, this.order});

  factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
        id: json['id'] as int?,
        name: json['name'] as String?,
        code: json['code'] as String?,
        status: json['status'] as int?,
        order: json['order'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'status': status,
        'order': order,
      };
}

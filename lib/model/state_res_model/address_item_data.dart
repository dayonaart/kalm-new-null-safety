class AddressItemData {
  int? id;
  int? countryId;
  String? name;
  int? status;
  int? order;

  AddressItemData(
      {this.id, this.countryId, this.name, this.status, this.order});

  factory AddressItemData.fromJson(Map<String, dynamic> json) =>
      AddressItemData(
        id: json['id'] as int?,
        countryId: json['country_id'] as int?,
        name: json['name'] as String?,
        status: json['status'] as int?,
        order: json['order'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'country_id': countryId,
        'name': name,
        'status': status,
        'order': order,
      };
}

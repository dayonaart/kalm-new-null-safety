class HowToData {
  String? name;
  int? id;
  String? description;

  HowToData({this.name, this.id, this.description});

  factory HowToData.fromJson(Map<String, dynamic> json) => HowToData(
        name: json['name'] as String?,
        id: json['id'] as int?,
        description: json['description'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'description': description,
      };
}

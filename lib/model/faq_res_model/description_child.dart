class DescriptionChild {
  String? name;
  String? description;
  String? note;

  DescriptionChild({this.name, this.description, this.note});

  factory DescriptionChild.fromJson(Map<String, dynamic> json) {
    return DescriptionChild(
      name: json['name'] as String?,
      description: json['description'] as String?,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'note': note,
      };
}

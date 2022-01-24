class TutorialBankModel {
  String? name;
  List<String>? data;
  String? title;

  TutorialBankModel({this.name, this.data, this.title});

  factory TutorialBankModel.fromJson(Map<String, dynamic> json) {
    return TutorialBankModel(
      name: json['name'] as String?,
      data: json['data'] as List<String>?,
      title: json['title'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'data': data,
        'title': title,
      };
}

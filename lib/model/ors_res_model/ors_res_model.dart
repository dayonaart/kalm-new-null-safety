class OrsResModel {
  String? content;
  int? fontSize;
  String? title;

  OrsResModel({this.content, this.fontSize, this.title});

  factory OrsResModel.fromJson(Map<dynamic, dynamic> json) => OrsResModel(
        content: json['content'] as String?,
        fontSize: json['fontSize'] as int?,
        title: json['title'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'content': content,
        'fontSize': fontSize,
        'title': title,
      };
}

class OrsResultModel {
  String? desc;
  int? id;
  String? title;
  double? titleSize;
  double? descSize;

  OrsResultModel({
    this.desc,
    this.id,
    this.title,
    this.titleSize,
    this.descSize,
  });

  OrsResultModel.fromJson(Map<dynamic, dynamic> json) {
    desc = json['desc'];
    id = json['id'];
    title = json['title'];
    titleSize = (json['title_size'] as int).toDouble();
    descSize = (json['desc_size'] as int).toDouble();
  }

  Map<dynamic, dynamic> toJson() {
    final Map data = <dynamic, dynamic>{};
    data['desc'] = desc;
    data['id'] = id;
    data['title'] = title;
    data['title_size'] = titleSize;
    data['desc_size'] = descSize;
    return data;
  }
}

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

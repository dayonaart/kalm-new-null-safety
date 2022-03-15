class SurveyResModel {
  String? content;
  String? btnAccTitle;
  String? title;
  String? btnRejectTitle;
  String? url;

  SurveyResModel({
    this.content,
    this.btnAccTitle,
    this.title,
    this.btnRejectTitle,
    this.url,
  });

  factory SurveyResModel.fromJson(Map<String, dynamic> json) {
    return SurveyResModel(
      content: json['content'] as String?,
      btnAccTitle: json['btn_acc_title'] as String?,
      title: json['title'] as String?,
      btnRejectTitle: json['btn_reject_title'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content,
        'btn_acc_title': btnAccTitle,
        'title': title,
        'btn_reject_title': btnRejectTitle,
        'url': url,
      };
}

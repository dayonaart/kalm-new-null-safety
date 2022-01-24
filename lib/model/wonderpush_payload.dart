class WonderpushPayload {
  String? content;
  int? userId;
  String? title;

  WonderpushPayload({this.content, this.userId, this.title});

  factory WonderpushPayload.fromJson(Map<String, dynamic> json) {
    return WonderpushPayload(
      content: json['content'] as String?,
      userId: json['user_id'] as int?,
      title: json['title'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content,
        'user_id': userId,
        'title': title,
      };
}

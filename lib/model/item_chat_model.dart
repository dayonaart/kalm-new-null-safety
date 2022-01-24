class ItemChatModel {
  String? readed;
  String? status;
  String? code;
  String? message;
  int? created;
  String? name;
  String? toCode;

  ItemChatModel({
    this.readed,
    this.status,
    this.code,
    this.message,
    this.created,
    this.name,
    this.toCode,
  });

  factory ItemChatModel.fromJson(Map<String, dynamic> json) => ItemChatModel(
        readed: json['readed'] as String?,
        status: json['status'] as String?,
        code: json['code'] as String?,
        message: json['message'] as String?,
        created: json['created'] as int?,
        name: json['name'] as String?,
        toCode: json['to_code'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'readed': readed,
        'status': status,
        'code': code,
        'message': message,
        'created': created,
        'name': name,
        'to_code': toCode,
      };
}

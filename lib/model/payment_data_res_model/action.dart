class Action {
  String? name;
  String? method;
  String? url;

  Action({this.name, this.method, this.url});

  factory Action.fromJson(Map<String, dynamic> json) => Action(
        name: json['name'] as String?,
        method: json['method'] as String?,
        url: json['url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'method': method,
        'url': url,
      };
}

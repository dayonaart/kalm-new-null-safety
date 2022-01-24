import 'article_data.dart';

class ArticleResModel {
  int? currentPage;
  List<ArticleData>? data;

  ArticleResModel({this.currentPage, this.data});

  factory ArticleResModel.fromJson(Map<String, dynamic> json) {
    return ArticleResModel(
      currentPage: json['current_page'] as int?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ArticleData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}

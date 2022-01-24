import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/model/article_res_model/article_data.dart';
import 'package:kalm/widget/image_cache.dart';
import 'package:kalm/widget/loading.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailArticlePage extends StatelessWidget {
  ArticleData? articleData;
  DetailArticlePage({Key? key, @required this.articleData}) : super(key: key);
  final _controller = Get.put(DetailArticleController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailArticleController>(
        initState: (st) {},
        builder: (_) {
          return SAFE_AREA(
            child: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    children: [
                      IMAGE_CACHE(
                          IMAGE_URL + ARTICLE + (articleData?.file ?? "")),
                      SPACE(),
                      TEXT(articleData?.name, style: Get.textTheme.headline2),
                      SPACE(),
                      Html(
                          style: {
                            "p": Style(
                                fontSize: const FontSize(16),
                                color: Colors.black,
                                fontWeight: FontWeight.normal)
                          },
                          data: articleData?.description,
                          onLinkTap: (l, r, o, e) {
                            var _loading = 0;
                            var _fixUrl =
                                l!.contains("https") || l.contains("http")
                                    ? l
                                    : "https://$l";
                            pushNewScreen(context,
                                screen: StatefulBuilder(builder: (context, st) {
                              return SAFE_AREA(
                                  child: Stack(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: WebView(
                                          javascriptMode:
                                              JavascriptMode.unrestricted,
                                          initialUrl: _fixUrl,
                                          onProgress: (int p) {
                                            st(() {
                                              _loading = p;
                                            });
                                          })),
                                  if (_loading != 100)
                                    Center(
                                        child: SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: Loading()
                                                .LOADING_ICON(context)))
                                ],
                              ));
                            }));
                          }),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}

class DetailArticleController extends GetxController {
  WebViewController? webViewController;
  final Completer<WebViewController> webController =
      Completer<WebViewController>();
  Future<void> onLoadHtml(String? html) async {
    await webViewController?.loadHtmlString(html!);
  }
}

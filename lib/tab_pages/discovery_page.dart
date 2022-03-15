import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/directory_res_model/item.dart';
import 'package:kalm/pages/detail_article.dart';
import 'package:kalm/widget/loading.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:kalm/widget/widget_carousel.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/image_cache.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DiscoveryPage extends StatelessWidget {
  final _controller = Get.put(DiscoveryController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DiscoveryController>(initState: (s) async {
      await PRO.getVideos();
      await PRO.getDirectoryArticles();
      await PRO.getDirectoryPlace();
      Loading.hide();
    }, builder: (_) {
      return SAFE_AREA(
          canBack: false,
          child: Builder(builder: (context) {
            return Scrollbar(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              BUTTON("Discovery",
                                  isExpanded: true,
                                  onPressed: () => _.onChangeTab(0),
                                  backgroundColor: _.selectedTab == 0
                                      ? ORANGEKALM
                                      : Colors.grey),
                              SPACE(),
                              BUTTON("Directory",
                                  isExpanded: true,
                                  onPressed: () => _.onChangeTab(1),
                                  backgroundColor: _.selectedTab == 1
                                      ? ORANGEKALM
                                      : Colors.grey),
                            ],
                          ),
                        ),
                        SPACE(height: 20),
                        if (_.selectedTab == 0) _discovery(_, context),
                        if (_.selectedTab == 1)
                          if (STATE(context).directoryResModel?.directoryData !=
                              null)
                            _directory(context)
                          else
                            Container()
                      ],
                    ),
                  ),
                ],
              ),
            );
          }));
    });
  }

  Column _discovery(DiscoveryController _, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TEXT("Video", style: Get.textTheme.headline2),
        ),
        SPACE(),
        VIDEO_CAROUSEL(context, _),
        SPACE(height: 20),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TEXT("Artikel", style: Get.textTheme.headline2),
                  IconButton(
                      onPressed: () => _.onChangeArticleView(),
                      icon: Icon(
                          (_.isArticleGrid
                              ? Icons.map_rounded
                              : Icons.grid_on_outlined),
                          color: ORANGEKALM))
                ],
              ),
            ),
            SPACE(),
          ],
        ),
        if (!_.isArticleGrid)
          ARTICLE_CAROUSEL(context, STATE(context).articleDirectoryResModel),
        if (_.isArticleGrid) _articleGridView(context),
      ],
    );
  }

  Padding _articleGridView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5),
        children: STATE(context).articleDirectoryResModel!.data!.map((e) {
          return IMAGE_CACHE(IMAGE_URL + ARTICLE + (e.file ?? ""),
              onTapImage: () {
            pushNewScreen(context, screen: DetailArticlePage(articleData: e));
          },
              widgetInsideImage: Positioned(
                  bottom: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 0.5)),
                      margin: const EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            height: 40,
                            width: Get.width / 3,
                            child: TEXT(e.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 10))),
                      ),
                    ),
                  )));
        }).toList(),
      ),
    );
  }

  Padding _directory(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: STATE(context).directoryResModel!.directoryData!.map((e) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SPACE(),
              TEXT(e.title, style: Get.textTheme.headline2),
              SPACE(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(e.dataItem!.length, (i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SPACE(),
                      TEXT(e.dataItem![i].title,
                          style: Get.textTheme.headline1),
                      Column(
                        children: e.dataItem![i].item!.map((f) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SPACE(),
                              Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(width: 0.5, color: BLUEKALM),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SPACE(),
                                      TEXT(f.name,
                                          style: Get.textTheme.bodyText2),
                                      SPACE(),
                                      if (f.address != "")
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons
                                                    .location_city_outlined),
                                                SPACE(width: 5),
                                                SizedBox(
                                                    width: Get.width / 1.3,
                                                    child: TEXT(f.address)),
                                              ],
                                            ),
                                            SPACE(),
                                          ],
                                        ),
                                      if (f.phone != "" && f.phone != null)
                                        _launchPhone1(f),
                                      if (f.phone2 != "" && f.phone2 != null)
                                        _launchPhone2(f),
                                      if (f.email != "" && f.email != null)
                                        _launchEmail(f),
                                      if (f.url != "" && f.url != null)
                                        _launchUrl(f),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      )
                    ],
                  );
                }),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  InkWell _launchUrl(Item f) {
    return InkWell(
        onTap: () async {
          try {
            if (f.url!.contains("https://")) {
              if (await canLaunch(f.url!)) {
                await launch(f.url!);
              } else {
                return;
              }
            } else {
              if (await canLaunch('https://${f.url!}')) {
                await launch("https://${f.url}");
              } else {
                return;
              }
            }
          } catch (e) {
            ERROR_SNACK_BAR("Perhatian", "Tidak dapat membuka link");
            return;
          }
        },
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.link),
                SPACE(width: 5),
                TEXT(f.url, style: URL_STYLE()),
              ],
            ),
            SPACE(height: 5),
          ],
        ));
  }

  InkWell _launchEmail(Item f) {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    return InkWell(
        onTap: () async {
          final Uri emailLaunchUri = Uri(
            scheme: 'mailto',
            path: f.email,
            query: encodeQueryParameters(
                <String, String>{'subject': 'Hello Kalm'}),
          );

          await launch(emailLaunchUri.toString());
        },
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.email_outlined),
                SPACE(width: 5),
                TEXT(f.email, style: URL_STYLE()),
              ],
            ),
            SPACE(height: 5),
          ],
        ));
  }

  InkWell _launchPhone1(Item f) {
    return InkWell(
        onTap: () async {
          final Uri launchUri = Uri(
            scheme: 'tel',
            path: f.phone,
          );
          await launch(launchUri.toString());
        },
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.phone_android_rounded),
                SPACE(width: 5),
                TEXT(f.phone, style: URL_STYLE()),
              ],
            ),
            SPACE(height: 5),
          ],
        ));
  }

  InkWell _launchPhone2(Item f) {
    return InkWell(
        onTap: () async {
          final Uri launchUri = Uri(
            scheme: 'tel',
            path: f.phone2,
          );
          await launch(launchUri.toString());
        },
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.phone_android_outlined),
                SPACE(width: 5),
                TEXT(f.phone2, style: URL_STYLE()),
              ],
            ),
            SPACE(height: 5),
          ],
        ));
  }
}

class DiscoveryController extends GetxController {
  ScrollController scrollController = ScrollController();
  bool isArticleGrid = false;
  void onChangeArticleView() {
    isArticleGrid = !isArticleGrid;
    update();
  }

  final Completer<WebViewController> webController =
      Completer<WebViewController>();
  int selectedTab = 0;
  void onChangeTab(int index) {
    selectedTab = index;
    update();
  }
}

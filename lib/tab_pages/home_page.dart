import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/pages/detail_article.dart';
import 'package:kalm/test.dart';
import 'package:kalm/widget/image_cache.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class HomePage extends StatelessWidget {
  final _controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(initState: (st) async {
      if (PRO.articleHomeResModel == null) {
        await PRO.getHomeArticles();
      }
      if (PRO.quoteResModel == null) {
        await PRO.getQuote();
      }
    }, builder: (_) {
      return SAFE_AREA(
        canBack: false,
        child: ListView(
          children: [
            Column(
              children: [
                SPACE(),
                TEXT(
                    "Selamat Datang! ${PRO.userData?.firstName} ${PRO.userData?.lastName}",
                    style: Get.textTheme.headline1),
                SPACE(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: IMAGE_CACHE(
                      IMAGE_URL +
                          INSPIRATIONAL_QUOTE +
                          (STATE(context).quoteResModel?.data?.image ?? ""),
                      widgetInsideImage: Positioned(
                          top: 10,
                          child: SizedBox(
                              width: Get.width / 1.1,
                              child: TEXT(STATE(context)
                                  .quoteResModel
                                  ?.data
                                  ?.description)))),
                ),
                SPACE(),
                InkWell(
                    onTap: () {
                      PRO.readLocalUser();
                    },
                    child: Image.asset("assets/image/ors_icon.png")),
                SPACE(),
                TEXT("Newest", style: Get.textTheme.headline1),
                SPACE(),
                _carousel(context),
              ],
            ),
          ],
        ),
      );
    });
  }

  CarouselSlider _carousel(BuildContext context) {
    return CarouselSlider(
        items: STATE(context).articleHomeResModel?.data?.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: IMAGE_CACHE(IMAGE_URL + ARTICLE + (e.file ?? ""),
                    onTapImage: () => pushNewScreen(context,
                        screen: DetailArticlePage(articleData: e)),
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
                                  width: Get.width / 1.12,
                                  child: TEXT(e.name,
                                      textAlign: TextAlign.center)),
                            ),
                          ),
                        ))),
              );
            }).toList() ??
            [],
        options: CarouselOptions(
          autoPlay: true,
          autoPlayCurve: Curves.easeIn,
          enableInfiniteScroll: false,
          viewportFraction: 0.99,
          enlargeCenterPage: true,
        ));
  }
}

class HomeController extends GetxController {}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/pages/ors.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/widget_carousel.dart';
import 'package:kalm/widget/box_border.dart';
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
                SizedBox(
                  width: Get.width / 1.5,
                  child: TEXT(
                      "Selamat Datang! ${PRO.userData?.firstName} ${PRO.userData?.lastName ?? ""}",
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headline1),
                ),
                SPACE(height: 20),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Builder(builder: (context) {
                      if (STATE(context).quoteResModel == null) {
                        return AspectRatio(
                            aspectRatio: 16 / 9, child: SHIMMER());
                      } else {
                        return BOX_BORDER(
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TEXT(STATE(context)
                                    .quoteResModel
                                    ?.data
                                    ?.description),
                              ),
                            ),
                            decorationImage: DecorationImage(
                                image: NetworkImage(IMAGE_URL +
                                    INSPIRATIONAL_QUOTE +
                                    (STATE(context)
                                        .quoteResModel!
                                        .data!
                                        .image!)),
                                fit: BoxFit.fill));
                      }
                    })),
                SPACE(),
                if (PRO.userData != null)
                  InkWell(
                      onTap: () async => await pushNewScreen(context,
                          screen: SAFE_AREA(child: OrsPage())),
                      child: Image.asset("assets/image/ors_icon.png")),
                SPACE(),
                TEXT("Newest", style: Get.textTheme.headline1),
                SPACE(),
                ARTICLE_CAROUSEL(context, STATE(context).articleHomeResModel),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class HomeController extends GetxController {}

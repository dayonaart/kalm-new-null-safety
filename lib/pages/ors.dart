import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/pages/auth/login.dart';
import 'package:kalm/widget/box_border.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/loading.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class OrsPage extends StatelessWidget {
  final _controller = Get.put(OrsController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrsController>(
        initState: (s) {
          PRO.getOrs();
        },
        dispose: (d) {},
        builder: (_) {
          return Builder(builder: (context) {
            if (PRO.orsResModel == null) {
              return Center(
                child: SizedBox(
                  child: Loading().LOADING_ICON(context),
                  height: 80,
                  width: 80,
                ),
              );
            } else {
              return _ors(_, context);
            }
          });
        });
  }

  SingleChildScrollView _ors(OrsController _, BuildContext context) {
    var _orsdata = PRO.orsResModel!;
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SPACE(),
                TEXT("How are you doing today?", style: Get.textTheme.headline2),
                TEXT("Rate each aspect of your life right now", style: Get.textTheme.bodyText1),
                const Divider(thickness: 2),
                SPACE(),
                Column(
                  key: _.containerKey,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(PRO.orsResModel!.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TEXT(_orsdata[i].title,
                                  style: COSTUM_TEXT_STYLE(
                                      fonstSize: (_orsdata[i].fontSize!.toDouble() + 8),
                                      color: BLUEKALM,
                                      fontWeight: FontWeight.bold)),
                              TEXT(_orsdata[i].content,
                                  style: COSTUM_TEXT_STYLE(
                                      fonstSize: _orsdata[i].fontSize!.toDouble(),
                                      fontStyle: FontStyle.italic)),
                            ],
                          ),
                          SPACE(),
                          orsBar(_, i),
                        ],
                      ),
                    );
                  }),
                ),
                SPACE(height: 20),
                SizedBox(
                    width: Get.width / 1.4,
                    child: BUTTON("Kirim", onPressed: () async {
                      await PRO.saveOrs(_.percentage);
                      if (PRO.userData != null) {
                        return;
                      } else {
                        await pushNewScreen(context, screen: LoginPage());
                      }
                    }, circularRadius: 20)),
                SPACE(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TEXT("Already have account? ", style: COSTUM_TEXT_STYLE(color: Colors.grey)),
                    InkWell(
                      onTap: () async => await pushNewScreen(context, screen: LoginPage()),
                      child: TEXT("Login",
                          style: COSTUM_TEXT_STYLE(color: ORANGEKALM, fontWeight: FontWeight.w500)),
                    ),
                  ],
                )
              ],
            )));
  }

  GestureDetector orsBar(OrsController _, int i) {
    return GestureDetector(
      onHorizontalDragStart: (d) => _.horizontalDragStart(d, i),
      onHorizontalDragUpdate: (d) => _.horizontalDragUpdate(d, i),
      child: BOX_BORDER(
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                Flexible(
                    child: AnimatedContainer(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20), color: _.barColor[i]),
                        duration: const Duration(milliseconds: 200),
                        width: _.dragHorizontal[i],
                        height: 30,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Image.asset('assets/emoticon/${_.emoji[i]}')))),
              ],
            ),
          ),
          circularRadius: 20),
    );
  }
}

class OrsController extends GetxController {
  GlobalKey containerKey = GlobalKey();
  List<double> dragHorizontal = List.generate(PRO.orsResModel!.length, (i) {
    return (0 / 100) * Get.width;
  });
  List<double> percentage = List.generate(PRO.orsResModel!.length, (i) {
    return 0;
  });
  List<String> emoji = List.generate(PRO.orsResModel!.length, (i) {
    return "6.png";
  });
  List<Color> barColor = List.generate(PRO.orsResModel!.length, (i) {
    return const Color(0xFF586B83);
  });
  void horizontalDragStart(DragStartDetails d, int i) {
    percentage[i] = (d.globalPosition.dx / Get.width) * 100;
    if (percentage[i] > 100) {
      return;
    } else if (percentage[i] <= 7.9) {
      return;
    }
    dragHorizontal[i] = d.globalPosition.dx;
    _updateOrs(i);
    update();
  }

  void horizontalDragUpdate(DragUpdateDetails d, int i) {
    percentage[i] = (d.globalPosition.dx / Get.width) * 100;
    if (percentage[i] > 100) {
      return;
    } else if (percentage[i] <= 7.9) {
      return;
    }
    dragHorizontal[i] = d.globalPosition.dx;
    _updateOrs(i);
    update();
  }

  double? get heightContainer => containerKey.currentContext?.size?.width;

  void _updateOrs(int i) {
    if (percentage[i] > 5 && percentage[i] <= 20) {
      emoji[i] = "1.png";
      barColor[i] = const Color(0xFF586B83);
    } else if (percentage[i] > 20 && percentage[i] <= 30) {
      emoji[i] = "3.png";
      barColor[i] = const Color(0xFF7091ba);
    } else if (percentage[i] > 30 && percentage[i] <= 40) {
      emoji[i] = "4.png";
      barColor[i] = const Color(0xFFB0BB90);
    } else if (percentage[i] > 40 && percentage[i] <= 50) {
      emoji[i] = "5.png";
      barColor[i] = const Color(0xFFcddba2);
    } else if (percentage[i] > 50 && percentage[i] <= 60) {
      emoji[i] = "6.png";
      barColor[i] = const Color(0xFFE6B363);
    } else if (percentage[i] > 60 && percentage[i] <= 70) {
      emoji[i] = "7.png";
      barColor[i] = const Color(0xFFffce80);
    } else if (percentage[i] > 70 && percentage[i] <= 80) {
      emoji[i] = "8.png";
      barColor[i] = const Color(0xFFf7d399);
    } else if (percentage[i] > 80 && percentage[i] <= 90) {
      emoji[i] = "9.png";
      barColor[i] = const Color(0xFFfaae9b);
    } else if (percentage[i] > 90 && percentage[i] <= 100) {
      emoji[i] = "10.png";
      barColor[i] = const Color(0xFFC88676);
    }
  }
}

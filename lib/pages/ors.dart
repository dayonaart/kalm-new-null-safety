import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/ors_payload/ors_payload.dart';
import 'package:kalm/model/ors_payload/ors_value.dart';
import 'package:kalm/model/ors_res_model/ors_res_model.dart';
import 'package:kalm/pages/auth/login.dart';
import 'package:kalm/pages/ors_history.dart';
import 'package:kalm/pages/ors_result.dart';
import 'package:kalm/widget/box_border.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/loading.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';

class OrsPage extends StatelessWidget {
  final _controller = Get.put(OrsController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrsController>(
        initState: (s) {},
        dispose: (d) {
          _controller.dragHorizontal =
              List.generate(PRO.orsResModel!.length, (i) {
            return (8 / 100) * Get.width;
          });
          _controller.percentage = List.generate(PRO.orsResModel!.length, (i) {
            return 0;
          });
          _controller.emoji = List.generate(PRO.orsResModel!.length, (i) {
            return "6.png";
          });
        },
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
              return Builder(builder: (context) {
                var _orsdata = PRO.orsResModel!;
                if (_.isTutorial && PRO.userData == null) {
                  return _tutorialOrs(_, _orsdata);
                } else {
                  return _ors(_, context, _orsdata);
                }
              });
            }
          });
        });
  }

  SingleChildScrollView _ors(
      OrsController _, BuildContext context, List<OrsResModel> _orsdata) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SPACE(),
                TEXT("How are you doing today?",
                    style: Get.textTheme.headline2),
                TEXT("Rate each aspect of your life right now",
                    style: Get.textTheme.bodyText1),
                const Divider(thickness: 2),
                SPACE(),
                _mainOrs(_orsdata, _),
                SPACE(height: 20),
                SizedBox(
                    width: Get.width / 1.4,
                    child: Column(
                      children: [
                        BUTTON("Kirim", onPressed: () async {
                          // print(_.percentage);
                          await PRO.saveOrs(_.percentage);
                          await _.submit(context);
                        }, circularRadius: 20),
                        if (PRO.userData != null)
                          BUTTON("ORS History", onPressed: () async {
                            await PRO.getOrs();
                            pushNewScreen(context, screen: OrsHistoryPage());
                          }, circularRadius: 20),
                      ],
                    )),
                SPACE(),
                if (PRO.userData == null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TEXT("Already have account? ",
                          style: COSTUM_TEXT_STYLE(color: Colors.grey)),
                      InkWell(
                        onTap: () async =>
                            await pushNewScreen(context, screen: LoginPage()),
                        child: TEXT("Login",
                            style: COSTUM_TEXT_STYLE(
                                color: ORANGEKALM,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  )
              ],
            )));
  }

  SingleChildScrollView _tutorialOrs(
    OrsController _,
    List<OrsResModel> _orsdata,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: List.generate(4, (i) {
            return AnimatedBuilder(
                animation: _.animation!,
                builder: (context, w) {
                  _.updateOrsTutorial((_.animation!.value * 100));
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SPACE(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TEXT(_orsdata[i].title,
                              style: COSTUM_TEXT_STYLE(
                                  fonstSize:
                                      (_orsdata[0].fontSize!.toDouble() + 8),
                                  color: BLUEKALM,
                                  fontWeight: FontWeight.bold)),
                          TEXT(_orsdata[i].content,
                              style: COSTUM_TEXT_STYLE(
                                  fonstSize: _orsdata[0].fontSize!.toDouble(),
                                  fontStyle: FontStyle.italic)),
                        ],
                      ),
                      SPACE(),
                      BOX_BORDER(
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: [
                                Flexible(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: _.barColorT),
                                        width: _tutorialAnimationWidth(_, i),
                                        height: 30,
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Image.asset(
                                                'assets/emoticon/${_.emojiT}')))),
                              ],
                            ),
                          ),
                          circularRadius: 20),
                    ],
                  );
                });
          }),
        ),
      ),
    );
  }

  double _tutorialAnimationWidth(OrsController _, int i) {
    if (i == 0) {
      return (_.animation!.value * 100) / 100 * (Get.width);
    } else {
      return (_.animation!.value * (100 - (i * 15))) / 100 * (Get.width);
    }
  }

  Column _mainOrs(List<OrsResModel> _orsdata, OrsController _) {
    return Column(
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
    );
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
                            borderRadius: BorderRadius.circular(20),
                            color: _.barColor[i]),
                        duration: const Duration(milliseconds: 200),
                        width: _.dragHorizontal[i],
                        height: 30,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child:
                                Image.asset('assets/emoticon/${_.emoji[i]}')))),
              ],
            ),
          ),
          circularRadius: 20),
    );
  }
}

class OrsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  List<double> dragHorizontal = List.generate(PRO.orsResModel!.length, (i) {
    return (8 / 100) * Get.width;
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

  String emojiT = "1.png";
  Color barColorT = const Color(0xFF586B83);

  void updateOrsTutorial(double onMove) {
    _updateOrsTutorial(onMove);
  }

  void _updateOrsTutorial(double percentage) {
    if (percentage > 5 && percentage <= 20) {
      emojiT = "1.png";
      barColorT = const Color(0xFF586B83);
    } else if (percentage > 20 && percentage <= 30) {
      emojiT = "3.png";
      barColorT = const Color(0xFF7091ba);
    } else if (percentage > 30 && percentage <= 40) {
      emojiT = "4.png";
      barColorT = const Color(0xFFB0BB90);
    } else if (percentage > 40 && percentage <= 50) {
      emojiT = "5.png";
      barColorT = const Color(0xFFcddba2);
    } else if (percentage > 50 && percentage <= 60) {
      emojiT = "6.png";
      barColorT = const Color(0xFFE6B363);
    } else if (percentage > 60 && percentage <= 70) {
      emojiT = "7.png";
      barColorT = const Color(0xFFffce80);
    } else if (percentage > 70 && percentage <= 80) {
      emojiT = "8.png";
      barColorT = const Color(0xFFf7d399);
    } else if (percentage > 80 && percentage <= 90) {
      emojiT = "9.png";
      barColorT = const Color(0xFFfaae9b);
    } else if (percentage > 90 && percentage <= 100) {
      emojiT = "10.png";
      barColorT = const Color(0xFFC88676);
    }
  }

  OrsPayload get payload => OrsPayload(
      userCode: PRO.userData?.code,
      date: DateTime.now().toIso8601String(),
      value: OrsValue(
          first: percentage[0].toInt(),
          second: percentage[1].toInt(),
          third: percentage[2].toInt(),
          four: percentage[3].toInt()));

  Future<void> submit(BuildContext context) async {
    var _sumVal = payload.value
        ?.toJson()
        .values
        .toList()
        .fold<int>(0, (p, e) => p + (e as int));
    var _result = (_sumVal! / 5) / 2 ~/ 10;
    if (PRO.userData == null) {
      Get.offAll(OrsResultPage(result: _result));
      return;
    }
    var _res = await Api().POST(STORE_ORS, payload.toJson(), useToken: true);
    if (_res?.statusCode == 200) {
      Loading.hide();
      pushNewScreen(context, screen: OrsResultPage(result: _result));
    } else {
      Loading.hide();
      return;
    }
  }

  Animation<double>? animation;
  AnimationController? _animationController;
  bool isTutorial = true;
  void stopTutorial() {
    isTutorial = false;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _animationController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation =
        CurvedAnimation(parent: _animationController!, curve: Curves.linear)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController?.stop();
              stopTutorial();
            } else if (status == AnimationStatus.dismissed) {
              _animationController?.stop();
            }
          });
    _animationController!.forward();
  }

  @override
  void onClose() {
    _animationController?.dispose();
    super.onClose();
  }
}

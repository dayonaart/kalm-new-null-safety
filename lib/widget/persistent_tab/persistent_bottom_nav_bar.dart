import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kalm/widget/persistent_tab/bottom_nav_styles.dart';
import 'package:kalm/widget/persistent_tab/nav_bar_essential_model.dart';
import 'package:kalm/widget/persistent_tab/nav_style.dart';
import 'package:kalm/widget/persistent_tab/neumorphic_property.dart';
import 'package:kalm/widget/persistent_tab/persitent_nav_item.dart';
import 'package:kalm/widget/persistent_tab/screen_transistion_animation.dart';

class PersistentBottomNavBar extends StatelessWidget {
  const PersistentBottomNavBar({
    Key? key,
    this.margin,
    this.confineToSafeArea,
    this.customNavBarWidget,
    this.hideNavigationBar,
    this.onAnimationComplete,
    this.neumorphicProperties = const NeumorphicProperties(),
    this.navBarEssentials,
    this.navBarDecoration,
    this.navBarStyle,
    this.isCustomWidget = false,
  }) : super(key: key);

  final NavBarEssentials? navBarEssentials;
  final EdgeInsets? margin;
  final NavBarDecoration? navBarDecoration;
  final NavBarStyle? navBarStyle;
  final NeumorphicProperties? neumorphicProperties;
  final Widget? customNavBarWidget;
  final bool? confineToSafeArea;
  final bool? hideNavigationBar;
  final Function(bool, bool)? onAnimationComplete;
  final bool? isCustomWidget;

  Widget _navBarWidget() => Padding(
        padding: margin!,
        child: isCustomWidget!
            ? customNavBarWidget
            : navBarStyle == NavBarStyle.style15 ||
                    navBarStyle == NavBarStyle.style16
                ? margin!.bottom > 0
                    ? SafeArea(
                        top: false,
                        right: false,
                        left: false,
                        bottom: navBarEssentials!.navBarHeight == 0.0 ||
                                (hideNavigationBar ?? false)
                            ? false
                            : confineToSafeArea ?? true,
                        child: Container(
                          decoration: getNavBarDecoration(
                            decoration: navBarDecoration,
                            color: navBarEssentials!.backgroundColor,
                            opacity: navBarEssentials!
                                .items![navBarEssentials!.selectedIndex!]
                                .opacity,
                          ),
                          child: getNavBarStyle(),
                        ),
                      )
                    : Container(
                        color: Colors.transparent,
                        decoration: getNavBarDecoration(
                          decoration: navBarDecoration,
                          color: navBarEssentials!.backgroundColor,
                          opacity: navBarEssentials!
                              .items![navBarEssentials!.selectedIndex!].opacity,
                        ),
                        child: getNavBarStyle()!,
                      )
                : Container(
                    color: Colors.transparent,
                    decoration: getNavBarDecoration(
                      decoration: navBarDecoration,
                      showBorder: false,
                      color: navBarEssentials!.backgroundColor,
                      opacity: navBarEssentials!
                          .items![navBarEssentials!.selectedIndex!].opacity,
                    ),
                    child: ClipRRect(
                      borderRadius:
                          navBarDecoration!.borderRadius ?? BorderRadius.zero,
                      child: BackdropFilter(
                        filter: navBarEssentials!
                                .items![navBarEssentials!.selectedIndex!]
                                .filter ??
                            ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                        child: Container(
                          color: Colors.transparent,
                          decoration: getNavBarDecoration(
                            showOpacity: false,
                            decoration: navBarDecoration,
                            color: navBarEssentials!.backgroundColor,
                            opacity: navBarEssentials!
                                .items![navBarEssentials!.selectedIndex!]
                                .opacity,
                          ),
                          child: SafeArea(
                            top: false,
                            right: false,
                            left: false,
                            bottom: navBarEssentials!.navBarHeight == 0.0 ||
                                    (hideNavigationBar ?? false)
                                ? false
                                : confineToSafeArea ?? true,
                            child: getNavBarStyle()!,
                          ),
                        ),
                      ),
                    ),
                  ),
      );

  @override
  Widget build(BuildContext context) {
    return hideNavigationBar == null
        ? _navBarWidget()
        : OffsetAnimation(
            hideNavigationBar: hideNavigationBar,
            navBarHeight: navBarEssentials!.navBarHeight,
            onAnimationComplete: (isAnimating, isComplete) {
              onAnimationComplete!(isAnimating, isComplete);
            },
            child: _navBarWidget(),
          );
  }

  PersistentBottomNavBar copyWith(
      {int? selectedIndex,
      double? iconSize,
      int? previousIndex,
      Color? backgroundColor,
      Duration? animationDuration,
      List<PersistentBottomNavBarItem>? items,
      ValueChanged<int>? onItemSelected,
      double? navBarHeight,
      EdgeInsets? margin,
      NavBarStyle? navBarStyle,
      double? horizontalPadding,
      NeumorphicProperties? neumorphicProperties,
      Widget? customNavBarWidget,
      Function(int)? popAllScreensForTheSelectedTab,
      bool? popScreensOnTapOfSelectedTab,
      NavBarDecoration? navBarDecoration,
      NavBarEssentials? navBarEssentials,
      bool? confineToSafeArea,
      ItemAnimationProperties? itemAnimationProperties,
      Function? onAnimationComplete,
      bool? hideNavigationBar,
      bool? isCustomWidget,
      EdgeInsets? padding}) {
    return PersistentBottomNavBar(
        confineToSafeArea: confineToSafeArea ?? this.confineToSafeArea,
        margin: margin ?? this.margin,
        neumorphicProperties: neumorphicProperties ?? this.neumorphicProperties,
        navBarStyle: navBarStyle ?? this.navBarStyle,
        hideNavigationBar: hideNavigationBar ?? this.hideNavigationBar,
        customNavBarWidget: customNavBarWidget ?? this.customNavBarWidget,
        onAnimationComplete:
            onAnimationComplete as dynamic Function(bool, bool)? ??
                this.onAnimationComplete,
        navBarEssentials: navBarEssentials ?? this.navBarEssentials,
        isCustomWidget: isCustomWidget ?? this.isCustomWidget,
        navBarDecoration: navBarDecoration ?? this.navBarDecoration);
  }

  bool opaque(int? index) {
    return navBarEssentials!.items == null
        ? true
        : !(navBarEssentials!.items![index!].opacity < 1.0);
  }

  Widget? getNavBarStyle() {
    if (isCustomWidget!) {
      return customNavBarWidget;
    } else {
      switch (navBarStyle) {
        case NavBarStyle.style1:
          return BottomNavStyle1(
            navBarEssentials: navBarEssentials,
          );
        case NavBarStyle.style2:
          return BottomNavStyle2(
            navBarEssentials: navBarEssentials,
          );
        case NavBarStyle.style3:
          return BottomNavStyle3(
            navBarEssentials: navBarEssentials,
          );
        // case NavBarStyle.style4:
        //   return BottomNavStyle4(
        //     navBarEssentials: this.navBarEssentials,
        //   );
        // case NavBarStyle.style5:
        //   return BottomNavStyle5(
        //     navBarEssentials: this.navBarEssentials,
        //   );
        // case NavBarStyle.style6:
        //   return BottomNavStyle6(
        //     navBarEssentials: this.navBarEssentials,
        //   );
        // case NavBarStyle.style7:
        //   return BottomNavStyle7(
        //     navBarEssentials: this.navBarEssentials,
        //   );
        // case NavBarStyle.style8:
        //   return BottomNavStyle8(
        //     navBarEssentials: this.navBarEssentials,
        //   );
        // case NavBarStyle.style9:
        //   return BottomNavStyle9(
        //     navBarEssentials: this.navBarEssentials,
        //   );
        // case NavBarStyle.style10:
        //   return BottomNavStyle10(
        //     navBarEssentials: this.navBarEssentials,
        //   );
        // case NavBarStyle.style11:
        //   return BottomNavStyle11(
        //     navBarEssentials: this.navBarEssentials,
        //   );
        // case NavBarStyle.style12:
        //   return BottomNavStyle12(
        //     navBarEssentials: this.navBarEssentials,
        //   );
        // case NavBarStyle.style13:
        //   return BottomNavStyle13(
        //     navBarEssentials: this.navBarEssentials,
        //   );
        // case NavBarStyle.style14:
        //   return BottomNavStyle14(
        //     navBarEssentials: this.navBarEssentials,
        //   );
        // case NavBarStyle.style15:
        //   return BottomNavStyle15(
        //     navBarEssentials: this.navBarEssentials,
        //     navBarDecoration: this.navBarDecoration,
        //   );
        // case NavBarStyle.style16:
        //   return BottomNavStyle16(
        //     navBarEssentials: this.navBarEssentials,
        //     navBarDecoration: this.navBarDecoration,
        //   );
        // case NavBarStyle.style17:
        //   return BottomNavStyle17(
        //     navBarEssentials: this.navBarEssentials,
        //     navBarDecoration: this.navBarDecoration,
        //   );
        // case NavBarStyle.style18:
        //   return BottomNavStyle18(
        //     navBarEssentials: this.navBarEssentials,
        //     navBarDecoration: this.navBarDecoration,
        //   );
        // case NavBarStyle.neumorphic:
        //   return NeumorphicBottomNavBar(
        //     navBarEssentials: this.navBarEssentials,
        //     neumorphicProperties: this.neumorphicProperties,
        //   );
        default:
          return BottomNavStyle3(
            navBarEssentials: navBarEssentials,
          );
      }
    }
  }
}

BoxDecoration getNavBarDecoration({
  bool showElevation = true,
  NavBarDecoration? decoration = const NavBarDecoration(),
  required double opacity,
  bool showBorder = true,
  bool showOpacity = true,
  Color? color = Colors.white,
}) {
  if (opacity < 1.0) {
    return BoxDecoration(
      border: showBorder ? decoration!.border : null,
      borderRadius: decoration!.borderRadius,
      color: color!.withOpacity(opacity),
    );
  } else {
    return BoxDecoration(
      border: showBorder ? decoration!.border : null,
      borderRadius: decoration!.borderRadius,
      color: color,
      gradient: decoration.gradient,
      boxShadow: decoration.boxShadow,
    );
  }
}

bool isColorOpaque(BuildContext context, Color? color) {
  final Color backgroundColor =
      color ?? CupertinoTheme.of(context).barBackgroundColor;
  return CupertinoDynamicColor.resolve(backgroundColor, context).alpha == 0xFF;
}

bool opaque(List<PersistentBottomNavBarItem> items, int? selectedIndex) {
  for (int i = 0; i < items.length; ++i) {
    if (items[i].opacity < 1.0 && i == selectedIndex) {
      return false;
    }
  }
  return true;
}

double getTranslucencyAmount(
    List<PersistentBottomNavBarItem> items, int? selectedIndex) {
  for (int i = 0; i < items.length; ++i) {
    if (items[i].opacity < 1.0 && i == selectedIndex) {
      return items[i].opacity;
    }
  }
  return 1.0;
}

Color getBackgroundColor(BuildContext context,
    List<PersistentBottomNavBarItem>? items, Color? color, int? selectedIndex) {
  if (color == null) {
    return Colors.white;
  } else if (!opaque(items!, selectedIndex) && isColorOpaque(context, color)) {
    return color.withOpacity(getTranslucencyAmount(items, selectedIndex));
  } else {
    return color;
  }
}

class OffsetAnimation extends StatefulWidget {
  OffsetAnimation(
      {Key? key,
      this.child,
      this.hideNavigationBar,
      this.navBarHeight,
      this.onAnimationComplete,
      this.extendedLength = false})
      : super(key: key);
  final Widget? child;
  final bool? hideNavigationBar;
  final double? navBarHeight;
  final bool extendedLength;
  final Function(bool, bool)? onAnimationComplete;

  @override
  _OffsetAnimationState createState() => _OffsetAnimationState();
}

class _OffsetAnimationState extends State<OffsetAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _navBarHideAnimationController;
  late Animation<Offset> _navBarOffsetAnimation;
  bool? _hideNavigationBar;

  @override
  void initState() {
    super.initState();
    _hideNavigationBar = widget.hideNavigationBar;

    _navBarHideAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _navBarOffsetAnimation = Tween<Offset>(
            begin: Offset(0, 0), end: Offset(0, widget.navBarHeight! + 22.0))
        .chain(CurveTween(curve: Curves.ease))
        .animate(_navBarHideAnimationController);

    _hideAnimation();

    _navBarHideAnimationController.addListener(() {
      widget.onAnimationComplete!(_navBarHideAnimationController.isAnimating,
          _navBarHideAnimationController.isCompleted);
    });
  }

  @override
  void dispose() {
    _navBarHideAnimationController.dispose();
    super.dispose();
  }

  _hideAnimation() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_hideNavigationBar!) {
        _navBarHideAnimationController.forward();
      } else {
        _navBarHideAnimationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hideNavigationBar != null ||
        _hideNavigationBar != widget.hideNavigationBar) {
      _hideNavigationBar = widget.hideNavigationBar;
      _hideAnimation();
    }
    return AnimatedBuilder(
      animation: _navBarOffsetAnimation,
      child: widget.child,
      builder: (context, child) => Transform.translate(
        offset: _navBarOffsetAnimation.value,
        child: child,
      ),
    );
  }
}

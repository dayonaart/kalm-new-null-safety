import 'package:flutter/material.dart';
import 'package:kalm/widget/persistent_tab/nav_bar_essential_model.dart';
import 'package:kalm/widget/persistent_tab/persitent_nav_item.dart';

class BottomNavStyle1 extends StatelessWidget {
  final NavBarEssentials? navBarEssentials;

  BottomNavStyle1({
    Key? key,
    this.navBarEssentials = const NavBarEssentials(items: null),
  });

  Widget _buildItem(
      PersistentBottomNavBarItem item, bool isSelected, double? height) {
    if (navBarEssentials!.navBarHeight == 0) {
      return const SizedBox.shrink();
    } else {
      return AnimatedContainer(
        width: isSelected ? 120 : 50,
        height: height! / 1.6,
        duration: navBarEssentials!.itemAnimationProperties?.duration ??
            const Duration(milliseconds: 400),
        curve: navBarEssentials!.itemAnimationProperties?.curve ?? Curves.ease,
        padding: EdgeInsets.all(item.contentPadding),
        decoration: BoxDecoration(
          color: isSelected
              ? item.activeColorPrimary.withOpacity(0.2)
              : navBarEssentials!.backgroundColor!.withOpacity(0.0),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        child: Container(
          alignment: Alignment.center,
          height: height / 1.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: item.title == null ? 0.0 : 8),
                  child: IconTheme(
                    data: IconThemeData(
                        size: item.iconSize,
                        color: isSelected
                            ? (item.activeColorSecondary ??
                                item.activeColorPrimary)
                            : item.inactiveColorPrimary ??
                                item.activeColorPrimary),
                    child:
                        isSelected ? item.icon : item.inactiveIcon ?? item.icon,
                  ),
                ),
              ),
              item.title == null
                  ? const SizedBox.shrink()
                  : isSelected
                      ? Flexible(
                          child: Material(
                            type: MaterialType.transparency,
                            child: FittedBox(
                                child: Text(
                              item.title!,
                              style: item.textStyle != null
                                  ? (item.textStyle!.apply(
                                      color: isSelected
                                          ? (item.activeColorSecondary ??
                                              item.activeColorPrimary)
                                          : item.inactiveColorPrimary))
                                  : TextStyle(
                                      color: (item.activeColorSecondary ??
                                          item.activeColorPrimary),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0),
                            )),
                          ),
                        )
                      : const SizedBox.shrink()
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: this.navBarEssentials!.navBarHeight,
        padding: this.navBarEssentials!.padding == null
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.07,
                vertical: this.navBarEssentials!.navBarHeight! * 0.15,
              )
            : EdgeInsets.only(
                top: this.navBarEssentials!.padding?.top ??
                    this.navBarEssentials!.navBarHeight! * 0.15,
                left: this.navBarEssentials!.padding?.left ??
                    MediaQuery.of(context).size.width * 0.07,
                right: this.navBarEssentials!.padding?.right ??
                    MediaQuery.of(context).size.width * 0.07,
                bottom: this.navBarEssentials!.padding?.bottom ??
                    this.navBarEssentials!.navBarHeight! * 0.15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: this.navBarEssentials!.items!.map((item) {
            int index = this.navBarEssentials!.items!.indexOf(item);
            return Flexible(
              flex: this.navBarEssentials!.selectedIndex == index ? 2 : 1,
              child: GestureDetector(
                onTap: () {
                  if (this.navBarEssentials!.items![index].onPressed != null) {
                    this.navBarEssentials!.items![index].onPressed!(
                        this.navBarEssentials!.selectedScreenBuildContext);
                  } else {
                    this.navBarEssentials!.onItemSelected!(index);
                  }
                },
                child: _buildItem(
                    item,
                    this.navBarEssentials!.selectedIndex == index,
                    this.navBarEssentials!.navBarHeight),
              ),
            );
          }).toList(),
        ));
  }
}

class BottomNavStyle2 extends StatelessWidget {
  final NavBarEssentials? navBarEssentials;

  BottomNavStyle2({
    Key? key,
    this.navBarEssentials = const NavBarEssentials(items: null),
  });

  Widget _buildItem(
      PersistentBottomNavBarItem item, bool isSelected, double? height) {
    return this.navBarEssentials!.navBarHeight == 0
        ? SizedBox.shrink()
        : Container(
            width: 150.0,
            height: height! / 1,
            child: Container(
              alignment: Alignment.center,
              height: height / 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: IconTheme(
                      data: IconThemeData(
                          size: item.iconSize,
                          color: isSelected
                              ? (item.activeColorSecondary == null
                                  ? item.activeColorPrimary
                                  : item.activeColorSecondary)
                              : item.inactiveColorPrimary == null
                                  ? item.activeColorPrimary
                                  : item.inactiveColorPrimary),
                      child: isSelected
                          ? item.icon
                          : item.inactiveIcon ?? item.icon,
                    ),
                  ),
                  item.title == null
                      ? SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Material(
                            type: MaterialType.transparency,
                            child: FittedBox(
                                child: Text(
                              isSelected ? item.title! : " ",
                              style: item.textStyle != null
                                  ? (item.textStyle!.apply(
                                      color: isSelected
                                          ? (item.activeColorSecondary == null
                                              ? item.activeColorPrimary
                                              : item.activeColorSecondary)
                                          : item.inactiveColorPrimary))
                                  : TextStyle(
                                      color: (item.activeColorSecondary == null
                                          ? item.activeColorPrimary
                                          : item.activeColorSecondary),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0),
                            )),
                          ),
                        )
                ],
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: this.navBarEssentials!.navBarHeight,
      padding: EdgeInsets.only(
          left: this.navBarEssentials!.padding?.left ??
              MediaQuery.of(context).size.width * 0.05,
          right: this.navBarEssentials!.padding?.right ??
              MediaQuery.of(context).size.width * 0.05,
          top: this.navBarEssentials!.padding?.top ??
              this.navBarEssentials!.navBarHeight! * 0.15,
          bottom: this.navBarEssentials!.padding?.bottom ??
              this.navBarEssentials!.navBarHeight! * 0.12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: this.navBarEssentials!.items!.map((item) {
          int index = this.navBarEssentials!.items!.indexOf(item);
          return Flexible(
            child: GestureDetector(
              onTap: () {
                if (this.navBarEssentials!.items![index].onPressed != null) {
                  this.navBarEssentials!.items![index].onPressed!(
                      this.navBarEssentials!.selectedScreenBuildContext);
                } else {
                  this.navBarEssentials!.onItemSelected!(index);
                }
              },
              child: Container(
                color: Colors.transparent,
                child: _buildItem(
                    item,
                    this.navBarEssentials!.selectedIndex == index,
                    this.navBarEssentials!.navBarHeight),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class BottomNavStyle3 extends StatelessWidget {
  final NavBarEssentials? navBarEssentials;

  BottomNavStyle3({
    Key? key,
    this.navBarEssentials = const NavBarEssentials(items: null),
  });

  Widget _buildItem(
      PersistentBottomNavBarItem item, bool isSelected, double? height) {
    return this.navBarEssentials!.navBarHeight == 0
        ? SizedBox.shrink()
        : AnimatedContainer(
            width: 100.0,
            height: height! / 1.0,
            duration:
                this.navBarEssentials!.itemAnimationProperties?.duration ??
                    Duration(milliseconds: 1000),
            curve: this.navBarEssentials!.itemAnimationProperties?.curve ??
                Curves.ease,
            alignment: Alignment.center,
            child: AnimatedContainer(
              duration:
                  this.navBarEssentials!.itemAnimationProperties?.duration ??
                      Duration(milliseconds: 1000),
              curve: this.navBarEssentials!.itemAnimationProperties?.curve ??
                  Curves.ease,
              alignment: Alignment.center,
              height: height / 1.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: IconTheme(
                      data: IconThemeData(
                          size: item.iconSize,
                          color: isSelected
                              ? (item.activeColorSecondary == null
                                  ? item.activeColorPrimary
                                  : item.activeColorSecondary)
                              : item.inactiveColorPrimary == null
                                  ? item.activeColorPrimary
                                  : item.inactiveColorPrimary),
                      child: isSelected
                          ? item.icon
                          : item.inactiveIcon ?? item.icon,
                    ),
                  ),
                  item.title == null
                      ? SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Material(
                            type: MaterialType.transparency,
                            child: DefaultTextStyle.merge(
                              style: TextStyle(
                                  color: item.textStyle != null
                                      ? item.textStyle!.apply(
                                              color: isSelected
                                                  ? (item.activeColorSecondary ==
                                                          null
                                                      ? item.activeColorPrimary
                                                      : item.activeColorSecondary)
                                                  : item.inactiveColorPrimary)
                                          as Color?
                                      : isSelected
                                          ? (item.activeColorSecondary == null
                                              ? item.activeColorPrimary
                                              : item.activeColorSecondary)
                                          : item.inactiveColorPrimary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.0),
                              child: FittedBox(child: Text(item.title!)),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    Color selectedItemActiveColor = this
        .navBarEssentials!
        .items![this.navBarEssentials!.selectedIndex!]
        .activeColorPrimary;
    double itemWidth = ((MediaQuery.of(context).size.width -
            ((this.navBarEssentials!.padding?.left ??
                    MediaQuery.of(context).size.width * 0.05) +
                (this.navBarEssentials!.padding?.right ??
                    MediaQuery.of(context).size.width * 0.05))) /
        this.navBarEssentials!.items!.length);
    return Container(
      width: double.infinity,
      height: this.navBarEssentials!.navBarHeight,
      padding: EdgeInsets.only(
          top: this.navBarEssentials!.padding?.top ?? 0.0,
          left: this.navBarEssentials!.padding?.left ??
              MediaQuery.of(context).size.width * 0.05,
          right: this.navBarEssentials!.padding?.right ??
              MediaQuery.of(context).size.width * 0.05,
          bottom: this.navBarEssentials!.padding?.bottom ??
              this.navBarEssentials!.navBarHeight! * 0.1),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              AnimatedContainer(
                duration:
                    this.navBarEssentials!.itemAnimationProperties?.duration ??
                        Duration(milliseconds: 300),
                curve: this.navBarEssentials!.itemAnimationProperties?.curve ??
                    Curves.ease,
                color: Colors.transparent,
                width: this.navBarEssentials!.selectedIndex == 0
                    ? MediaQuery.of(context).size.width * 0.0
                    : itemWidth * this.navBarEssentials!.selectedIndex!,
                height: 4.0,
              ),
              Flexible(
                child: AnimatedContainer(
                  duration: this
                          .navBarEssentials!
                          .itemAnimationProperties
                          ?.duration ??
                      Duration(milliseconds: 300),
                  curve:
                      this.navBarEssentials!.itemAnimationProperties?.curve ??
                          Curves.ease,
                  width: itemWidth,
                  height: 4.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedItemActiveColor,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: this.navBarEssentials!.items!.map((item) {
                  int index = this.navBarEssentials!.items!.indexOf(item);
                  return Flexible(
                    child: GestureDetector(
                      onTap: () {
                        if (this.navBarEssentials!.items![index].onPressed !=
                            null) {
                          this.navBarEssentials!.items![index].onPressed!(this
                              .navBarEssentials!
                              .selectedScreenBuildContext);
                        } else {
                          this.navBarEssentials!.onItemSelected!(index);
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: _buildItem(
                            item,
                            this.navBarEssentials!.selectedIndex == index,
                            this.navBarEssentials!.navBarHeight),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/widget/text.dart';

class VirtualNumpad extends StatefulWidget {
  Color? bgColor;
  Color? textColor;
  final ValueChanged<String>? seletedNum;
  final ValueChanged<String>? doneSelected;
  final List? complete;
  final bool? isEdit;
  void Function()? onTapSetting;
  VirtualNumpad(
      {Key? key,
      this.bgColor,
      this.isEdit = false,
      this.textColor,
      @required this.seletedNum,
      this.doneSelected,
      this.onTapSetting,
      this.complete})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VirtualNumpadScreen();
  }
}

class VirtualNumpadScreen extends State<VirtualNumpad> {
  String previousText = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return numberPadWidget();
  }

  Container numberPadWidget() {
    return Container(
        decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0), topRight: Radius.circular(0))),
        child: GridView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.5,
            crossAxisSpacing: 20,
          ),
          children: [
            _numberButton(text: "1"),
            _numberButton(text: "2"),
            _numberButton(text: "3"),
            _numberButton(text: "4"),
            _numberButton(text: "5"),
            _numberButton(text: "6"),
            _numberButton(text: "7"),
            _numberButton(text: "8"),
            _numberButton(text: "9"),
            widget.isEdit! ? _iconButton(icon: Icons.settings) : Container(),
            _numberButton(text: "0"),
            _icon(Icons.backspace, true),
          ],
        ));
  }

  Widget _numberButton({String? text}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          previousText = previousText + text!;
          if (previousText.length > 4) {
            previousText = previousText.substring(0, 4);
          }
          widget.seletedNum!(previousText);
        },
        child: Container(
          alignment: Alignment.center,
          child: TEXT(text,
              style: COSTUM_TEXT_STYLE(
                  color: widget.textColor,
                  fonstSize: 35,
                  fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  Widget _iconButton({IconData? icon}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTapSetting,
        child: Container(
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _icon(IconData icon, bool isBackSpace) {
    return IconButton(
        icon: const Icon(Icons.backspace, color: Colors.grey),
        onPressed: () {
          if (isBackSpace) {
            // BackSpace
            if (previousText.isNotEmpty) {
              var removedText =
                  previousText.substring(0, previousText.length - 1);
              previousText = removedText;
              widget.seletedNum!(removedText);
            } else {
              widget.seletedNum!("");
            }
          } else {
            // Done
            widget.doneSelected!("Done Selected");
          }
        });
  }
}

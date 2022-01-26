import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalm/api/api.dart';
import 'package:kalm/color/colors.dart';
import 'package:kalm/controller/user_controller.dart';
import 'package:kalm/model/item_chat_model.dart';
import 'package:kalm/pages/setting_page/client_detail.dart';
import 'package:kalm/utilities/date_format.dart';
import 'package:kalm/widget/button.dart';
import 'package:kalm/widget/image_cache.dart';
import 'package:kalm/widget/persistent_tab/persistent_tab_util.dart';
import 'package:kalm/widget/safe_area.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:kalm/widget/space.dart';
import 'package:kalm/widget/text.dart';
import 'package:selectable_autolink_text/selectable_autolink_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatRoomPage extends StatelessWidget {
  final _controller = Get.put(ChatRoomPageController());
  late StreamSubscription<DatabaseEvent> _messagesSubscription;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatRoomPageController>(initState: (st) {
      _controller.dateFilter();
      final messagesQuery = PRO.chatRef.limitToLast(1);
      _messagesSubscription = messagesQuery.onChildAdded.listen(
        (DatabaseEvent event) {
          // print('Child added: ${event.snapshot.value}');
        },
        onError: (Object o) {
          final error = o as FirebaseException;
          // print('Error: ${error.code} ${error.message}');
        },
      );
    }, builder: (_) {
      return NON_MAIN_SAFE_AREA(
        top: true,
        minimumInset: 55,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async => await pushNewScreen(context, screen: ClientDetailPage()),
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: BLUEKALM,
                        radius: 30,
                        child: Builder(builder: (context) {
                          return IMAGE_CACHE(
                            "$IMAGE_URL/users/${PRO.counselorData?.counselor?.photo}",
                            width: 55,
                            height: 55,
                            circularRadius: 55,
                          );
                        })),
                    SPACE(),
                    TEXT(
                        "${PRO.counselorData?.counselor?.firstName} ${PRO.counselorData?.counselor?.lastName}"),
                  ],
                ),
              )),
            ),
            Flexible(
              child: InkWell(
                onTap: () {
                  _.focusNode.unfocus();
                },
                child: _firebaseAnimatedList(_),
              ),
            ),
            Expanded(
              flex: -1,
              child: CupertinoTextField(
                  placeholder: "Tulis pesanmu disini...",
                  suffix: _.sending
                      ? const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: CupertinoActivityIndicator(),
                        )
                      : IconButton(
                          onPressed: _.sending ? null : () async => await _.sendMessage(),
                          icon: const Icon(
                            Icons.send_rounded,
                            color: ORANGEKALM,
                          )),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  focusNode: _.focusNode,
                  controller: _.messageController,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  textAlignVertical: TextAlignVertical.top,
                  style: COSTUM_TEXT_STYLE(fonstSize: 20),
                  decoration: BoxDecoration(border: Border.all(width: 0.5, color: BLUEKALM))),
            ),
          ],
        ),
      );
    });
  }

  FirebaseAnimatedList _firebaseAnimatedList(ChatRoomPageController _) {
    return FirebaseAnimatedList(
        key: ValueKey<bool>(_.laodMore),
        physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
        controller: _.scrollController,
        duration: const Duration(seconds: 1),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        query: PRO.chatRef.limitToLast(_.limit),
        itemBuilder: (context, snap, anim, i) {
          ItemChatModel? _chat = _chatModel(snap);
          bool _isUser = PRO.userData?.code == _chat?.code;
          int? _showDate = _filterDate(_, _chat);
          if (_chat != null) {
            return _chatView(_showDate, i, _, _isUser, _chat);
          } else {
            return Container();
          }
        });
  }

  CupertinoScrollbar _chatView(
      int? _showDate, int i, ChatRoomPageController _, bool _isUser, ItemChatModel _chat) {
    return CupertinoScrollbar(
      controller: _.scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            if (i == 0 && _.limit <= _.date!.length)
              Column(
                children: [
                  OUTLINE_BUTTON("Load more", onPressed: () async {
                    _.updateLimit();
                  }, useExpanded: false),
                  if (_showDate != i) SPACE(),
                ],
              ),
            if (_showDate == i)
              Column(
                children: [
                  const Divider(thickness: 1),
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TEXT("${DATE_FORMAT(_.date![i])}"),
                  )),
                  SPACE(),
                ],
              ),
            Align(
                alignment: _itemAligment(_isUser),
                child: Column(
                  crossAxisAlignment: _itemCrossAligment(_isUser),
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: _itemBackgroudColor(_isUser),
                            border: Border.all(width: 0.5),
                            borderRadius: _itemBorderRadius(_isUser)),
                        child: _textChat(_chat, _isUser)),
                    SPACE(height: 3),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_itemAligment(_isUser) == Alignment.centerRight)
                          if (_chat.status == "read" && (i + 1) == _.date?.length)
                            Row(
                              children: [
                                Text(_chat.status!, style: COSTUM_TEXT_STYLE(fonstSize: 10)),
                                SPACE(),
                              ],
                            )
                          else if (_chat.status == "unread" && (i + 1) == _.date?.length)
                            Row(
                              children: [
                                Text(_chat.status!, style: COSTUM_TEXT_STYLE(fonstSize: 10)),
                                SPACE(),
                              ],
                            )
                          else if (_chat.status == "pending")
                            Row(
                              children: [
                                const Icon(Icons.watch_later_outlined, size: 15),
                                SPACE(),
                              ],
                            )
                          else
                            Container(),
                        // if (_itemAligment(_isUser) == Alignment.centerLeft)
                        //   TEXT('${_chat.status} ${_chat.code}'),
                        TEXT(
                            DATE_FORMAT(DateTime.fromMillisecondsSinceEpoch(_chat.created!),
                                pattern: "Hms"),
                            style: COSTUM_TEXT_STYLE(fonstSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Padding _textChat(ItemChatModel _chat, bool _isUser) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: SelectableAutoLinkText(
          _chat.message!,
          style: COSTUM_TEXT_STYLE(color: Colors.white),
          linkStyle: COSTUM_TEXT_STYLE(
              color: Colors.blue[100],
              decoration: TextDecoration.underline,
              fontStyle: FontStyle.italic),
          onTap: (url) => launch(url, forceSafariVC: false),
          // onLongPress: (url) => Share.share(url),
        ));
  }

  ItemChatModel? _chatModel(DataSnapshot snap) {
    try {
      var _chat =
          ItemChatModel.fromJson(Map<String, dynamic>.from(snap.value as Map<Object?, Object?>));
      return _chat;
    } catch (e) {
      return null;
    }
  }

  int? _filterDate(ChatRoomPageController _, ItemChatModel? _chat) {
    try {
      var _showDate = _.date?.indexWhere((e) {
        return DATE_FORMAT(e) == DATE_FORMAT(DateTime.fromMillisecondsSinceEpoch(_chat!.created!));
      });
      return _showDate;
    } catch (e) {
      print("FILTER DATE $e");
      return null;
    }
  }

  CrossAxisAlignment _itemCrossAligment(bool? user) {
    try {
      if (user!) {
        return CrossAxisAlignment.end;
      } else {
        return CrossAxisAlignment.start;
      }
    } catch (e) {
      return CrossAxisAlignment.center;
    }
  }

  Alignment _itemAligment(bool? _isUser) {
    try {
      if (_isUser!) {
        return Alignment.centerRight;
      } else {
        return Alignment.centerLeft;
      }
    } catch (e) {
      return Alignment.center;
    }
  }

  Color _itemBackgroudColor(bool user) {
    if (user) {
      return ORANGEKALM;
    } else {
      return BLUEKALM;
    }
  }

  BorderRadiusDirectional _itemBorderRadius(bool user) {
    if (user) {
      return const BorderRadiusDirectional.only(
          topEnd: Radius.elliptical(20, 20),
          topStart: Radius.circular(20),
          bottomStart: Radius.circular(20));
    } else {
      return const BorderRadiusDirectional.only(
          topStart: Radius.elliptical(20, 20),
          bottomEnd: Radius.circular(20),
          topEnd: Radius.circular(20));
    }
  }
}

class ChatRoomPageController extends GetxController {
  bool laodMore = false;
  int limit = 10;
  void updateLimit() {
    limit += limit;
    laodMore = !laodMore;
    update();
  }

  FocusNode focusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  List<DateTime>? date;
  void dateFilter() async {
    var _snap = PRO.database.ref("chats/${PRO.counselorData?.matchupId}");
    _snap.onValue.listen((e) {
      try {
        var _data =
            Map<String, dynamic>.from(e.snapshot.value as Map<Object?, Object?>).values.toList();
        date = List.generate(_data.length, (i) {
          var _date = DateTime.fromMillisecondsSinceEpoch(
              ItemChatModel.fromJson(Map<String, dynamic>.from(_data[i] as Map<Object?, Object?>))
                  .created!);
          return _date;
        });
      } catch (e) {
        print(e);
      }
      date?.sort((a, b) {
        return a.compareTo(b);
      });
      update();
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      if (scrollController.hasClients) {
        await scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100), curve: Curves.bounceIn);
      } else {
        print("didnt have client");
      }
    });
  }

  bool sending = false;
  Future<void> sendMessage() async {
    sending = true;
    update();
    if (messageController.text.isEmpty) {
      return;
    }
    try {
      await PRO.pushNotif(messageController.text);
      var _snap = PRO.database.ref("chats/${PRO.counselorData?.matchupId}");
      await _snap.push().set(ItemChatModel(
              code: PRO.userData?.code,
              message: messageController.text,
              created: DateTime.now().millisecondsSinceEpoch,
              name: PRO.userData?.firstName,
              readed: "false",
              toCode: PRO.counselorData?.counselor?.code,
              status: "unread")
          .toJson());
    } catch (e) {
      ERROR_SNACK_BAR("Perhatian", "$e");
      sending = false;
      update();
    }
    messageController.clear();
    sending = false;
    update();
  }
}

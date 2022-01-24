import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

@immutable
class ClipboardData {
  const ClipboardData({this.text});
  final String? text;
}

class Clipboard {
  Clipboard._();
  static const String kTextPlain = 'text/plain';
  static Future<void> setData(ClipboardData data) async {
    await SystemChannels.platform.invokeMethod<void>(
      'Clipboard.setData',
      <String, dynamic>{
        'text': data.text,
      },
    );
  }

  static Future<ClipboardData?> getData(String? format) async {
    final Map<String, dynamic>? result =
        await SystemChannels.platform.invokeMethod(
      'Clipboard.getData',
      format,
    );
    if (result == null) return null;
    return ClipboardData(text: result['text'] as String);
  }
}

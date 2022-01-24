import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

String YOUTUBE_FRAME(String? id) {
  return '''<!DOCTYPE html>
<html>
  <body>
    <!-- 1. The <iframe> (and video player) will replace this <div> tag. -->
    <div id="player"></div>
    <script>
      // 2. This code loads the IFrame Player API code asynchronously.
      var tag = document.createElement('script');

      tag.src = "https://www.youtube.com/iframe_api";
      var firstScriptTag = document.getElementsByTagName('script')[0];
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

      // 3. This function creates an <iframe> (and YouTube player)
      //    after the API code downloads.
      var player;
      function onYouTubeIframeAPIReady() {
        player = new YT.Player('player', {
          height: '480',
          width: '100%',
          videoId: '$id',
          playerVars: {
            'playsinline': 1
          },
          events: {
            'onReady': onPlayerReady,
            'onStateChange': onPlayerStateChange
          }
        });
      }

      // 4. The API will call this function when the video player is ready.
      function onPlayerReady(event) {
        event.target.playVideo();
      }

      // 5. The API calls this function when the player's state changes.
      //    The function indicates that when playing a video (state=1),
      //    the player should play for six seconds and then stop.
      var done = false;
      function onPlayerStateChange(event) {
        if (event.data == YT.PlayerState.PLAYING && !done) {
          setTimeout(stopVideo, 6000);
          done = true;
        }
      }
      function stopVideo() {
        player.stopVideo();
      }
    </script>
  </body>
</html>''';
}

String htmlNotFound() {
  return '''<html><body>Not found/body></html>''';
}

String YOUTUBE_PLAYER(String? id) =>
    base64Encode(const Utf8Encoder().convert(YOUTUBE_FRAME(id)));

String YOUTUBE_THUMBNAIL({
  @required String? videoId,
  String quality = ThumbnailQuality.high,
  bool webp = true,
}) {
  return webp
      ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
      : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';
}

class ThumbnailQuality {
  /// 120*90
  static const String defaultQuality = 'default';

  /// 320*180
  static const String medium = 'mqdefault';

  /// 480*360
  static const String high = 'hqdefault';

  /// 640*480
  static const String standard = 'sddefault';

  /// Unscaled thumbnail
  static const String max = 'maxresdefault';
}

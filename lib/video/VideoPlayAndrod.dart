import 'package:flutter/material.dart';
import 'package:video_exo_plugin/video_player.dart';
import 'package:video_exo_plugin/flutter_simple_video_player.dart';

class VideoPlayAndrod extends StatefulWidget {
  final String url;

  VideoPlayAndrod(this.url);

  @override
  _VideoPlay createState() => _VideoPlay();
}

class _VideoPlay extends State<VideoPlayAndrod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: SimpleVideoPlayer(
      widget.url,
      isLandscape: true,
      videoType: VideoType.net,
    )));
  }
}

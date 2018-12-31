library flutter_page_video;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_exo_plugin/video_player.dart';
import 'dart:io' show File;
import 'package:flutter/services.dart';

enum VideoType { net, assets, file }

typedef Widget VideoWidgetBuilder(
    BuildContext context, VideoPlayerController controller);

abstract class PlayerLifeCycle extends StatefulWidget {
  PlayerLifeCycle(this.dataSource, this.childBuilder);

  final VideoWidgetBuilder childBuilder;
  final String dataSource;
}

class NetworkPlayerLifeCycle extends PlayerLifeCycle {
  NetworkPlayerLifeCycle(String dataSource, VideoWidgetBuilder childBuilder)
      : super(dataSource, childBuilder);

  @override
  _NetworkPlayerLifeCycleState createState() => _NetworkPlayerLifeCycleState();
}

abstract class _PlayerLifeCycleState extends State<PlayerLifeCycle> {
  VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = createVideoPlayerController();
    controller.initialize();
    controller.setLooping(true);
    controller.play();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.childBuilder(context, controller);
  }

  VideoPlayerController createVideoPlayerController();
}

class _NetworkPlayerLifeCycleState extends _PlayerLifeCycleState {
  @override
  VideoPlayerController createVideoPlayerController() {
    return VideoPlayerController.network(widget.dataSource);
  }
}

class AssetPlayerLifeCycle extends PlayerLifeCycle {
  AssetPlayerLifeCycle(String dataSource, VideoWidgetBuilder childBuilder)
      : super(dataSource, childBuilder);

  @override
  _AssetPlayerLifeCycleState createState() => new _AssetPlayerLifeCycleState();
}

class _AssetPlayerLifeCycleState extends _PlayerLifeCycleState {
  @override
  VideoPlayerController createVideoPlayerController() {
    return new VideoPlayerController.asset(widget.dataSource);
  }
}

class FilePlayerLifeCycle extends PlayerLifeCycle {
  FilePlayerLifeCycle(String dataSource, VideoWidgetBuilder childBuilder)
      : super(dataSource, childBuilder);

  @override
  _FilePlayerLifeCycleState createState() => new _FilePlayerLifeCycleState();
}

class _FilePlayerLifeCycleState extends _PlayerLifeCycleState {
  @override
  VideoPlayerController createVideoPlayerController() {
    return new VideoPlayerController.file(File(widget.dataSource));
  }
}

class AspectRatioVideo extends StatefulWidget {

  AspectRatioVideo(this.controller);

  final VideoPlayerController controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {

  VideoPlayerController get controller => widget.controller;
  VoidCallback listener;
  bool hideBottom = true;

  @override
  void initState() {
    super.initState();
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
    controller.addListener(listener);
  }

  void onClickPlay() {
    if (!controller.value.initialized) {
      return;
    }
    setState(() {
      hideBottom = false;
    });
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      Future.delayed(const Duration(seconds: 5), () {
        if (!mounted) {
          return;
        }
        if (!controller.value.initialized) {
          return;
        }
        if (controller.value.isPlaying && !hideBottom) {
          setState(() {
            hideBottom = true;
          });
        }
      });
      controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    if (controller.value.initialized) {
      final Size size = controller.value.size;
      return GestureDetector(
        child: Container(
          color: Colors.black,
          child: Center(
              child: AspectRatio(
                aspectRatio: size.width / size.height,
                child: Stack(
                  children: <Widget>[
                    VideoPlayer(controller),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: hideBottom
                          ? Container()
                          : Opacity(
                        opacity: 0.8,
                        child: Container(
                            height: 30.0,
                            color: Colors.grey,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                    child: controller.value.isPlaying
                                        ? Icon(
                                      Icons.pause,
                                      color: primaryColor,
                                    )
                                        : Icon(
                                      Icons.play_arrow,
                                      color: primaryColor,
                                    ),
                                  ),
                                  onTap: onClickPlay,
                                ),
                                Container(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Center(
                                      child: Text(
                                        "${controller.value.position.toString().split(".")[0]}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                                Expanded(
                                    child: VideoProgressIndicator(
                                      controller,
                                      allowScrubbing: true,
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                                      colors: VideoProgressColors(
                                          playedColor: primaryColor),
                                    )),
                                Container(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Center(
                                      child: Text(
                                        "${controller.value.duration.toString().split(".")[0]}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                              ],
                            )),
                      ),
                    ),
                    Center(
                      child: controller.value.isBuffering
                          ? CircularProgressIndicator()
                          : null,
                    )
                  ],
                ),
              )),
        ),
        onTap: onClickPlay,
      );
    } else if (controller.value.hasError && !controller.value.isPlaying) {
      return Container(
        color: Colors.black,
        child: Center(
          child: RaisedButton(
            onPressed: () {
              controller.initialize();
              controller.setLooping(true);
              controller.play();
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: Text("播放出错，请重试！"),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

class SimpleVideoPlayer extends StatefulWidget {
  final String source;
  final VideoType videoType;
  final bool isLandscape;

  SimpleVideoPlayer(this.source, {this.videoType : VideoType.net, this.isLandscape : false});

  @override
  _SimpleVideoPlayerState createState() => _SimpleVideoPlayerState();
}

class _SimpleVideoPlayerState extends State<SimpleVideoPlayer> {

  Widget getVideoPlayer(){
    if (VideoType.file == widget.videoType) {
      return new FilePlayerLifeCycle(
          widget.source,
              (BuildContext context, VideoPlayerController controller) =>
              AspectRatioVideo(controller));
    } else if (VideoType.assets == widget.videoType) {
      return AssetPlayerLifeCycle(
          widget.source,
              (BuildContext context, VideoPlayerController controller) =>
              AspectRatioVideo(controller));
    } else {
      return NetworkPlayerLifeCycle(
        widget.source,
            (BuildContext context, VideoPlayerController controller) =>
            AspectRatioVideo(controller),
      );
    }
  }

  @override
  void initState() {
    if(widget.isLandscape){
      SystemChrome.setEnabledSystemUIOverlays([]);
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    }
    super.initState();
  }

  @override
  void dispose() {
    if(widget.isLandscape){
      SystemChrome.setEnabledSystemUIOverlays(
          [SystemUiOverlay.bottom, SystemUiOverlay.top]);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Center(
          child: getVideoPlayer(),
        ),
      ),
    );
  }
}
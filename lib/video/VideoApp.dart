

import 'package:flutter_ijk/flutter_ijk.dart';
import 'package:flutter/material.dart';

class VideoApp extends StatefulWidget {

  final String url;
  VideoApp(this.url);

  @override
  _VideoAppState createState() => _VideoAppState(url);

}

class _VideoAppState extends State<VideoApp> {
  IjkPlayerController _controller;

  final String url;
  _VideoAppState(this.url);

  @override
  void initState() {
    super.initState();
    print("播放:$url");
    _controller = IjkPlayerController.network(url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.initialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: IjkPlayer(_controller),
          )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}


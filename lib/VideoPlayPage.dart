
import 'package:flutter/material.dart';


class VideoApp extends  StatefulWidget {
  String url;


  VideoApp(this.url);
  @override
  _VideoAppState createState() => _VideoAppState(url);

}

class _VideoAppState extends State<VideoApp> {
  bool _isPlaying = false;

  String url;

  _VideoAppState(this.url);

  @override
  void initState() {
    super.initState();
    print("播放:$url");

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body:Text(url),
      ),
    );
  }
}
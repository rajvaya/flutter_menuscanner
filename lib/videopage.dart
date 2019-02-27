import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

void main() => runApp(VideoApp());

class VideoApp extends StatefulWidget {
  final String url;
  VideoApp({Key key,this.url}) : super (key: key);
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network("${widget.url}")
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {

          _controller.play();
          _controller.setLooping(true);});
      });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body:    Center(

          child: _controller.value.initialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),

          )
              : Container(

              child: new Text('This may take some time depends on network speed please wait ', textAlign: TextAlign.center,softWrap: true,
                style: new TextStyle(fontSize: 30.0, color: Colors.blue),)
          ),

        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {

          },
          icon: Icon(Icons.fastfood),
          label: Text("ORDER NOW"),

        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,


      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
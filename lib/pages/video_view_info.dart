import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:panic_app/widgets/camera_image_widget.dart';

class VideoViewInfo extends StatefulWidget {
  const VideoViewInfo({Key? key, required this.infoVideo}) : super(key: key);
  final List<dynamic> infoVideo;
  

  @override
  State<VideoViewInfo> createState() => _VideoViewInfoState();
}

class _VideoViewInfoState extends State<VideoViewInfo> {
  late VideoPlayerController _controller;
  

  void initController() {
    print('Inicio ${widget.infoVideo}');
    _controller = VideoPlayerController.file(File(widget.infoVideo[0].toString()))
      ..addListener(() => setState(() {}))
      ..initialize().then((_) {});
  }

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.file(File(widget.infoVideo[2].toString()))
    //   ..addListener(() => setState(() {}))
    //   ..initialize().then((_) {});
    initController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final Size size     = MediaQuery.of(context).size;
    final double mirror = widget.infoVideo[1] == 0 ? 0 : math.pi;

    // if( widget.infoVideo[2]) {
    //   widget.infoVideo[2] = false;
    //   initController();
    // }

    return Stack(
      children: [
        _controller.value.isInitialized
          ? Align(
            alignment: Alignment.center,
            child: Transform(
              transform: Matrix4.rotationY(mirror),
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          ) : Container(),
        
        Align(
          alignment: Alignment.center,
          child: InkWell(
            onTap: () {
              setState(() {
                _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
              });
            },
    
            child: CircleAvatar(
              radius: 33,
              backgroundColor: Colors.black38,
              child:  
               Icon(
                _controller.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  void checkVideo(){
    if(_controller.value.position == _controller.value.duration) {
      _controller.pause();
    }
  }
}
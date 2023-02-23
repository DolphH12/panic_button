import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:panic_app/widgets/camera_image_widget.dart';


class VideoViewPage extends StatefulWidget {
  const VideoViewPage({Key? key, required this.infoVideo}) : super(key: key);
  
  final List<dynamic> infoVideo;

  @override
  State<VideoViewPage> createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    print(widget.infoVideo[0]);
    _controller = VideoPlayerController.file(File(widget.infoVideo[0]))
      ..addListener(() => setState(() {}))
      ..initialize().then((_) {});
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          width:  size.width,
          height: size.height,
          child: Stack(
            children: [
                
              SizedBox(
                width:  size.width,
                height: size.height,
                child: _controller.value.isInitialized
                  ? Column(
                    
                    children: [
                      Transform(
                        transform: Matrix4.rotationY(mirror),
                        alignment: Alignment.center,
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ],
                  ) : Container(),
              ),
              
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
      
              Positioned(
                  top: 5,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30,),
                    onPressed: () => Navigator.pop(context),
                  )
              ),
            ],
          ),
        ),
      
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.done),
          onPressed: () {
              
              video.value = [widget.infoVideo[0], mirror];
              Navigator.of(context).popUntil(ModalRoute.withName("information"));
      
          },
        ),
      ),
    );
  }
  
  void checkVideo(){
    if(_controller.value.position == _controller.value.duration) {
      _controller.pause();
    }

  }
}
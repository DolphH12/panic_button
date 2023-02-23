import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:panic_app/widgets/camera_image_widget.dart';
import 'package:video_player/video_player.dart';

// final ValueNotifier<bool> videoFile  = ValueNotifier<bool>(false);

class VideoViewInfo extends StatefulWidget {
  const VideoViewInfo({super.key, required this.videoFile});

  final String videoFile;

  @override
  State<VideoViewInfo> createState() => _VideoViewInfoState();
}

class _VideoViewInfoState extends State<VideoViewInfo> {
  
  late VideoPlayerController _controller;
  bool inicio = true;
  
  void initController({bool init = false}) {
    _controller = VideoPlayerController.file(File(widget.videoFile))
      ..addListener(() => setState(() {}))
      ..initialize().then((_) {});
  }

  @override
  void initState() {
    super.initState();
    print("INCIO CON ${widget.videoFile}");
    initController(init: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    print("MUEROOOO");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    const double mirror = math.pi;
    const BoxDecoration decorationContainer = BoxDecoration(
      color: Color.fromARGB(15, 0, 0, 0),
      borderRadius: BorderRadius.all(Radius.circular(25)),
    ); 

    const Color colorExit = Color.fromARGB(70, 0, 0, 0);

    return AspectRatio(
        aspectRatio: 4/5,
        child: Container(
          decoration: decorationContainer, 
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    _controller.value.isInitialized
                      ? Align(
                        alignment: Alignment.center,
                        child: Transform(
                          transform: Matrix4.rotationY(video.value[1]),
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
                  ]),
                ),

                Positioned(
                  child: IconButton(
                    icon: const Icon(Icons.close, color: colorExit, size: 30,),
                    onPressed: () => setState(() {
                      video.value = ["", 0.0];
                      videoOld  = "";
                    })
                  )
                ),
              ]
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
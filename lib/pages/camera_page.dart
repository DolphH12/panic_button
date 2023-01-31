import 'package:flutter/material.dart';
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

import 'package:panic_app/pages/video_view_page.dart';

late List<CameraDescription> cameras;

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {

  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  late int cameraPos = 0;
  
  final ValueNotifier _isTakePicture = ValueNotifier(false);
  
  bool isRecoring    = false;
  bool flash         = false;
  bool iscamerafront = true;
  bool isTakePicture = false;
  double transform   = 0;
  
  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(cameras.first, ResolutionPreset.high);
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _isTakePicture.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final Size size        = MediaQuery.of(context).size;
    const Color colorIndic = Color.fromARGB(74, 134, 134, 134);
    const Color colorWhite = Colors.white;
    final List<dynamic> infoVideo = [];
    
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    width: size.width,
                    height: size.height,
                    child: CameraPreview(_cameraController)
                  );
                  
                } else {
                  return _IconLoading(size: size, colorIndic: colorIndic);
                }
              }),
              
              Positioned(
                top: 5,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: colorWhite, size: 30,),
                  onPressed: () => Navigator.pop(context),
                )
              ),

              Align(
                alignment: const Alignment(0.9,-0.97),
                child: IconButton(
                  icon: Icon(
                    flash ? Icons.flash_on: Icons.flash_off,
                    color : colorWhite,
                    size  : 28,
                  ),
                  onPressed: () async {
                    flash = !flash;
                    setState(() {});
                  },
                ),
              ),
    
              Positioned(
                bottom: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  width: size.width,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.filter,
                              color : colorWhite,
                              size  : 28,
                            ),
                            onPressed: () async {
                              _selectGalery();
                            },
                          ),

                          ValueListenableBuilder(
                            valueListenable: _isTakePicture, 
                            builder: (context, _, __) {
                            return GestureDetector(
                              onLongPress: () async {

                                 _cameraController.value.isInitialized ? flash 
                                ? _cameraController.setFlashMode(FlashMode.torch) 
                                : _cameraController.setFlashMode(FlashMode.off) : null;
                                await _cameraController.startVideoRecording();
                                setState(() {
                                  isRecoring = true;
                                });
                              },

                              onLongPressUp: () async {
                                _cameraController.setFlashMode(FlashMode.off);
                                XFile videopath = await _cameraController.stopVideoRecording();
                                 
                                setState(() {
                                  isRecoring = false;
                                }
                              );
                              
                              if (!mounted) return;
                              infoVideo.addAll([videopath.path, cameraPos]);
                              Navigator.push(context, MaterialPageRoute(
                                builder: (builder) => VideoViewPage(
                                  infoVideo: infoVideo,
                                    )
                                  ),
                                );
                              },

                              onTap: () async {
                                _cameraController.value.isInitialized ? flash 
                                ? _cameraController.setFlashMode(FlashMode.always) 
                                : _cameraController.setFlashMode(FlashMode.off) : null;

                                if(!isRecoring) {
                                  _isTakePicture.value ? null 
                                  : _cameraController.value.isInitialized ? 
                                  takePhoto(context, cameraPos) : null;
                                }
                              },
    
                              child: isRecoring ? const Icon(Icons.radio_button_on,color : Colors.red, size: 80)
                                  : _isTakePicture.value ? Icon(Icons.circle_rounded, color: colorWhite.withOpacity(0.7),size: 70,) 
                                  : const Icon(Icons.circle_outlined, color: Colors.white, size: 70,)
                              );
                            }
                          ),
                
                          IconButton(
                              icon: const Icon(
                                Icons.flip_camera_ios,
                                color: Colors.white,
                                size: 28,
                              ),
                              
                              onPressed: () async {
                                setState(() {
                                  iscamerafront = !iscamerafront;
                                  transform = transform + 3.14;
                                });
                                 
                                cameraPos = iscamerafront ? 0 : 1;
                                _cameraController = CameraController(cameras[cameraPos], ResolutionPreset.high);
                                _initializeControllerFuture = _cameraController.initialize();
                                
                              }),
                        ],
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      const Text(
                        "Mantén presionado para video, toca para foto",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )
              )     
          ]
        ),
      ),
    );

  }

  void takePhoto(BuildContext context, int cameraPos) async {
    _isTakePicture.value = true;
   final image = await _cameraController.takePicture();
   _isTakePicture.value = false;
   final List<dynamic> infoImage = [image.path, cameraPos];

    if (!mounted) return;
    Navigator.pushNamed(context, 'cameraView', arguments: infoImage);
  }
  
  void _selectGalery() async {
    XFile? pickedFile;
    final ImagePicker imagePicker = ImagePicker();

    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    
    if(pickedFile != null) {
      final List<dynamic> infoImage = [pickedFile.path, 0];
      if (!mounted) return;
      Navigator.pushNamed(context, 'cameraView', arguments: infoImage);
    }
  }
}

class _IconLoading extends StatelessWidget {
  const _IconLoading({
    required this.size,
    required this.colorIndic,
  });

  final Size size;
  final Color colorIndic;

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      height: size.height,
      color: Colors.black,
      child:  Center(
        child: Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorIndic,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(color: Colors.white,),
              SizedBox(height: 30,),
              Text('Esperando cámara...', style: TextStyle(color: Colors.white),)
            ],
          ),
        ) 
      ),
    );
  }
}
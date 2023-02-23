import 'package:flutter/material.dart';
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

import 'package:panic_app/pages/video_view_page.dart';
import 'package:panic_app/widgets/camera_image_widget.dart';

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
    
    final bool cameraImage   = ModalRoute.of(context)!.settings.arguments as bool;
    
    final Size size          = MediaQuery.of(context).size;
    const Color colorLoading = Color.fromARGB(74, 134, 134, 134);
    const Color colorWhite   = Colors.white;
    
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
                  return _IconLoading(size: size, colorIndic: colorLoading);
                }
              }),
              
              Positioned(
                top: 5,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: colorWhite, size: 30,),
                  onPressed: () => {
                    video.value = [videoOld, video.value[1]],
                    Navigator.pop(context)
                  }
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
                            icon:  Icon(cameraImage ? Icons.filter : Icons.video_camera_back,color : colorWhite, size  : 28),
                            onPressed: () async {
                              // TODO implementar setGalleryVideo
                              cameraImage ? _selectGalery() : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Funcionalidad no disponible"),
                              ));;
                            },
                          ),

                          ValueListenableBuilder(
                            valueListenable: _isTakePicture, 
                            builder: (context, _, __) {
                            return GestureDetector(
                              onLongPress: () async {
                                cameraImage ? null : _cameraController.value.isInitialized ? flash ? _cameraController.setFlashMode(FlashMode.torch) : _cameraController.setFlashMode(FlashMode.off) : null;
                                await _cameraController.startVideoRecording();
                                setState(() {
                                  isRecoring = true;
                                });
                              },

                              onLongPressUp: () async {
                                _cameraController.setFlashMode(FlashMode.off);
                                XFile videopath = await _cameraController.stopVideoRecording();
                                setState(() {isRecoring = false;});
                              
                              if (!mounted) return;
                              Navigator.push(context, MaterialPageRoute(
                                builder: (builder) => VideoViewPage(infoVideo: [videopath.path, cameraPos, 0])));
                              },

                              onTap: () async {
                                
                                _cameraController.value.isInitialized ? flash 
                                ? _cameraController.setFlashMode(FlashMode.always) 
                                : _cameraController.setFlashMode(FlashMode.off) : null;

                                if(!isRecoring) {
                                  _isTakePicture.value ? null 
                                  : _cameraController.value.isInitialized 
                                  ? cameraImage ? takePhoto(context, cameraPos) : null 
                                  : null ;
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

                      Text(
                        cameraImage  ? "Toca para tomar foto" : "Mantén presionado para video",
                        style: const TextStyle(
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

    if (!mounted) return;
    Navigator.pushNamed(context, 'cameraView', arguments: [image.path, cameraPos]);
  }
  
  void _selectGalery() async {
    XFile? pickedFile;
    final ImagePicker imagePicker = ImagePicker();

    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null) {
      if (!mounted) return;
      Navigator.pushNamed(context, 'cameraView', arguments: [pickedFile.path, 0]);
    }
  }

  void _selectVideo() async {
   XFile? videoGallery;
   final ImagePicker imagePicker = ImagePicker();

   videoGallery = await imagePicker.pickVideo(source: ImageSource.gallery);

   if(videoGallery != null) {
      print(videoGallery);
      if (!mounted) return;
      // video.value = [videoGallery.path, 0.0];
      Navigator.push(context, MaterialPageRoute(
        builder: (builder) => VideoViewPage(infoVideo: [videoGallery!.path, 0.0, 0])));
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
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
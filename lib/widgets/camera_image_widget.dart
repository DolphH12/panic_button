import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:panic_app/utils/preferencias_app.dart';

import '../pages/video_view_info.dart';

String videoOld = "";
final ValueNotifier<List<dynamic>> image = ValueNotifier<List<dynamic>>([]);
final ValueNotifier<List<dynamic>> video  = ValueNotifier<List<dynamic>>(["",0.0]);

class CameraImageWidget extends StatefulWidget {
  const CameraImageWidget({super.key});

  @override
  State<CameraImageWidget> createState() => _CameraImageWidgetState();
}

class _CameraImageWidgetState extends State<CameraImageWidget> {
  
  final ImagePicker imagePicker = ImagePicker();
  double mirror = 0.0;

  @override
  Widget build(BuildContext context) {
    
    const BoxDecoration decorationContainer = BoxDecoration(
      color: Color.fromARGB(15, 0, 0, 0),
      borderRadius: BorderRadius.all(Radius.circular(25)),
    );  

    const Color colorExit = Color.fromARGB(70, 0, 0, 0);

    return Column(
      children: [
        
        const SizedBox(height: 15,),

        const ButtonCamera(cameraImage: true,),
        const SizedBox(height: 5),
        const ButtonCamera(cameraImage: false,),
        // const SizedBox(height: 15),

        ValueListenableBuilder(
          valueListenable: image, 
          builder: (context, _, __) {
          
          mirror = image.value.isNotEmpty ? image.value[1] == 0 ? 0 : math.pi : 0.0;

          return image.value.isNotEmpty 
            ? AspectRatio(
              aspectRatio: 4/5,
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                decoration: decorationContainer,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Transform(
                        transform: Matrix4.rotationY(mirror),
                        alignment: Alignment.center,
                        child: Image.file(image.value[0], fit: BoxFit.contain),
                      ),
                    ),

                    Positioned(
                        child: IconButton(
                          icon: const Icon(Icons.close, color: colorExit, size: 30),
                          onPressed: () => setState(() {
                            image.value = [] ;
                          })
                        )
                      ),
                  ]
                ),
              ),
            )
            : const SizedBox();
          }
        ),

        const SizedBox(height: 10),
          ValueListenableBuilder(
            valueListenable: video, 
            builder: (context, _, __) {
              
                if(video.value[0] != "") {
                  return VideoViewInfo(videoFile: video.value[0].toString());
                } if (videoOld != "") {
                  return AspectRatio(
                    aspectRatio: 4/5,
                    child: Container(
                      decoration: decorationContainer,
                      child: const Align(
                        child: CircleAvatar(
                          radius: 33,
                          backgroundColor: Colors.black38,
                          child: Icon(Icons.play_arrow, color: Colors.white, size: 50)
                        ),
                      ), 
                    ),
                  );
                } else {
                  return const SizedBox();
                }
            }
          )
      ],
    );
  }
}

class ButtonCamera extends StatelessWidget {
  const ButtonCamera({
    super.key, 
    required this.cameraImage
  });

  final bool cameraImage;
  
  @override
  Widget build(BuildContext context) {
    final PreferenciasUsuario prefs = PreferenciasUsuario();

    return ElevatedButton(
      style: raisedButtonStyle(context),
      onPressed: () async {  
        FocusScope.of(context).requestFocus(FocusNode());
        if(prefs.permissionDeniedCamera) {
          Navigator.pushNamed(context, 'informationPermission', arguments: ['Ir a configuración', cameraImage]);
          return;
        }

        await permissionCamera().then((hasGranted) {
          if(hasGranted == PermissionStatus.granted){
            if(!cameraImage) {              
              videoOld = video.value[0];
              video.value = ["", video.value[1]];
            }
            Navigator.pushNamed(context, 'camera', arguments: cameraImage);   
          } else {
            Navigator.pushNamed(context, 'informationPermission', arguments: ['Continuar', cameraImage]);
          } 
        });
      }, 

      child: SizedBox(
        width: 90,
        height: 30,
        child: Center(child: Text(cameraImage ? "Imagen" : "Video", style: const TextStyle(fontSize: 18))),
      ),
    );
  }

  ButtonStyle raisedButtonStyle(BuildContext context) =>
    ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).primaryColorDark,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
  );

  Future<PermissionStatus> permissionCamera() async{
    final status = await Permission.camera.status;
    return status;
  }
}

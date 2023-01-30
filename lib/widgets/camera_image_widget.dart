import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:panic_app/pages/video_view_info.dart';
import 'package:panic_app/utils/preferencias_app.dart';

  // import 'package:panic_app/widgets/btn_casual.dart';

final ValueNotifier imageBool = ValueNotifier(false);
final ValueNotifier videoBool = ValueNotifier(false);
File? image;
String? video;

class CameraImageWidget extends StatefulWidget {
  const CameraImageWidget({super.key});

  @override
  State<CameraImageWidget> createState() => _CameraImageWidgetState();
}

class _CameraImageWidgetState extends State<CameraImageWidget> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final PreferenciasUsuario prefs = PreferenciasUsuario();
    List<dynamic> infoVideo = [];

    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(15)
          ),
          onPressed: () async {  
            FocusScope.of(context).requestFocus(FocusNode());
            
            if(prefs.permissionDeniedCamera) {
              Navigator.pushNamed(context, 'informationPermission', arguments: 'Ir a configuración');
              return;
            }
            await permissionCamera().then((hasGranted) {
              if(hasGranted == PermissionStatus.granted){
                Navigator.pushNamed(context, 'camera');   
              } else {
                Navigator.pushNamed(context, 'informationPermission', arguments: 'Continuar');
              } 
            });
          }, 

          child: const Icon(Icons.camera_alt)
        ),

        const SizedBox(height: 15),

        ValueListenableBuilder(
          valueListenable: imageBool, 
          builder: (context, _, __) {
          imageBool.value = false;
          return image != null
            ? AspectRatio(
              aspectRatio: 4/5,
              child: Container(
                color:const Color.fromARGB(20, 0, 0, 0),
                child: Stack(
                  children: [

                    Align(
                      alignment: Alignment.center,
                      child: 
                      Image.file(
                        image!,
                        fit: BoxFit.contain,
                      ),
                    ),
            
                    Positioned(
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black54, size: 30,),
                        onPressed: () => setState(() {
                          image = null;
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
          valueListenable: videoBool, 
          builder: (context, _, __) {
          videoBool.value = false;
          infoVideo = [];
          infoVideo.addAll([video, 0]);
          return video != null
            ? AspectRatio(
              aspectRatio: 4/5,
              child: Container(
                color: const Color.fromARGB(20, 0, 0, 0),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: VideoViewInfo(infoVideo: infoVideo)
                    ),

                    Positioned(
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black54, size: 30,),
                        onPressed: () => setState(() {
                          video = null;
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
        
      ],
    );
  }
  
  // Future selectImage(option) async {
  //   XFile? pickedFile;
  //   if (option == 1) {
  //     pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
  //   } else {
  //     pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
  //   }
  //   setState(() {
  //     if (pickedFile != null) {
  //       image = File(pickedFile.path);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("Imagen no seleccionada")));
  //     }
  //   });
  // }

  Future<PermissionStatus> permissionCamera() async{
    final status = await Permission.camera.status;
    return status;
  }
}

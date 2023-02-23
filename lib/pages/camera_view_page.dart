import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:panic_app/widgets/camera_image_widget.dart';

class CameraViewPage extends StatefulWidget {
  const CameraViewPage({Key? key}) : super(key: key);

  @override
  State<CameraViewPage> createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {

  @override
  Widget build(BuildContext context) {
    final List<dynamic> infoImage = ModalRoute.of(context)!.settings.arguments as List;

    final double mirror    = infoImage[1] == 0 ? 0 : math.pi;
    final Size size        = MediaQuery.of(context).size;
    const Color colorWhite = Colors.white;
    
    return SafeArea(
      child: Scaffold(
        
        backgroundColor: Colors.black,
        body: Container(
          width:  double.infinity,
          height: size.height,
          alignment: Alignment.center,
          child: Stack(
            children: [

              Transform(
                transform: Matrix4.rotationY(mirror),
                alignment: Alignment.center,
                child: Image.file(
                  File(infoImage[0]),
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: 5,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: colorWhite, size: 30,),
                  onPressed: () => Navigator.pop(context)
                )
              ),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.done),
        onPressed: () { 
          WidgetsBinding.instance.addPostFrameCallback((_) {
            image.value = [File(infoImage[0]), infoImage[1]];
            // imageBool.value = true;
            Navigator.of(context).popUntil(ModalRoute.withName("information"));
          });// Navigator.pushNamedAndRemoveUntil(context, 'information', ModalRoute.withName('cameraPage'));
        },
      ),
      ),
    );
  }
}
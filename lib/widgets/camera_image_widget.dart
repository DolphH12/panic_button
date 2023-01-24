import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panic_app/widgets/btn_casual.dart';

File? image;

class CameraImageWidget extends StatefulWidget {
  const CameraImageWidget({super.key});

  @override
  State<CameraImageWidget> createState() => _CameraImageWidgetState();
}

class _CameraImageWidgetState extends State<CameraImageWidget> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BtnCasual(
            textobutton: "Imagen",
            onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Escoge'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BtnCasual(
                            textobutton: "Cámara",
                            onPressed: () {
                              Navigator.of(context).pop();
                              selectImage(1);
                            },
                            width: 100,
                            colorBtn: Theme.of(context).primaryColorDark),
                        const SizedBox(
                          height: 15,
                        ),
                        BtnCasual(
                            textobutton: "Galeria",
                            onPressed: () {
                              Navigator.of(context).pop();
                              selectImage(2);
                            },
                            width: 100,
                            colorBtn: Theme.of(context).primaryColorDark)
                      ],
                    ),
                    actions: [
                      BtnCasual(
                          textobutton: 'Aceptar',
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          width: 100,
                          colorBtn: Theme.of(context).primaryColor)
                    ],
                  ),
                ),
            width: 100,
            colorBtn: Theme.of(context).primaryColorDark),
        const SizedBox(
          height: 10,
        ),
        image != null
            ? SizedBox(
                width: 300,
                height: 300,
                child: Image.file(
                  image!,
                  fit: BoxFit.cover,
                ))
            : const SizedBox(),
      ],
    );
  }

  Future selectImage(option) async {
    XFile? pickedFile;
    if (option == 1) {
      pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Imagen no seleccionada")));
      }
    });
  }
}

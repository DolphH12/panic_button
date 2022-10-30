import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panic_app/services/event_services.dart';
import 'package:panic_app/utils/preferencias_app.dart';
import 'package:panic_app/utils/utils.dart';
import 'package:panic_app/widgets/btn_casual.dart';
import 'package:panic_app/widgets/btn_ppal.dart';
import 'package:panic_app/widgets/custom_input.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record_mp3/record_mp3.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int args = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColorDark,
        elevation: 0,
        leadingWidth: 200,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: const [
                Icon(Icons.arrow_back_ios_new),
                Text("Regresar")
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: ContainPresentation(type: args),
        ),
      ),
    );
  }
}

class ContainPresentation extends StatelessWidget {
  const ContainPresentation({super.key, required this.type});

  final int type;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Agrega Información",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        Expanded(
            child: StepPresentation(
          type: type,
        ))
      ],
    );
  }
}

class StepPresentation extends StatefulWidget {
  const StepPresentation({
    Key? key,
    required this.type,
  }) : super(key: key);

  final int type;

  @override
  State<StepPresentation> createState() => _StepPresentationState();
}

class _StepPresentationState extends State<StepPresentation> {
  int currentStep = 0;
  TextEditingController commentCtrl = TextEditingController();
  EventService eventService = EventService();
  PreferenciasUsuario prefs = PreferenciasUsuario();
  String state = "";
  File? image;
  final ImagePicker _imagePicker = ImagePicker();

  bool loading = false;

  final audioPlayer = AudioPlayer();
  bool boolButton = false;
  String statusText = "";
  bool isComplete = false;
  bool isRecording = false;
  String? recordFilePath;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      initPlayer();
    }

    return Stepper(
        controlsBuilder: (context, details) {
          return BtnPpal(textobutton: 'Continuar', onPressed: continued);
        },
        type: StepperType.vertical,
        physics: const ScrollPhysics(),
        currentStep: currentStep,
        onStepTapped: (value) => tapped(value),
        onStepContinue: () => continued,
        onStepCancel: () => cancel,
        steps: [
          Step(
              title: const Text("Descripción"),
              content: Column(
                children: [
                  const Text(
                    "Describe la emergencia",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomInput(
                      icon: Icons.message,
                      placehoder: "Descripción",
                      textController: commentCtrl,
                      keyboardType: TextInputType.text),
                ],
              ),
              isActive: currentStep > 0,
              state: currentStep > 0 ? StepState.complete : StepState.disabled),
          Step(
              title: const Text("Evidencias"),
              content: Column(
                children: [
                  const Text(
                    "Sube tu evidencia",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                                      textobutton: "Camara",
                                      onPressed: () => selectImage(1),
                                      width: 100,
                                      colorBtn:
                                          Theme.of(context).primaryColorDark),
                                  BtnCasual(
                                      textobutton: "Galeria",
                                      onPressed: () => selectImage(2),
                                      width: 100,
                                      colorBtn:
                                          Theme.of(context).primaryColorDark)
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
                          width: 200,
                          height: 200,
                          child: Image.file(
                            image!,
                            fit: BoxFit.cover,
                          ))
                      : const SizedBox(),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    elevation: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 15),
                        const Text(
                          "*Graba un audio contando lo ocurrido",
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).primaryColorDark,
                              elevation: 7),
                          child: Icon(
                            isRecording ? Icons.stop : Icons.mic,
                            size: 50,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            if (isRecording) {
                              stopRecord();
                            } else {
                              boolButton = true;
                              startRecord();
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  Theme.of(context).primaryColorDark,
                              child: IconButton(
                                onPressed: () async {
                                  if (isPlaying) {
                                    await audioPlayer.pause();
                                  } else if (boolButton) {
                                    await audioPlayer.resume();
                                  }
                                },
                                icon: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                iconSize: 25,
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: Column(
                                children: [
                                  Slider(
                                    thumbColor: Colors.black26,
                                    inactiveColor: Colors.black12,
                                    activeColor: Theme.of(context).primaryColor,
                                    min: 0,
                                    max: duration.inSeconds.toDouble(),
                                    value: position.inSeconds.toDouble(),
                                    onChanged: (value) async {
                                      final position =
                                          Duration(seconds: value.toInt());
                                      await audioPlayer.seek(position);
                                      await audioPlayer.resume();
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        formatTime(position),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      const Spacer(),
                                      Text(
                                        formatTime(duration),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
              isActive: currentStep > 0,
              state: currentStep > 0 ? StepState.complete : StepState.disabled)
        ]);
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

  tapped(int value) {
    setState(() {
      currentStep = value;
    });
  }

  continued() async {
    if (currentStep == 0) {
      if (commentCtrl.text.isNotEmpty) {
        Position position = await _determinePosition();
        print(commentCtrl.text);
        print(widget.type);
        print(position.latitude);
        await eventService.addEvent(position, widget.type, commentCtrl.text);
        setState(() => currentStep += 1);
      } else {
        mensajeInfo(
            context, "Algo salio Mal", "Recuerda añadir una descripción");
      }
    } else if (currentStep == 1) {
      Navigator.pushNamed(context, 'home');
    }
  }

  cancel() {
    currentStep > 0 ? setState(() => currentStep -= 1) : null;
  }

  Future<String> getFilePath() async {
    Directory storageDirectory = await getTemporaryDirectory();
    String sdPath = "${storageDirectory.path}/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    prefs.audio++;
    return "$sdPath/test_${prefs.audio}.mp3";
  }

  void startRecord() async {
    statusText = "Recording...";
    recordFilePath = await getFilePath();
    isComplete = false;
    isRecording = true;
    RecordMp3.instance.start(recordFilePath!, (type) {
      statusText = "Record error--->$type";
      setState(() {});
    });
    setState(() {});
  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        statusText = "Recording...";
        setState(() {});
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        statusText = "Recording pause...";
        setState(() {});
      }
    }
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      statusText = "Record complete";
      isComplete = true;
      isRecording = false;
      setAudio();
      setState(() {});
    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      statusText = "Recording...";
      setState(() {});
    }
  }

  void initPlayer() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      if (!mounted) return;
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      if (!mounted) return;
      setState(() {
        position = newPosition;
      });
    });
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  Future setAudio() async {
    audioPlayer.setSourceDeviceFile(recordFilePath!);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}

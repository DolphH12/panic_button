import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:panic_app/utils/preferencias_app.dart';
import 'package:panic_app/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';

String? recordFilePath;

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({super.key});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  PreferenciasUsuario prefs = PreferenciasUsuario();
  final audioPlayer = AudioPlayer();
  bool boolButton = false;
  String statusText = "";
  bool isComplete = false;
  bool isRecording = false;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  @override
  Widget build(BuildContext context) {
    if (mounted) {
      initPlayer();
    }
    return Card(
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          const Text(
            "*Graba un audio contando lo ocurrido",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColorDark,
                elevation: 7),
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Icon(
                isRecording ? Icons.stop : Icons.mic,
                size: 40,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              if (isRecording) {
                stopRecord();
                position = const Duration(seconds: 0);
                setState(() {});
              } else {
                boolButton = true;
                startRecord();
              }
            },
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).primaryColorDark,
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
                        position = Duration(seconds: value.toInt());
                        await audioPlayer.seek(position);
                        await audioPlayer.resume();
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          formatTime(position),
                          style: const TextStyle(color: Colors.black),
                        ),
                        const Spacer(),
                        Text(
                          formatTime(duration),
                          style: const TextStyle(color: Colors.black),
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
    );
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

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      statusText = "Recording...";
      recordFilePath = await getFilePath();
      isComplete = false;
      isRecording = true;
      RecordMp3.instance.start(recordFilePath!, (type) {
        statusText = "Record error--->$type";
        setState(() {});
      });
    } else {
      if (!mounted) return;
      mensajeInfo(context, "Error de permisos",
          "Es necesario autorizar los permisos de micrófono para grabar audio.");
    }
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
}

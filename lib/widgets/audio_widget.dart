
import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioWidget extends StatefulWidget {
  const AudioWidget({super.key, required this.audios});

  final List<dynamic> audios;

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  
  bool isPlaying = false;
  bool inicializar = true;
  final audioPlayer = AudioPlayer();

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  List<dynamic> aud = [];

  @override
  void initState() {
    aud = widget.audios;
    audioPlayer.pause();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (mounted) {
      initPlayer();
    }
    return _showAudio(aud);
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

  Future<void> _loadAudio(audio) async {
      Uint8List aud = const Base64Decoder().convert(audio);
      audioPlayer.setSourceBytes(aud);
      
      
  }

  Widget _showAudio(List<dynamic> audios) {

    if (audios.isNotEmpty) {
      if (inicializar) {
        _loadAudio(audios[0]);
        inicializar = false;
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color.fromARGB(174, 0, 74, 124),
            child: IconButton(
              onPressed: () async {
                if (isPlaying) {
                  await audioPlayer.pause();
                } else {
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
            width: MediaQuery.of(context).size.height*0.35,
            child: Column(
              children: [
                Slider(
                  thumbColor: Colors.black26,
                  inactiveColor:  Colors.black12,
                  activeColor: const Color.fromARGB(174, 0, 74, 124),
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
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
      );
    }
    return const Text("No hay audios disponibles");
  }
}
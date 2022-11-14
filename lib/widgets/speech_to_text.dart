import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToText extends StatefulWidget {
  const SpeechToText({super.key});

  @override
  State<SpeechToText> createState() => _SpeechToTextState();
}

class _SpeechToTextState extends State<SpeechToText> {
  
  int seconds = 3;
  Timer? timer;
  int confirm = 0;
  var _speech = stt.SpeechToText();
  String _text = "";
  
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) { 
      setState(() => seconds--);
      if(seconds == 0) {
        _listen();
        seconds = 3;
      }
      print(seconds);
    });
  }

  void _listen() async {
    bool available = await _speech.initialize(
        onStatus: (value) => {
          print("onStatusR: $value"),
          print("confirm en $confirm"),
          if((value == "done" && confirm == 2)) {
            print("Emergencia"),
            confirm = 0
          }
        },
        onError: (value) => print("onStatusERROR: $value"));
    
    if(available){
      _speech.listen(
        onResult: (value) => setState(() {
          _text = value.recognizedWords;
          if ((_text.contains("hola") || _text.contains("Hola"))){  
            confirm ++;       
            _text = "";
            timer?.cancel();
             _speech.stop();
            setState(() {});
          }
        }),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

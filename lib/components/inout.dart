import 'dart:developer';

import 'package:flutter/material.dart';

class OutputContainer extends StatelessWidget {
  final Widget child;

  const OutputContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return Container(
      height: sizeHeight / 10,
      padding: EdgeInsets.all(sizeHeight / 70),
      margin: EdgeInsets.all(sizeHeight / 70),
      constraints: BoxConstraints(
        minWidth: sizeWidth / 2.7,
        maxWidth: sizeWidth / 2.3,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.8),
        color: Color.fromRGBO(234, 218, 250, 1),
      ),
      child: child,
    );
  }
}

//! text to speech feature
Future<void> textToSpeech(String text, dynamic flutterTts) async {
  log("SPEAKING");
  var lang = await flutterTts.getVoices;
  log(lang.toString());
  // lastTextSpoken = text;
  await flutterTts.setVoice({"name": "en-AU-language", "locale": "en-AU"});
  await flutterTts.setPitch(0.9);
  await flutterTts.speak(text);
}

//! speech to text feature

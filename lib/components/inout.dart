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
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.height / 55,
      ),
      height: MediaQuery.of(context).size.height / 3.5,
      width: MediaQuery.of(context).size.width / 1.2,
      padding: EdgeInsets.all(sizeHeight / 50),
      constraints: BoxConstraints(
        minWidth: sizeWidth / 2.9,
        maxWidth: sizeWidth,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 1),
        // border: Border.all(color: Colors.black, width: 0.4),
        borderRadius: BorderRadius.circular(5),
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

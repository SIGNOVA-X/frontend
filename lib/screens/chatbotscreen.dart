import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:signova/model/message.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Message> _messages = [
    // Message(isUser: true, text: "hello ! how are you?"),
    // Message(isUser: false, text: "I am fine.what about you?"),
  ];

  final TextEditingController _userinputcontroller = TextEditingController();

  callGeminiModel() async {
    try {
      if (_userinputcontroller.text.isNotEmpty) {
        _messages.add(Message(text: _userinputcontroller.text, isUser: true));
      }
      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: dotenv.env['GENERATIVE_AI_APIKEY']!,
      );

      final prompt = _userinputcontroller.text.trim();
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      log(response.text.toString());
      setState(() {
        _messages.add(Message(text: response.text!, isUser: false));
      });
      _userinputcontroller.clear();
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Color.fromRGBO(234, 218, 250, 1),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: sizeWidth / 3,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(sizeHeight / 55),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(0, 0, 0, 0.8),
                      ),
                      child: Image(image: AssetImage('assets/robot.png')),
                    ),
                  ),
                  ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ListTile(
                        title: Align(
                          alignment:
                              message.isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(sizeHeight / 60),
                            decoration: BoxDecoration(
                              color:
                                  message.isUser
                                      ? Color.fromRGBO(90, 24, 154, 1)
                                      : Colors.white,
                              borderRadius:
                                  message.isUser
                                      ? BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      )
                                      : BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                            ),
                            child: Text(
                              message.text,
                              style: GoogleFonts.inter(
                                color:
                                    message.isUser
                                        ? Colors.white
                                        : Color.fromRGBO(0, 0, 0, 1),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          //! User input
          Padding(
            padding: EdgeInsets.only(
              right: sizeWidth / 300,
              left: sizeWidth / 300,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: sizeWidth / 30,
                vertical: sizeHeight / 70,
              ),
              decoration: BoxDecoration(
                color: Color.fromRGBO(234, 218, 250, 1),
              ),
              // margin: EdgeInsets.only(bottom: sizeHeight / 23),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _userinputcontroller,
                      decoration: InputDecoration(
                        hintText: "Write your message here...",
                        hintStyle: GoogleFonts.inter(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(sizeHeight / 28),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(sizeHeight / 90),
                      ),
                    ),
                  ),
                  SizedBox(width: sizeWidth / 40),
                  GestureDetector(
                    onTap: callGeminiModel,
                    child: Container(
                      padding: EdgeInsets.all(sizeHeight / 70),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(90, 24, 154, 1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Iconsax.send_2_outline,
                        size: sizeHeight / 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:signova/components/navbar.dart';
import 'package:signova/model/message.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  int _selectedIndex = 3;
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
        model:
            'tunedModels/motivationalbot-8ly8h0vudkfl', // Your fine-tuned model
        apiKey: dotenv.env['GENERATIVE_AI_APIKEY']!,
        generationConfig: GenerationConfig(
          temperature: 1.0,
          topP: 0.95,
          topK: 40,
          maxOutputTokens: 8192,
        ),
      );

      final prompt = _userinputcontroller.text.trim();
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      log(response.text.toString());

      setState(() {
        _messages.add(
          Message(text: response.text ?? "No response", isUser: false),
        );
      });

      _userinputcontroller.clear();
    } catch (e) {
      log('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false, // Disable default pop behavior
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushReplacementNamed(context, '/home-community');
        }
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(110, 60, 124, 1.0),
                      Color.fromRGBO(15, 10, 33, 1),
                      Colors.black,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: sizeWidth / 1.7,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(sizeHeight / 70),
                        child: Image.asset('assets/images/chatbot_bg.png'),
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
                                        ? Color.fromRGBO(110, 60, 124, 1.0)
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
                decoration: BoxDecoration(color: Color.fromRGBO(4, 4, 4, 1)),
                child: Container(
                  padding: EdgeInsets.all(sizeHeight / 90),
                  margin: EdgeInsets.only(
                    bottom: sizeHeight / 60,
                    right: sizeWidth / 40,
                    left: sizeWidth / 40,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _userinputcontroller,
                          decoration: InputDecoration(
                            hintText: "Type a message",
                            hintStyle: GoogleFonts.inter(
                              color: Color.fromRGBO(0, 0, 0, 0.7),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.all(sizeHeight / 90),
                          ),
                        ),
                      ),
                      SizedBox(width: sizeWidth / 40),
                      GestureDetector(
                        onTap: callGeminiModel,
                        child: Container(
                          padding: EdgeInsets.all(sizeHeight / 200),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_right_outlined,
                            size: sizeHeight / 23,
                            color: Color.fromRGBO(0, 0, 0, 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: gbottomnavbar(context, 3),
      ),
    );
  }
}

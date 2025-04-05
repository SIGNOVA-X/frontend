import 'dart:developer';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as sst;
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:signova/components/navbar.dart';
import 'package:video_player/video_player.dart';
import 'package:gif_view/gif_view.dart';
import 'package:signova/model/fetchgif.dart';
import 'package:signova/model/camera.dart';
import 'package:signova/components/buttons.dart';
import 'package:signova/components/inout.dart';
import 'package:signova/model/video_processing.dart'; // Import the new file

class CommunicationScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CommunicationScreen(this.cameras, {super.key});
  // const CommunicationScreen(List<CameraDescription> cameras, {super.key});
  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen>
    with TickerProviderStateMixin {
  final List<bool> isSelectedLeft = [true, false];
  final List<bool> isSelectedRight = [true, false];

  // screen navigation controller
  int _selectedIndex = 2;

  // camera controller + variables
  CameraController? camcontroller;
  bool _isRecording = false; // play / pause button
  int _selectedCameraIndex = 0; // for switching camera
  bool _isCameraInitialized = false; // for toggling diable camera
  bool _isCameraEnabled = true; // Track if camera is enabled
  late List<CameraDescription> cameras; // camera access
  late XFile _videoFile; // video output
  late VideoPlayerController _videoController;
  bool _isVideoLoaded = false;
  late String _gifUrl;
  bool _isGifLoaded = false;

  // tts and stt
  FlutterTts flutterTts = FlutterTts();
  String _responseText =
      "hello i am very happy today "; // Default placeholder text
  // final List<bool> _playAudio = [true,false];
  bool _playAudio = true;
  bool _isListening = false;
  late sst.SpeechToText speech;
  String _textFromSpeech = "Press the mic and start speaking...";

  @override
  void initState() {
    super.initState();
    speech = sst.SpeechToText();
    _setUpCamera(_selectedCameraIndex);
    _fetchGifUrlFromApi();
    initializeTts();
  }

  Future<void> _fetchGifUrlFromApi() async {
    setState(() {
      _isGifLoaded = false; // Reset GIF loading state
    });

    String? gifUrl = await GifFetcher.fetchGifUrl(_textFromSpeech);
    if (gifUrl != null && mounted) {
      setState(() {
        _gifUrl = gifUrl;
        _isGifLoaded = true;
      });
      print("GIF URL: $_gifUrl");
    }
  }

  Future<void> _setUpCamera(int camIndex) async {
    try {
      await CameraHelper.setUpCamera(widget.cameras, camIndex, (controller) {
        if (controller != null) {
          setState(() {
            camcontroller = controller;
            _isCameraInitialized = true;
          });
        } else {
          print("CameraController initialization failed.");
        }
      });
    } catch (e) {
      print("Camera setup error: $e");
    }
  }

  //! function for switching the camera
  void _onSwitchCamera() {
    CameraHelper.switchCamera(widget.cameras, _selectedCameraIndex, (newIndex) {
      setState(() {
        _selectedCameraIndex = newIndex;
      });
      _setUpCamera(_selectedCameraIndex);
    });
  }

  //! start video recording function
  Future<void> startVideoRecording() async {
    CameraHelper.startVideoRecording(camcontroller!, () {
      setState(() {
        _isRecording = true;
      });
    });
  }

  //! stop video recording function
  Future<void> stopVideoRecording() async {
    CameraHelper.stopVideoRecording(camcontroller!, (XFile videoFile) async {
      setState(() {
        _isRecording = false;
        _videoFile = videoFile;
      });
      print('Video file created: ${videoFile.name}');

      // Send video to backend for processing
      final result = await sendVideoToBackend(videoFile);
      setState(() {
        _responseText = result; // Update the UI with the result
      });
    });
  }

  //! FUNCTION TO STOP AND START RECORDING
  Future<void> onRecordButtonPressed() async {
    if (_isRecording) {
      await stopVideoRecording();
    } else {
      await startVideoRecording();
    }
  }

  void _toggleCamera() {
    CameraHelper.toggleCamera(_isCameraEnabled, (newState) {
      setState(() {
        _isCameraEnabled = newState;
      });
    });
  }

  void initializeTts() {
    flutterTts.setStartHandler(() {
      log("TTS playback started");
    });
    flutterTts.setCompletionHandler(() {
      log("TTS playback finished");
    });
    flutterTts.setErrorHandler((msg) {
      log("TTS playback error: $msg");
    });
  }

  void _startListening() async {
    bool available = await speech.initialize(
      onStatus: (status) => log("Status: $status"),
      onError: (error) => log("Error: $error"),
    );
    if (available) {
      setState(() {
        _isListening = true;
      });
      speech.listen(
        listenFor: Duration(seconds: 10),
        onResult: (result) {
          log(result.toString());
          setState(() {
            _textFromSpeech = result.recognizedWords;
          });
        },
      );
    }
  }

  void _stopListening() {
    speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  @override
  void dispose() {
    if (_isCameraInitialized) {
      camcontroller!.dispose();
    }
    if (_isVideoLoaded) {
      _videoController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      body: Column(
        children: [
          Container(
            height: sizeHeight / 2.5,
            width: sizeWidth,
            decoration: BoxDecoration(
              border: BorderDirectional(
                bottom: BorderSide(color: Colors.black, width: 1),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  Color.fromRGBO(64, 4, 94, 1),
                  Color.fromRGBO(99, 0, 126, 1),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: sizeHeight / 50),
                ToggleButtonComponent(
                  isSelected: isSelectedLeft,
                  labels: ["Text", "Audio"],
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < isSelectedLeft.length; i++) {
                        isSelectedLeft[i] = (i == index);
                      }
                    });
                  },
                ),
                Row(
                  children: [
                    CameraPreviewComponent(
                      camcontroller: camcontroller,
                      isCameraInitialized: _isCameraInitialized,
                      isCameraEnabled: _isCameraEnabled,
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: _onSwitchCamera,
                          icon: Icon(CupertinoIcons.switch_camera_solid),
                          color: Colors.grey,
                        ),
                        IconButton(
                          onPressed: () async {
                            onRecordButtonPressed();
                          },
                          icon: Icon(
                            _isRecording
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                          ),
                          iconSize: sizeHeight / 20,
                          color: Colors.white,
                        ),
                        IconButton(
                          onPressed: _toggleCamera,
                          icon:
                              _isCameraEnabled
                                  ? Icon(Iconsax.camera_bold)
                                  : Icon(Iconsax.camera_slash_bold),
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    OutputContainer(
                      child:
                          isSelectedLeft[0]
                              ? SingleChildScrollView(
                                child: Text(
                                  _responseText, // Display the updated response text
                                  style: GoogleFonts.inter(color: Colors.white),
                                ),
                              )
                              : InkWell(
                                onTap: () async {
                                  setState(() {
                                    _playAudio = !_playAudio;
                                  });
                                  if (_playAudio) {
                                    await textToSpeech(
                                      _responseText,
                                      flutterTts,
                                    );
                                  }
                                },
                                child:
                                    _playAudio
                                        ? Icon(
                                          Icons.multitrack_audio_outlined,
                                          color: Colors.white,
                                        )
                                        : Icon(
                                          Icons.audiotrack_rounded,
                                          color: Colors.white,
                                        ),
                              ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.white,
                  Color.fromRGBO(208, 185, 219, 1),
                  Color.fromRGBO(99, 0, 126, 1),
                ],
              ),
            ),
            height: sizeHeight / 2.49,
            width: sizeWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ToggleButtonComponent(
                  isSelected: isSelectedRight,
                  labels: ["Text", "Avatar"],
                  onPressed: (int index) async {
                    setState(() {
                      for (int i = 0; i < isSelectedRight.length; i++) {
                        isSelectedRight[i] = (i == index);
                      }
                    });

                    if (index == 1) {
                      setState(() {
                        _isGifLoaded = false;
                      });
                      await _fetchGifUrlFromApi();
                    }
                  },
                ),
                Container(
                  child:
                      isSelectedRight[0]
                          ? Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(
                              vertical: sizeHeight / 30,
                              horizontal: sizeWidth / 10,
                            ),
                            padding: EdgeInsets.all(sizeHeight / 40),
                            child: SingleChildScrollView(
                              child: Text(
                                _textFromSpeech,
                                style: GoogleFonts.inter(
                                  fontSize: sizeHeight / 50,
                                ),
                              ),
                            ),
                          )
                          : Container(
                            height: sizeHeight / 4.6,
                            width: sizeWidth / 3,
                            child:
                                _isGifLoaded
                                    ? GifView.network(
                                      _gifUrl,
                                      fit: BoxFit.contain,
                                      loop: true,
                                    )
                                    : Center(
                                      child: CircularProgressIndicator(),
                                    ),
                          ),
                ),
                SizedBox(height: sizeHeight / 30),
                GestureDetector(
                  onTap: _isListening ? _stopListening : _startListening,
                  child:
                      _isListening
                          ? Icon(
                            Iconsax.microphone_slash_1_bold,
                            size: sizeHeight / 20,
                            color: Colors.red,
                          )
                          : Icon(
                            Iconsax.microphone_bold,
                            size: sizeHeight / 20,
                            color: Colors.black,
                          ),
                ),
                SizedBox(height: sizeHeight / 30),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: gbottomnavbar(context, _selectedIndex),
    );
  }
}

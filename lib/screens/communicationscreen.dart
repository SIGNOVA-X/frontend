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
  final List<bool> isSelected = [true, false];
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
      "Displays translated text here..."; // Default placeholder text
  // final List<bool> _playAudio = [true,false];
  bool _playAudio = true;
  bool _isListening = false;
  late sst.SpeechToText speech;
  String _textFromSpeech = "Press the mic and start speaking";

  @override
  void initState() {
    super.initState();
    speech = sst.SpeechToText();
    _setUpCamera(_selectedCameraIndex);
    initializeTts();
  }

  Future<void> _fetchGifUrlFromApi() async {
    setState(() {
      _isGifLoaded = false; // Reset GIF loading state
    });
    log(_textFromSpeech);
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
      String result = await sendVideoToBackend(videoFile);
      log("result obtained: $result");
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
    _fetchGifUrlFromApi();
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
      appBar: AppBar(
        backgroundColor:
            isSelected[0] ? Colors.black : Color.fromRGBO(35, 2, 52, 1),
      ),
      body: Container(
        height: sizeHeight,
        width: sizeWidth,
        decoration: BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(color: Colors.black, width: 1),
          ),
          gradient:
              isSelected[0]
                  ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black,
                      Color.fromRGBO(64, 4, 94, 1),
                      Color.fromRGBO(99, 0, 126, 1),
                    ],
                  )
                  : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(35, 2, 52, 1),
                      Color.fromRGBO(118, 1, 150, 1),
                      Colors.white,
                    ],
                  ),
        ),
        child: Column(
          children: [
            ToggleButtonComponent(
              isMain: true,
              isSelected: isSelected,
              labels: ["From Sign", "To Sign"],
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = (i == index);
                  }
                });
              },
            ),
            SizedBox(height: sizeHeight / 55),
            isSelected[0]
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ToggleButtonComponent(
                      isMain: false,
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
                    Column(
                      children: [
                        CameraPreviewComponent(
                          camcontroller: camcontroller,
                          isCameraInitialized: _isCameraInitialized,
                          isCameraEnabled: _isCameraEnabled,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
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
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ToggleButtonComponent(
                      isMain: false,
                      isSelected: isSelectedRight,
                      labels: ["Text", "Avatar"],
                      onPressed: (int index) async {
                        setState(() {
                          for (int i = 0; i < isSelectedRight.length; i++) {
                            isSelectedRight[i] = (i == index);
                          }
                        });

                        // if (index == 1) {
                        //   setState(() {
                        //     _isGifLoaded = false;
                        //   });
                        //   await _fetchGifUrlFromApi();
                        // }
                      },
                    ),
                    Container(
                      child:
                          isSelectedRight[0]
                              ? Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                  minHeight: sizeHeight / 10,
                                  minWidth: sizeWidth / 1.2,
                                ),
                                margin: EdgeInsets.symmetric(
                                  vertical: sizeHeight / 30,
                                  horizontal: sizeWidth / 10,
                                ),
                                padding: EdgeInsets.all(sizeHeight / 40),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(60, 5, 88, 1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    _textFromSpeech,
                                    style: GoogleFonts.inter(
                                      fontSize: sizeHeight / 50,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                              : Container(
                                height: sizeHeight / 2,
                                width: sizeWidth / 1.2,
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
                              ? Container(
                                height: sizeHeight / 12,
                                padding: EdgeInsets.all(sizeWidth / 30),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Iconsax.microphone_slash_1_bold,
                                  size: sizeHeight / 20,
                                  color: Colors.red,
                                ),
                              )
                              : Container(
                                height: sizeHeight / 12,
                                padding: EdgeInsets.all(sizeWidth / 30),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Iconsax.microphone_bold,
                                  size: sizeHeight / 20,
                                  color: Colors.black,
                                ),
                              ),
                    ),
                    SizedBox(height: sizeHeight / 30),
                  ],
                ),
          ],
        ),
      ),
      bottomNavigationBar: gbottomnavbar(context, _selectedIndex),
    );
  }
}

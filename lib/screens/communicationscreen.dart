import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  String _responseText =
      "hello i am very happy today and you are very beautiful"; // Default placeholder text

  @override
  void initState() {
    super.initState();
    _setUpCamera(_selectedCameraIndex);
    _fetchGifUrlFromApi();
  }

  Future<void> _fetchGifUrlFromApi() async {
    setState(() {
      _isGifLoaded = false; // Reset GIF loading state
    });

    String? gifUrl = await GifFetcher.fetchGifUrl("what are you doing");
    if (gifUrl != null && mounted) {
      setState(() {
        _gifUrl = gifUrl;
        _isGifLoaded = true;
      });
      print("GIF URL: $_gifUrl");
    }
  }

  Future<void> _setUpCamera(int camIndex) async {
    // CameraHelper.setUpCamera(widget.cameras, camIndex, (controller) {
    //   setState(() {
    //     camcontroller = controller!;
    //     _isCameraInitialized = true;
    //   });
    // });
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
      camcontroller?.dispose();
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

  @override
  void dispose() {
    // camcontroller?.dispose();
    if (_isCameraInitialized) {
      camcontroller!.dispose();
    }
    if (_isVideoLoaded) {
      _videoController.dispose();
    }
    super.dispose();
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate based on selected index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home-community');
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/chatbot');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Row(
        children: [
          Container(
            height: sizeHeight,
            width: sizeWidth / 2,
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(color: Colors.black, width: 1.2),
                horizontal: BorderSide.none,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: sizeHeight / 10),
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
                OutputContainer(
                  child:
                      isSelectedLeft[0]
                          ? SingleChildScrollView(
                            child: Text(
                              _responseText, // Display the updated response text
                              style: GoogleFonts.inter(),
                            ),
                          )
                          : Icon(Icons.audiotrack_rounded),
                ),
                CameraPreviewComponent(
                  camcontroller: camcontroller,
                  isCameraInitialized: _isCameraInitialized,
                  isCameraEnabled: _isCameraEnabled,
                ),
                SizedBox(height: sizeHeight / 30),
                Row(
                  children: [
                    IconButton(
                      onPressed: _onSwitchCamera,
                      icon: Icon(CupertinoIcons.switch_camera_solid),
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
                      iconSize: sizeHeight / 14,
                      color: Color.fromRGBO(140, 58, 207, 1),
                    ),
                    IconButton(
                      onPressed: _toggleCamera,
                      icon:
                          _isCameraEnabled
                              ? Icon(Iconsax.camera_bold)
                              : Icon(Iconsax.camera_slash_bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: sizeHeight,
            width: sizeWidth / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: sizeHeight / 10),
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
                  height: sizeHeight / 1.6,
                  child:
                      isSelectedRight[0]
                          ? SizedBox.shrink()
                          : _isGifLoaded
                          ? GifView.network(
                            _gifUrl,
                            fit: BoxFit.contain,
                            loop: true,
                          )
                          : Center(child: CircularProgressIndicator()),
                ),
                Icon(
                  Iconsax.microphone_bold,
                  size: sizeHeight / 12,
                  color: Color.fromRGBO(140, 58, 207, 1),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(sizeWidth * sizeHeight * 0.00002),
        child: gbottomnavbar(context, _selectedIndex, _onTabChange),
      ),
    );
  }
}

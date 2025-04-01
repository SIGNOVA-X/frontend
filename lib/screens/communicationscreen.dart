import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:signova/components/navbar.dart';

class CommunicationScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CommunicationScreen(this.cameras, {super.key});
  // const CommunicationScreen(List<CameraDescription> cameras, {super.key});
  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  final List<bool> isSelectedLeft = [true, false];
  final List<bool> isSelectedRight = [true, false];
  int _selectedIndex = 2;
  late CameraController camcontroller;
  bool _isRecording = false;
  int _selectedCameraIndex = 0;
  bool _isCameraInitialized = false;
  bool _isCameraEnabled = true; // Track if camera is enabled
  late List<CameraDescription> cameras;
  late XFile _videoFile;

  @override
  void initState() {
    super.initState();
    _setUpCamera(_selectedCameraIndex);
  }

  Future<void> _setUpCamera(camIndex) async {
    if (widget.cameras.isNotEmpty) {
      setState(() {
        cameras = widget.cameras;
        camcontroller = CameraController(
          cameras[camIndex],
          ResolutionPreset.ultraHigh,
        );
        _isCameraInitialized = true;
      });
      camcontroller
          .initialize()
          .then((_) {
            if (!mounted) return;
            setState(() {});
          })
          .catchError((Object e) {
            if (e is CameraException) {
              log('Camera error: ${e.code}');
            }
          });
    }
  }

  //! function for switching the camera
  void _onSwitchCamera() {
    if (widget.cameras.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % widget.cameras.length;
    camcontroller.dispose();
    _setUpCamera(_selectedCameraIndex);
  }

  //! start video recording function
  Future<void> startVideoRecording() async {
    if (!camcontroller.value.isInitialized ||
        camcontroller.value.isRecordingVideo) {
      return;
    }

    try {
      await camcontroller.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      log('Error starting video recording: $e');
    }
  }

  //! stop video recording function
  Future<void> stopVideoRecording() async {
    if (!camcontroller.value.isRecordingVideo) return;
    log("reached here");
    try {
      _videoFile = await camcontroller.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
      int lengthCheck = await _videoFile.length();
      String nameCheck = _videoFile.name;
      log('check for the xfile created #1 : $lengthCheck');
      log('check for the xfile created #2: $nameCheck');
      // List<Uint8List> frames = await extractFrames(_videoFile);
      // log("Total frames extracted: $frames.length}");
    } catch (e) {
      log('Error stopping video recording: $e');
    }
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
    setState(() {
      _isCameraEnabled = !_isCameraEnabled;
    });
  }

  // Future<List<Uint8List>> extractFrames(XFile videoFile) async {
  //   List<Uint8List> frames = [];

  //   try {
  //     log("here before breaking into frames");
  //     // FFmpeg command to extract frames and print raw data
  //     await FFmpegKit.executeAsync(
  //       '-i ${videoFile.path} -vf "fps=1" -f image2pipe -vcodec mjpeg -',
  //       (session) async {
  //         final returnCode = await session.getReturnCode();
  //         log("here after breaking into frames");
  //         if (ReturnCode.isSuccess(returnCode)) {
  //           log("Frame extraction successful");
  //         } else {
  //           log("Error extracting frames: ${returnCode?.getValue()}");
  //         }
  //       },
  //       (logs) {
  //         if (logs.getMessage().startsWith('\xff\xd8')) {
  //           log("adding frames to list");
  //           frames.add(Uint8List.fromList(logs.getMessage().codeUnits));
  //         }
  //       },
  //     );

  //     log("Frames extracted: ${frames.length}"); // Log frame count
  //   } catch (e) {
  //     log("Error extracting frames: $e");
  //   }

  //   return frames;
  // }

  // Future<List<Uint8List>> extractFrames(XFile videoFile) async {
  //   List<Uint8List> frames = [];

  //   // FFmpeg command to extract 1 frame per second
  //   String command =
  //       "-i ${videoFile.path} -vf fps=1 -f image2pipe -vcodec png pipe:1";

  //   FFmpegSession session = await FFmpegKit.executeAsync(command, (
  //     session,
  //   ) async {
  //     final returnCode = await session.getReturnCode();
  //     if (ReturnCode.isSuccess(returnCode)) {
  //       debugPrint("Frames extracted successfully.");
  //     } else {
  //       debugPrint("FFmpeg failed with return code $returnCode");
  //     }
  //   });

  // Collect output frames
  // session.getOutput().then((output) {
  //   if (output != null) {
  //     frames.add(Uint8List.fromList(output.codeUnits));
  //   }
  // });

  // return frames;
  // }

  @override
  void dispose() {
    camcontroller.dispose();
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
                ToggleButtons(
                  constraints: BoxConstraints(minWidth: sizeWidth / 6),
                  selectedColor: Colors.white,
                  fillColor: Color.fromRGBO(140, 58, 207, 1),
                  borderWidth: 2,
                  borderRadius: BorderRadius.circular(15.0),
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < isSelectedLeft.length; i++) {
                        isSelectedLeft[i] =
                            (i == index); // Ensure only one is selected
                      }
                    });
                  },
                  isSelected: isSelectedLeft,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(sizeWidth * sizeHeight * 0.00002),
                      child: Text(
                        "Text",
                        style: GoogleFonts.inter(fontSize: sizeHeight / 65),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(sizeWidth * sizeHeight * 0.00002),
                      child: Text(
                        "Audio",
                        style: GoogleFonts.inter(fontSize: sizeHeight / 65),
                      ),
                    ),
                  ],
                ),
                //! OUTPUT FOR THE CONVERTED
                Container(
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
                  child:
                      isSelectedLeft[0]
                          ? SingleChildScrollView(
                            child: Text(
                              "hello i am very happy today and you are very beautiful",
                              style: GoogleFonts.inter(),
                            ),
                          )
                          : Icon(Icons.audiotrack_rounded),
                ),
                Expanded(
                  child:
                      _isCameraInitialized && _isCameraEnabled
                          ? CameraPreview(camcontroller)
                          : Center(
                            child: Text(
                              _isCameraEnabled
                                  ? "Loading Camera..."
                                  : "Camera Disabled",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
                ToggleButtons(
                  constraints: BoxConstraints(minWidth: sizeWidth / 6),
                  selectedColor: Colors.white,
                  fillColor: Color.fromRGBO(140, 58, 207, 1),
                  borderWidth: 2,
                  borderRadius: BorderRadius.circular(15.0),
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < isSelectedRight.length; i++) {
                        isSelectedRight[i] =
                            (i == index); // Ensure only one is selected
                      }
                    });
                  },
                  isSelected: isSelectedRight,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(sizeWidth * sizeHeight * 0.00002),
                      child: Text(
                        "Text",
                        style: GoogleFonts.inter(fontSize: sizeHeight / 65),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(sizeWidth * sizeHeight * 0.00002),
                      child: Text(
                        "Avatar",
                        style: GoogleFonts.inter(fontSize: sizeHeight / 65),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: sizeHeight / 1.6),
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

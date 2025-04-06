import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';

class CameraHelper {
  static Future<CameraController?> setUpCamera(
    List<CameraDescription> cameras,
    int camIndex,
    Function onInitialized,
  ) async {
    if (cameras.isNotEmpty) {
      try {
        CameraController camController = CameraController(
          cameras[camIndex],
          ResolutionPreset.ultraHigh,
        );
        await camController.initialize();
        onInitialized(camController); // Callback to update the state
        return camController;
      } catch (e) {
        if (e is CameraException) {
          log('Camera error: ${e.code}');
        }
        return null;
      }
    }
    return null;
  }

  static void switchCamera(
    List<CameraDescription> cameras,
    int currentIndex,
    Function onSwitch,
  ) {
    if (cameras.length < 2) return;
    int newIndex = (currentIndex + 1) % cameras.length;
    onSwitch(newIndex); // Callback to update the state
  }

  static Future<void> startVideoRecording(
    CameraController camController,
    Function onStart,
  ) async {
    if (!camController.value.isInitialized ||
        camController.value.isRecordingVideo) {
      return;
    }

    try {
      await camController.startVideoRecording();
      onStart(); // Callback to update the state
    } catch (e) {
      log('Error starting video recording: $e');
    }
  }

  static Future<void> stopVideoRecording(
    CameraController camController,
    Function onStop,
  ) async {
    if (!camController.value.isRecordingVideo) return;

    try {
      XFile videoFile = await camController.stopVideoRecording();
      onStop(videoFile); // Callback to update the state with the video file
    } catch (e) {
      log('Error stopping video recording: $e');
    }
  }

  static void toggleCamera(bool isCameraEnabled, Function onToggle) {
    onToggle(!isCameraEnabled); // Callback to toggle the camera state
  }
}

class CameraPreviewComponent extends StatelessWidget {
  final CameraController? camcontroller;
  final bool isCameraInitialized;
  final bool isCameraEnabled;

  const CameraPreviewComponent({
    Key? key,
    required this.camcontroller,
    required this.isCameraInitialized,
    required this.isCameraEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.height / 55,
      ),
      height: MediaQuery.of(context).size.height / 3.5,
      width: MediaQuery.of(context).size.width / 1.2,
      child:
          isCameraInitialized && isCameraEnabled
              ? CameraPreview(camcontroller!)
              : Center(
                child: Text(
                  isCameraEnabled ? "Loading Camera..." : "Camera Disabled",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
    );
  }
}

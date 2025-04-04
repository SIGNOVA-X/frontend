import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';

Future<String> videoToText() async {
  try {
    final url = Uri.parse(
      'https://b90d-117-219-22-193.ngrok-free.app/predict-all-images',
    );
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      if (responseBody['predictions'] != null &&
          responseBody['predictions'] is List) {
        String predictionsText = "";
        for (var item in responseBody['predictions']) {
          if (item['result'] != null && item['result']['prediction'] != null) {
            predictionsText +=
                "${item['result']['prediction']} "; // Append each prediction
          }
        }
        return predictionsText.trim(); // Return concatenated predictions
      } else {
        return "No valid predictions found.";
      }
    } else {
      final responseBody = jsonDecode(response.body);
      return "Error: ${responseBody['error'] ?? 'Failed to process video'}"; // Return error message
    }
  } catch (e) {
    return "Error: $e"; // Return exception message
  }
}

Future<String> sendVideoToBackend(XFile videoFile) async {
  try {
    final url = Uri.parse(
      'https://b90d-117-219-22-193.ngrok-free.app/convert-image',
    ); // Backend endpoint
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('video', videoFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      String s =
          await videoToText(); // Call videoToText after successful video processing
      log("video processed successfully");
      return s;
    } else {
      final responseBody = await response.stream.bytesToString();
      return "Failed to process video. Status code: ${response.statusCode}. Error details: $responseBody";
    }
  } catch (e) {
    return "Error sending video to backend: $e";
  }
}

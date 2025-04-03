import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';

Future<String> videoToText() async {
  try {
    final url = Uri.parse('https://01b0-2409-40e3-6b-7b21-7839-ba83-844d-f248.ngrok-free.app/predict-all-images');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      if (responseBody['predictions'] != null && responseBody['predictions'] is List) {
        String predictionsText = "";
        for (var item in responseBody['predictions']) {
          if (item['result'] != null && item['result']['prediction'] != null) {
            predictionsText += "${item['result']['prediction']} "; // Append each prediction
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
    final url = Uri.parse('https://01b0-2409-40e3-6b-7b21-7839-ba83-844d-f248.ngrok-free.app/convert-image'); // Backend endpoint
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('video', videoFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      await videoToText(); // Call videoToText after successful video processing
      return "Video processed successfully.";
    } else {
      final responseBody = await response.stream.bytesToString();
      return "Failed to process video. Status code: ${response.statusCode}. Error details: $responseBody";
    }
  } catch (e) {
    return "Error sending video to backend: $e";
  }
}

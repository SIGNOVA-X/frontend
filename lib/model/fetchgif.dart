import 'dart:convert';
import 'package:http/http.dart' as http;

class GifFetcher {
  static Future<String?> fetchGifUrl(String text) async {
    try {
      String apiUrl = 'https://01b0-2409-40e3-6b-7b21-7839-ba83-844d-f248.ngrok-free.app/translate';
      var body = {"text": text};
      var headers = {"Content-Type": "application/json"};

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return 'https://ipfs.io/ipfs/${data['IpfsHash']}'; // Return the GIF URL
      } else {
        print('Failed to fetch GIF URL: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching GIF URL: $e');
      return null;
    }
  }
}

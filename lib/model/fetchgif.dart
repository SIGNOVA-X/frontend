import 'dart:convert';
import 'package:http/http.dart' as http;

class GifFetcher {
  static Future<String?> fetchGifUrl(String text) async {
    try {
      String apiUrl = 'https://b90d-117-219-22-193.ngrok-free.app/translate';
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

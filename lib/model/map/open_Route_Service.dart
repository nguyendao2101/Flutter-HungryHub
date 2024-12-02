import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenRouteService {
  final String apiKey = '5b3ce3597851110001cf6248b33d75a4401a4482b62888d38a524ea4'; // Thay bằng API Key của bạn
  final String baseUrl = 'https://api.openrouteservice.org/v2/directions/driving-car';

  Future<Map<String, dynamic>> getRoute(
      double startLat, double startLon, double endLat, double endLon) async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "coordinates": [
            [startLon, startLat], // Vị trí xuất phát
            [endLon, endLat],     // Vị trí đích
          ],
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load route: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching route: $e');
    }
  }
}

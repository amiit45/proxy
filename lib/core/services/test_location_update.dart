import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<void> updateLocation(String token, double latitude, double longitude) async {
    final url = Uri.parse(baseUrl + '/api/location'); // Correct URI construction
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'latitude': latitude,
        'longitude': longitude,
      }),
    );
    if (response.statusCode != 200) {
      print('Failed to update location: ${response.statusCode} - ${response.body}');
    } else {
      print('Location updated successfully: ($latitude, $longitude)');
    }
  }
}

Future<void> main() async {
  // TODO: Replace with your backend base URL
  final baseUrl = 'http://192.168.1.4:8080';

  // TODO: Replace with a valid token for testing
  final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDYwODIwMjcsInVzZXJJZCI6ImNiNGRiZGEyLTFhYmMtNDA2ZS1iNzNmLTM0YjQ1ZjZhM2ZmMyJ9.5etvb1Tw2gkyZVzY2N6ffGXpiyfmIQnUITGz_oqEqhc';

  // Test coordinates (example)
  final latitude = 18.3988999;
  final longitude = 76.5588976;

  final apiService = ApiService(baseUrl);

  print('Sending test location update...');
  await apiService.updateLocation(token, latitude, longitude);
  print('Test location update completed.');
}

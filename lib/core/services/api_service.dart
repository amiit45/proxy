import 'dart:convert';
import 'package:http/http.dart' as http;
import '/core/models/nearby_user.dart';
import '/core/models/connection_request.dart';
import '/core/models/auth_result.dart';
import '/core/constants/api_constants.dart';

class ApiService {
  Future<List<NearbyUser>> getNearbyUsers(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/nearby'),
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['nearby_users'] as List)
          .map((user) => NearbyUser.fromJson(user))
          .toList();
    } else {
      throw Exception('Failed to fetch nearby users');
    }
  }

  Future<List<ConnectionRequest>> getPendingRequests(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/requests'),
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['requests'] as List)
          .map((req) => ConnectionRequest.fromJson(req))
          .toList();
    } else {
      throw Exception('Failed to fetch pending requests');
    }
  }

  Future<AuthResult?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AuthResult(
        token: data['token'],
        userId: data['userId'],
      );
    }
    return null;
  }

  Future<AuthResult?> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AuthResult(
        token: data['token'],
        userId: data['userId'],
      );
    }
    return null;
  }

  Future<void> updateLocation(String token, double latitude, double longitude) async {
    await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/location'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode({
        'latitude': latitude,
        'longitude': longitude,
      }),
    );
  }

  Future<void> sendConnectionRequest(String token, String receiverId) async {
    await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/request'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode({
        'receiver_id': receiverId,
      }),
    );
  }

  Future<void> respondToRequest(String token, String requestId, bool accept) async {
    await http.put(
      Uri.parse('${ApiConstants.baseUrl}/api/request/$requestId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode({
        'accept': accept,
      }),
    );
  }
}
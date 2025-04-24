import 'package:flutter/material.dart';
import 'dart:async';
import '/core/models/nearby_user.dart';
import '/core/models/connection_request.dart';
import '/core/services/auth_service.dart';
import '/core/services/location_service.dart';
import '/core/services/api_service.dart';
import '/core/services/chat_service.dart';

class AppState extends ChangeNotifier {
  final AuthService _authService;
  final LocationService _locationService;
  final ApiService _apiService;
  final ChatService _chatService;

  String _token = '';
  String _userId = '';
  bool _isLoggedIn = false;
  List<NearbyUser> _nearbyUsers = [];
  List<ConnectionRequest> _pendingRequests = [];
  Timer? _nearbyUsersTimer;

  AppState(this._authService, this._locationService, this._apiService, this._chatService) {
    _initialize();
  }

  String get token => _token;
  String get userId => _userId;
  bool get isLoggedIn => _isLoggedIn;
  List<NearbyUser> get nearbyUsers => _nearbyUsers;
  List<ConnectionRequest> get pendingRequests => _pendingRequests;

  Future<void> _initialize() async {
    await _locationService.initialize();
  }

  Future<void> startNearbyUsersPolling() async {
    // Stop any existing timer
    _nearbyUsersTimer?.cancel();

    // Start new polling
    _nearbyUsersTimer = Timer.periodic(Duration(seconds: 30), (_) async {
      await fetchNearbyUsers();
      await fetchPendingRequests();
    });

    // Fetch immediately
    await fetchNearbyUsers();
    await fetchPendingRequests();
  }

  Future<void> fetchNearbyUsers() async {
    try {
      print('Fetching nearby users...');
      final users = await _apiService.getNearbyUsers(_token);
      print('Nearby users fetched: ${users.length}');
      _nearbyUsers = users;
      notifyListeners();
    } catch (e) {
      print('Failed to fetch nearby users: $e');
    }
  }

  Future<void> fetchPendingRequests() async {
    try {
      final requests = await _apiService.getPendingRequests(_token);
      _pendingRequests = requests;
      notifyListeners();
    } catch (e) {
      print('Failed to fetch pending requests: $e');
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final authResult = await _authService.login(username, password);
      if (authResult != null) {
        _token = authResult.token;
        _userId = authResult.userId;
        _isLoggedIn = true;

        // Update location on server
        await _updateLocationOnServer();

        // Start polling for nearby users
        await startNearbyUsersPolling();

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Login failed: $e');
      return false;
    }
  }

  Future<bool> register(String username, String password) async {
    try {
      final authResult = await _authService.register(username, password);
      if (authResult != null) {
        _token = authResult.token;
        _userId = authResult.userId;
        _isLoggedIn = true;

        // Update location on server
        await _updateLocationOnServer();

        // Start polling for nearby users
        await startNearbyUsersPolling();

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Registration failed: $e');
      return false;
    }
  }

  Future<void> _updateLocationOnServer() async {
    final location = await _locationService.getCurrentLocation();
    if (location != null) {
      print('Updating location on server: (${location.latitude}, ${location.longitude})');
      await _apiService.updateLocation(
          _token,
          location.latitude!,
          location.longitude!
      );
    } else {
      print('Location is null, not updating server');
    }
  }

  Future<void> sendConnectionRequest(String receiverId) async {
    try {
      await _apiService.sendConnectionRequest(_token, receiverId);
      notifyListeners();
    } catch (e) {
      print('Failed to send request: $e');
    }
  }

  Future<void> respondToRequest(String requestId, bool accept) async {
    try {
      await _apiService.respondToRequest(_token, requestId, accept);
      await fetchPendingRequests();
    } catch (e) {
      print('Failed to respond to request: $e');
    }
  }

  void logout() {
    _token = '';
    _userId = '';
    _isLoggedIn = false;
    _nearbyUsers = [];
    _pendingRequests = [];
    _nearbyUsersTimer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _nearbyUsersTimer?.cancel();
    _locationService.dispose();
    super.dispose();
  }
}
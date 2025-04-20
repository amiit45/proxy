import '/core/models/auth_result.dart';
import '/core/services/api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  Future<AuthResult?> login(String username, String password) async {
    return await _apiService.login(username, password);
  }

  Future<AuthResult?> register(String username, String password) async {
    return await _apiService.register(username, password);
  }
}
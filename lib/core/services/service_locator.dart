import 'package:get_it/get_it.dart';
import '/core/providers/app_state.dart';
import '/core/services/api_service.dart';
import '/core/services/auth_service.dart';
import '/core/services/chat_service.dart';
import 'location_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Services
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<LocationService>(() => LocationService());
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<ApiService>()));
  getIt.registerLazySingleton<ChatService>(() => ChatService(getIt<ApiService>()));

  // Providers
  getIt.registerLazySingleton<AppState>(() => AppState(
    getIt<AuthService>(),
    getIt<LocationService>(),
    getIt<ApiService>(),
    getIt<ChatService>(),
  ));
}
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  const AppConfig({
    required this.backendBaseUrl,
    required this.websocketUrl,
  });

  final Uri backendBaseUrl;
  final Uri websocketUrl;

  static const String _backendUrlKey = 'BACKEND_BASE_URL';
  static const String _websocketUrlKey = 'WEBSOCKET_URL';

  static const AppConfig fallback = AppConfig(
    backendBaseUrl: Uri(scheme: 'http', host: 'localhost', port: 8000),
    websocketUrl: Uri(scheme: 'ws', host: 'localhost', port: 8000, path: 'ws'),
  );

  static Future<AppConfig> load({String? envFileName}) async {
    await _ensureEnvLoaded(envFileName);

    return AppConfig(
      backendBaseUrl: _resolveUri(
        key: _backendUrlKey,
        fallback: fallback.backendBaseUrl,
      ),
      websocketUrl: _resolveUri(
        key: _websocketUrlKey,
        fallback: fallback.websocketUrl,
      ),
    );
  }

  static Future<void> _ensureEnvLoaded(String? envFileName) async {
    if (dotenv.isInitialized) {
      return;
    }

    final fileName = envFileName ?? '.env';
    await dotenv.load(fileName: fileName, isOptional: true);
  }

  static Uri _resolveUri({
    required String key,
    required Uri fallback,
  }) {
    final compileTimeValue = String.fromEnvironment(key);
    if (compileTimeValue.isNotEmpty) {
      return Uri.parse(compileTimeValue);
    }

    final envValue = dotenv.maybeGet(key);
    if (envValue != null && envValue.isNotEmpty) {
      return Uri.parse(envValue);
    }

    if (kDebugMode) {
      debugPrint('Using fallback value for $key: $fallback');
    }
    return fallback;
  }
}

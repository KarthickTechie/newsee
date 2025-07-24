import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeyProvider {
  static String? _googleMapsApiKey;

  // Load the API key from the .env file
  static Future<void> initApiKey() async {
    await dotenv.load(fileName: ".env");
    _googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (_googleMapsApiKey == null || _googleMapsApiKey!.isEmpty) {
      throw Exception('Google Maps API key not found in .env file');
    }
  }

  // Getter for the API key
  static String? get googleMapsApiKey => _googleMapsApiKey;
}

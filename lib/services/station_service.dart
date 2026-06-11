import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/station_model.dart';
import '../models/fuel_type_model.dart';
import 'auth_service.dart';

class StationService {
  // Use the API base URL without the /auth suffix
  static String get baseUrl => AuthService.baseUrl.replaceAll('/auth', '');

  // Endpoints for stations
  static String get stationsEndpoint => "$baseUrl/stations/";

  final AuthService _authService = AuthService();

  Future<Map<String, String>> get _headers async {
    final token = await _authService.getAccessToken();
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  // Safe JSON decode helper
  dynamic _safeJsonDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return {"message": body};
    }
  }

  // Fetch all fuel stations
  Future<List<FuelStation>> getStations() async {
    try {
      final headers = await _headers;
      final response = await http
          .get(Uri.parse(stationsEndpoint), headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = _safeJsonDecode(response.body);
        
        // Handle different JSON structures (e.g., paginated 'results' vs plain list)
        List<dynamic> items = [];
        if (data is List) {
          items = data;
        } else if (data is Map && data.containsKey('results')) {
          items = data['results'];
        } else if (data is Map && data.containsKey('data')) {
          items = data['data'];
        }

        return items.map((json) => FuelStation.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load stations: ${response.statusCode}");
      }
    } catch (e) {
      // Return empty list or throw depending on how UI handles it
      print("Error fetching stations: $e");
      return [];
    }
  }



  // Fetch a specific station by ID
  Future<FuelStation?> getStationById(String id) async {
    try {
      final headers = await _headers;
      final response = await http
          .get(Uri.parse("$stationsEndpoint$id/"), headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = _safeJsonDecode(response.body);
        return FuelStation.fromJson(data);
      }
      return null;
    } catch (e) {
      print("Error fetching station $id: $e");
      return null;
    }
  }
}

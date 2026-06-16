import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/station_model.dart';
import 'auth_service.dart';

class StationService {
  final AuthService _auth = AuthService();
  
  Future<Map<String, dynamic>> getStations({
    String? search,
    String? status,
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final token = await _auth.getAccessToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }
      
      final queryParams = [];
      if (search != null) queryParams.add('search=$search');
      if (status != null) queryParams.add('status=$status');
      queryParams.add('limit=$limit');
      queryParams.add('offset=$offset');
      
      final url = 'http://127.0.0.1:8000/api/stations/manage/?${queryParams.join('&')}';
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'data': data['data'],
          'stations': (data['data']['stations'] as List)
              .map((s) => StationModel.fromJson(s))
              .toList(),
        };
      }
      
      return {'success': false, 'message': data['message'] ?? 'Failed to load stations'};
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
  
  Future<Map<String, dynamic>> createStation(StationModel station) async {
    try {
      final token = await _auth.getAccessToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }
      
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/stations/manage/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(station.toJson()),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 201 && data['success'] == true) {
        return {
          'success': true,
          'message': data['message'],
          'data': StationModel.fromJson(data['data']),
        };
      }
      
      return {'success': false, 'message': data['message'] ?? 'Failed to create station'};
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
  
  Future<Map<String, dynamic>> updateStation(StationModel station) async {
    try {
      final token = await _auth.getAccessToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }
      
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/api/stations/manage/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(station.toJson()),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'message': data['message'],
          'data': StationModel.fromJson(data['data']),
        };
      }
      
      return {'success': false, 'message': data['message'] ?? 'Failed to update station'};
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
  
  Future<Map<String, dynamic>> deleteStation(int stationId) async {
    try {
      final token = await _auth.getAccessToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }
      
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/stations/manage/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'id': stationId}),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'message': data['message']};
      }
      
      return {'success': false, 'message': data['message'] ?? 'Failed to delete station'};
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
}
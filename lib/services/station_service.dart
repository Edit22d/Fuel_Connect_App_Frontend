// lib/services/station_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/station_model.dart';
import '../config/api_config.dart';

class StationService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<Map<String, dynamic>> getStations({
    String? search,
    String? status,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (status != null && status != 'all') queryParams['status'] = status;
      queryParams['limit'] = limit.toString();
      queryParams['offset'] = offset.toString();

      final uri = Uri.parse('${ApiConfig.stationsEndpoint}').replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final stationsList = data['data']['stations'] as List;
          final stations = stationsList
              .map((station) => StationModel.fromJson(station))
              .toList();
          return {
            'success': true,
            'stations': stations,
            'total': data['data']['total'] ?? 0,
          };
        }
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to load stations',
        };
      }
      return {
        'success': false,
        'message': 'Server error: ${response.statusCode}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getTopStations() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.topStationsEndpoint),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final stationsList = data['data'] as List;
          final stations = stationsList
              .map((station) => StationModel.fromJson(station))
              .toList();
          return {
            'success': true,
            'stations': stations,
          };
        }
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to load top stations',
        };
      }
      return {
        'success': false,
        'message': 'Server error: ${response.statusCode}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getStationDetail(int stationId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.stationsEndpoint}$stationId/'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final station = StationModel.fromJson(data['data']);
          return {
            'success': true,
            'station': station,
          };
        }
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to load station details',
        };
      }
      return {
        'success': false,
        'message': 'Server error: ${response.statusCode}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> createStation(StationModel station) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.stationsManageEndpoint),
        headers: await _getHeaders(),
        body: json.encode(station.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Station created successfully',
          'station': data['data'] != null
              ? StationModel.fromJson(data['data'])
              : null,
        };
      }
      final error = json.decode(response.body);
      return {
        'success': false,
        'message': error['message'] ?? 'Failed to create station',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> updateStation(StationModel station) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConfig.stationsManageEndpoint),
        headers: await _getHeaders(),
        body: json.encode(station.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Station updated successfully',
          'station': data['data'] != null
              ? StationModel.fromJson(data['data'])
              : null,
        };
      }
      final error = json.decode(response.body);
      return {
        'success': false,
        'message': error['message'] ?? 'Failed to update station',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> deleteStation(String stationId) async {
    try {
      final response = await http.delete(
        Uri.parse(ApiConfig.stationsManageEndpoint),
        headers: await _getHeaders(),
        body: json.encode({'id': stationId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Station deleted successfully',
        };
      }
      final error = json.decode(response.body);
      return {
        'success': false,
        'message': error['message'] ?? 'Failed to delete station',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
}
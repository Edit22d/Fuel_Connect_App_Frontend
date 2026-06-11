import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';
import 'auth_service.dart';

class OrderService {
  static String get baseUrl => AuthService.baseUrl.replaceAll('/auth', '');
  static String get ordersEndpoint => "$baseUrl/orders/";

  final AuthService _authService = AuthService();

  Future<Map<String, String>> get _headers async {
    final token = await _authService.getAccessToken();
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  dynamic _safeJsonDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return {"message": body};
    }
  }

  // Fetch all orders for the current logged-in user
  Future<List<OrderModel>> getOrders() async {
    try {
      final headers = await _headers;
      final response = await http
          .get(Uri.parse(ordersEndpoint), headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = _safeJsonDecode(response.body);
        
        List<dynamic> items = [];
        if (data is List) {
          items = data;
        } else if (data is Map && data.containsKey('results')) {
          items = data['results'];
        }

        return items.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load orders: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }

  // Create a new order
  Future<Map<String, dynamic>> createOrder({
    required int stationId,
    required String fuelType,
    required double quantity,
  }) async {
    try {
      final headers = await _headers;
      final body = jsonEncode({
        "station": stationId,
        "fuel_type": fuelType,
        "quantity": quantity,
        "quantity_unit": "Liters",
      });

      final response = await http
          .post(Uri.parse(ordersEndpoint), headers: headers, body: body)
          .timeout(const Duration(seconds: 15));

      final data = _safeJsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "order": OrderModel.fromJson(data),
        };
      }

      return {
        "success": false,
        "message": data['detail'] ?? "Failed to create order.",
      };
    } catch (e) {
      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
}

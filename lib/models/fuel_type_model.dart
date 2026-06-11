import 'package:flutter/material.dart';

class FuelType {
  final String id;
  final String name;
  final String icon;
  final Color color;

  const FuelType({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  factory FuelType.fromJson(Map<String, dynamic> json) {
    // Parse color hex if provided from backend, fallback to default orange
    Color parseColor(String? hexString) {
      if (hexString == null || hexString.isEmpty) return const Color(0xFFFF8C00);
      try {
        hexString = hexString.replaceAll('#', '');
        if (hexString.length == 6) {
          hexString = 'FF$hexString'; // Add opacity if missing
        }
        return Color(int.parse(hexString, radix: 16));
      } catch (e) {
        return const Color(0xFFFF8C00); // Default color on parse failure
      }
    }

    return FuelType(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown',
      icon: json['icon'] ?? '⛽',
      color: parseColor(json['color']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}', // Exclude alpha for simple hex
    };
  }
}

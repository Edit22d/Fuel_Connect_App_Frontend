// lib/models/station_model.dart
class StationModel {
  final String? id;
  final String name;
  final String location;
  final String address;
  final double? latitude;
  final double? longitude;
  final double rating;
  final int reviewsCount;
  final String? image;
  final bool isOpen;
  final bool is24_7;
  final double pricePerGallon;
  final String fuelTypes;
  final String? phone;
  final String? email;
  final String? createdAt;
  final String? updatedAt;

  StationModel({
    this.id,
    required this.name,
    required this.location,
    required this.address,
    this.latitude,
    this.longitude,
    this.rating = 4.0,
    this.reviewsCount = 0,
    this.image,
    this.isOpen = true,
    this.is24_7 = false,
    this.pricePerGallon = 3.60,
    this.fuelTypes = 'Petrol,Diesel,Gas',
    this.phone,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude'] != null ? double.parse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.parse(json['longitude'].toString()) : null,
      rating: json['rating'] != null ? double.parse(json['rating'].toString()) : 4.0,
      reviewsCount: json['reviews_count'] ?? 0,
      image: json['image'],
      isOpen: json['is_open'] ?? true,
      is24_7: json['is_24_7'] ?? false,
      pricePerGallon: json['price_per_gallon'] != null 
          ? double.parse(json['price_per_gallon'].toString()) 
          : 3.60,
      fuelTypes: json['fuel_types'] ?? 'Petrol,Diesel,Gas',
      phone: json['phone'],
      email: json['email'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'reviews_count': reviewsCount,
      'image': image,
      'is_open': isOpen,
      'is_24_7': is24_7,
      'price_per_gallon': pricePerGallon,
      'fuel_types': fuelTypes,
      'phone': phone,
      'email': email,
    };
  }

  StationModel copyWith({
    String? id,
    String? name,
    String? location,
    String? address,
    double? latitude,
    double? longitude,
    double? rating,
    int? reviewsCount,
    String? image,
    bool? isOpen,
    bool? is24_7,
    double? pricePerGallon,
    String? fuelTypes,
    String? phone,
    String? email,
  }) {
    return StationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      image: image ?? this.image,
      isOpen: isOpen ?? this.isOpen,
      is24_7: is24_7 ?? this.is24_7,
      pricePerGallon: pricePerGallon ?? this.pricePerGallon,
      fuelTypes: fuelTypes ?? this.fuelTypes,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }
}
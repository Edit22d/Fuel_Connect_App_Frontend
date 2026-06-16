class StationModel {
  final int? id;
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
  final List<FuelPrice>? prices;
  
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
    this.prices,
  });
  
  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      id: json['id'],
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
      pricePerGallon: json['price_per_gallon'] != null ? double.parse(json['price_per_gallon'].toString()) : 3.60,
      fuelTypes: json['fuel_types'] ?? 'Petrol,Diesel,Gas',
      prices: json['prices'] != null
          ? (json['prices'] as List).map((p) => FuelPrice.fromJson(p)).toList()
          : null,
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
      'prices': prices?.map((p) => p.toJson()).toList(),
    };
  }
}

class FuelPrice {
  final int? id;
  final String fuelType;
  final double price;
  final String? updatedAt;
  
  FuelPrice({
    this.id,
    required this.fuelType,
    required this.price,
    this.updatedAt,
  });
  
  factory FuelPrice.fromJson(Map<String, dynamic> json) {
    return FuelPrice(
      id: json['id'],
      fuelType: json['fuel_type'] ?? 'petrol',
      price: json['price'] != null ? double.parse(json['price'].toString()) : 0,
      updatedAt: json['updated_at'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fuel_type': fuelType,
      'price': price,
      'updated_at': updatedAt,
    };
  }
}
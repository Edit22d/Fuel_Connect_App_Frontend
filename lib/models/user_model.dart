class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? companyName;
  final int fleetSize;
  final bool isEmailVerified;
  final String authProvider;
  final String? userType;
  final String? location;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.companyName,
    this.fleetSize = 0,
    this.isEmailVerified = false,
    this.authProvider = 'email',
    this.userType,
    this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:              json['id'] ?? 0,
      fullName:        json['full_name'] ?? '',
      email:           json['email'] ?? '',
      phoneNumber:     json['phone_number'],
      companyName:     json['company_name'],
      fleetSize:       json['fleet_size'] ?? 0,
      isEmailVerified: json['is_email_verified'] ?? false,
      authProvider:    json['auth_provider'] ?? 'email',
      userType:        json['user_type'],
      location:        json['location'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id':               id,
    'full_name':        fullName,
    'email':            email,
    'phone_number':     phoneNumber,
    'company_name':     companyName,
    'fleet_size':       fleetSize,
    'is_email_verified': isEmailVerified,
    'auth_provider':    authProvider,
    'user_type':        userType,
    'location':         location,
  };
}
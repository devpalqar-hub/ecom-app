class ProfileResponse {
  final bool success;
  final UserProfile data;

  ProfileResponse({
    required this.success,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? false,
      data: UserProfile.fromJson(json['data']),
    );
  }
}


class UserProfile {
  final String id;
  final String email;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CustomerProfile customerProfile;

  UserProfile({
    required this.id,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.customerProfile,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      customerProfile:
          CustomerProfile.fromJson(json['CustomerProfile'] ?? {}),
    );
  }
}



class CustomerProfile {
  final String? name;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? phone;
  final String? profilePicture;
  final List<Address> addresses;

  CustomerProfile({
    this.name,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.phone,
    this.profilePicture,
    required this.addresses,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      name: json['name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postalCode'],
      phone: json['phone'],
      profilePicture: json['profilePicture'],
      addresses: (json['addresses'] as List? ?? [])
          .map((e) => Address.fromJson(e))
          .toList(),
    );
  }
}



class Address {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String phone;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  Address({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.phone,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
      phone: json['phone'] ?? '',
      isDefault: json['isDefault'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

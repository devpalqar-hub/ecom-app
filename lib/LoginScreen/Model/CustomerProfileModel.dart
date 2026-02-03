class CustomerProfile {
  final String id;
  final String email;
  final String role;
  final String createdAt;
  final String updatedAt;
  final CustomerProfileData profile;

  CustomerProfile({
    required this.id,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.profile,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      id: json["id"] ?? "",
      email: json["email"] ?? "",
      role: json["role"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      profile: CustomerProfileData.fromJson(json["CustomerProfile"] ?? {}),
    );
  }
}

class CustomerProfileData {
  final String name;
  final String address;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String phone;
  final String? profilePicture;

  CustomerProfileData({
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.phone,
    this.profilePicture,
  });

  factory CustomerProfileData.fromJson(Map<String, dynamic> json) {
    return CustomerProfileData(
      name: json["name"] ?? "",
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      country: json["country"] ?? "",
      postalCode: json["postalCode"] ?? "",
      phone: json["phone"] ?? "",
      profilePicture: json["profilePicture"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "address": address,
      "city": city,
      "state": state,
      "country": country,
      "postalCode": postalCode,
      "phone": phone,
      "profilePicture": profilePicture,
    };
  }
}

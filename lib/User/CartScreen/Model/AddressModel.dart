class AddressModel {
  final String id;
  final String customerProfileId;
  final String name;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String landmark;
  final String phone;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.customerProfileId,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.landmark,
    required this.phone,
    required this.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? "",
      customerProfileId: json['customerProfileId'] ?? "",
      name: json['name'] ?? "",
      address: json['address'] ?? "",
      city: json['city'] ?? "",
      state: json['state'] ?? "",
      postalCode: json['postalCode'] ?? "",
      country: json['country'] ?? "",
      landmark: json['landmark'] ?? "",
      phone: json['phone'] ?? "",
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "customerProfileId": customerProfileId,
      "name": name,
      "address": address,
      "city": city,
      "state": state,
      "postalCode": postalCode,
      "country": country,
      "landmark": landmark,
      "phone": phone,
      "isDefault": isDefault,
    };
  }
}

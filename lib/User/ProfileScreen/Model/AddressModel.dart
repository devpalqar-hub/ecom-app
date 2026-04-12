class AddressModel {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String phone;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.phone,
    required this.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      country: json['country'],
      phone: json['phone'],
      isDefault: json['isDefault'] ?? false,
    );
  }
}

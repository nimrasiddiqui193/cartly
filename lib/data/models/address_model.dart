class AddressModel {
  final String id;
  final String fullName;
  final String phone;
  final String streetAddress;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String? additionalDetails;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.additionalDetails,
    this.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      streetAddress: json['streetAddress']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      postalCode: json['postalCode']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      additionalDetails: json['additionalDetails']?.toString(),
      isDefault: json['isDefault'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phone': phone,
      'streetAddress': streetAddress,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'additionalDetails': additionalDetails,
      'isDefault': isDefault,
    };
  }

  String get formattedAddress {
    return [
      streetAddress,
      city,
      state,
      postalCode,
      country,
    ].where((part) => part.trim().isNotEmpty).join(', ');
  }

  AddressModel copyWith({
    String? fullName,
    String? phone,
    String? streetAddress,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? additionalDetails,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      additionalDetails: additionalDetails ?? this.additionalDetails,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

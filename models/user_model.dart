enum UserType { buyer, nursery }

class User {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String? address;
  final UserType userType;
  final String? nurseryName;
  final String? nurseryDescription;
  final String? profileImage;
  final List<String> favorites;
  final List<String> myPlants; // Si se pepinyè

  User({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.address,
    required this.userType,
    this.nurseryName,
    this.nurseryDescription,
    this.profileImage,
    this.favorites = const [],
    this.myPlants = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'],
      address: json['address'],
      userType: json['userType'] == 'nursery'
          ? UserType.nursery
          : UserType.buyer,
      nurseryName: json['nurseryName'],
      nurseryDescription: json['nurseryDescription'],
      profileImage: json['profileImage'],
      favorites: List<String>.from(json['favorites'] ?? []),
      myPlants: List<String>.from(json['myPlants'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'userType': userType == UserType.nursery ? 'nursery' : 'buyer',
      'nurseryName': nurseryName,
      'nurseryDescription': nurseryDescription,
      'profileImage': profileImage,
      'favorites': favorites,
      'myPlants': myPlants,
    };
  }

  bool get isNursery => userType == UserType.nursery;
}

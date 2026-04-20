import 'package:orders/features/auth/data/user_role.dart';

class AppUser {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String? imageUrl;
  final UserRole role; // 🔥 جديد

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.imageUrl,
    required this.role,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      imageUrl: map['imageUrl'],
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.buyer,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
      'role': role.name,
    };
  }

  AppUser copyWith({
    String? name,
    String? phone,
    String? imageUrl,
    UserRole? role,
  }) {
    return AppUser(
      uid: uid,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      role: role ?? this.role,
    );
  }
}
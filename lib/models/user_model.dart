import 'package:uuid/uuid.dart';

class UserModel {
  String id;
  String firstName;
  String lastName;
  String email;
  String password;

  UserModel({
    String? id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  }) : id = id ?? const Uuid().v4();

  String get fullName => '$firstName $lastName';

  // Optional: Tạo từ JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
    );
  }

  // Optional: Convert thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
  }
}

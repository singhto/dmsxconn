import 'dart:convert';

class UserModel {
  final String user_id;
  final String username;
  final String staffname;
  UserModel({
    required this.user_id,
    required this.username,
    required this.staffname,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'username': username,
      'staffname': staffname,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      user_id: map['user_id'] ?? '',
      username: map['username'] ?? '',
      staffname: map['staffname'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}

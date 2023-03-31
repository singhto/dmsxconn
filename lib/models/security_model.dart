// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class SecurityModel {
  
  final String id;
  final String serial_no;
  final String notice;
  final String ca;
  final String pea_no;
  final String install_date;
  final String user_id;
  SecurityModel({
    this.id = '',
    this.serial_no = '',
    this.notice = '',
    this.ca = '',
    this.pea_no = '',
    this.install_date = '',
    this.user_id = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serial_no': serial_no,
      'notice': notice,
      'ca': ca,
      'pea_no': pea_no,
      'install_date': install_date,
      'user_id': user_id,
    };
  }

  factory SecurityModel.fromMap(Map<String, dynamic> map) {
    return SecurityModel(
      id: map['id'] ?? '',
      serial_no: map['serial_no'] ?? '',
      notice: map['notice'] ?? '',
      ca: map['ca'] ?? '',
      pea_no: map['pea_no'] ?? '',
      install_date: map['install_date'] ?? '',
      user_id: map['user_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SecurityModel.fromJson(String source) => SecurityModel.fromMap(json.decode(source));
}

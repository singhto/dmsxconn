import 'dart:convert';

class SearchDmsxModel {
  final String employeeName;
  final String cus_name;
  final String status_txt;
  final String lat;
  final String lng;
  final String latMobile;
  final String lngMobile;
  final String timestamp;
  SearchDmsxModel({
    required this.employeeName,
    required this.cus_name,
    required this.status_txt,
    required this.lat,
    required this.lng,
    required this.latMobile,
    required this.lngMobile,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'employeeName': employeeName,
      'cus_name': cus_name,
      'status_txt': status_txt,
      'lat': lat,
      'lng': lng,
      'latMobile': latMobile,
      'lngMobile': lngMobile,
      'timestamp': timestamp,
    };
  }

  factory SearchDmsxModel.fromMap(Map<String, dynamic> map) {
    return SearchDmsxModel(
      employeeName: map['employeeName'] ?? '',
      cus_name: map['cus_name'] ?? '',
      status_txt: map['status_txt'] ?? '',
      lat: map['lat'] ?? '',
      lng: map['lng'] ?? '',
      latMobile: map['latMobile'] ?? '',
      lngMobile: map['lngMobile'] ?? '',
      timestamp: map['timestamp'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchDmsxModel.fromJson(String source) => SearchDmsxModel.fromMap(json.decode(source));
}

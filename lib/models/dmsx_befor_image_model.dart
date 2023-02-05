import 'dart:convert';

class DmsxBeforImageModel {
  final String id;
  final String ca;
  final String image;
  final String dateStatus;
  final String userId;

  DmsxBeforImageModel(this.id, this.ca, this.image, this.dateStatus, this.userId);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ca': ca,
      'image': image,
      'dateStatus': dateStatus,
      'userId': userId,
    };
  }

  factory DmsxBeforImageModel.fromMap(Map<String, dynamic> map) {
    return DmsxBeforImageModel(
      map['id'] ?? '',
      map['ca'] ?? '',
      map['image'] ?? '',
      map['dateStatus'] ?? '',
      map['userId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DmsxBeforImageModel.fromJson(String source) => DmsxBeforImageModel.fromMap(json.decode(source));
}

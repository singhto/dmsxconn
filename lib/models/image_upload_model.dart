import 'dart:convert';

class ImageUploadModel {

  final String image_id;
  final String image_name;
  final String image_update;
  final String user_id;
  ImageUploadModel({
    this.image_id,
    this.image_name,
    this.image_update,
    this.user_id,
  });
  

  Map<String, dynamic> toMap() {
    return {
      'image_id': image_id,
      'image_name': image_name,
      'image_update': image_update,
      'user_id': user_id,
    };
  }

  factory ImageUploadModel.fromMap(Map<String, dynamic> map) {
    return ImageUploadModel(
      image_id: map['image_id'] ?? '',
      image_name: map['image_name'] ?? '',
      image_update: map['image_update'] ?? '',
      user_id: map['user_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageUploadModel.fromJson(String source) => ImageUploadModel.fromMap(json.decode(source));
}

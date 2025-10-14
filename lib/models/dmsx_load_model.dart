import 'dart:convert';

class DmsxLoadModel {
  
  final String id;
  final String desc;
  DmsxLoadModel({
    required this.id,
    required this.desc,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'desc': desc,
    };
  }

  factory DmsxLoadModel.fromMap(Map<String, dynamic> map) {
    return DmsxLoadModel(
      id: map['id'] ?? '',
      desc: map['desc'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DmsxLoadModel.fromJson(String source) => DmsxLoadModel.fromMap(json.decode(source));
}

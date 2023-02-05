import 'dart:convert';

class WorkTimeModel {
  final String id;
  final String dat_work;
  final String start_work;
  final String out_work;
  final String start_work_image;
  final String out_work_image;
  final String create_by;
  final String work_status;
  final String stop_work_image;
  final String remark;
  final String start_work_lat;
  final String start_work_lng;
  final String out_work_lat;
  final String out_work_lng;
  final String distance;

  WorkTimeModel(
      this.id,
      this.dat_work,
      this.start_work,
      this.out_work,
      this.start_work_image,
      this.out_work_image,
      this.create_by,
      this.work_status,
      this.stop_work_image,
      this.remark,
      this.start_work_lat,
      this.start_work_lng,
      this.out_work_lat,
      this.out_work_lng,
      this.distance);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dat_work': dat_work,
      'start_work': start_work,
      'out_work': out_work,
      'start_work_image': start_work_image,
      'out_work_image': out_work_image,
      'create_by': create_by,
      'work_status': work_status,
      'stop_work_image': stop_work_image,
      'remark': remark,
      'start_work_lat': start_work_lat,
      'start_work_lng': start_work_lng,
      'out_work_lat': out_work_lat,
      'out_work_lng': out_work_lng,
      'distance': distance,
    };
  }

  factory WorkTimeModel.fromMap(Map<String, dynamic> map) {
    return WorkTimeModel(
      map['id'] ?? '',
      map['dat_work'] ?? '',
      map['start_work'] ?? '',
      map['out_work'] ?? '',
      map['start_work_image'] ?? '',
      map['out_work_image'] ?? '',
      map['create_by'] ?? '',
      map['work_status'] ?? '',
      map['stop_work_image'] ?? '',
      map['remark'] ?? '',
      map['start_work_lat'] ?? '',
      map['start_work_lng'] ?? '',
      map['out_work_lat'] ?? '',
      map['out_work_lng'] ?? '',
      map['distance'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkTimeModel.fromJson(String source) => WorkTimeModel.fromMap(json.decode(source));
}
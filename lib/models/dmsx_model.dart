// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class Dmsxmodel {
  final String id;
  final String ca;
  final String docID;
  final String notice;
  final String employeeId;
  final String employeeName;
  final String peaNo;
  final String cusName;
  final String line;
  final String status;
  final String statusTxt;
  final String type;
  final String typeTxt;
  final String tel;
  final String address;
  final List<String> images;
  final String readNumber;
  final String lat;
  final String lng;
  final String paymentDate;
  final String dataStatus;
  final String refnoti_date;
  final String timestamp;
  final String userId;
  final String importDate;
  final String image_befor_wmmr;
  Dmsxmodel({
    required this.id,
    required this.ca,
    required this.docID,
    required this.notice,
    required this.employeeId,
    required this.employeeName,
    required this.peaNo,
    required this.cusName,
    required this.line,
    required this.status,
    required this.statusTxt,
    required this.type,
    required this.typeTxt,
    required this.tel,
    required this.address,
    required this.images,
    required this.readNumber,
    required this.lat,
    required this.lng,
    required this.paymentDate,
    required this.dataStatus,
    required this.refnoti_date,
    required this.timestamp,
    required this.userId,
    required this.importDate,
    required this.image_befor_wmmr,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ca': ca,
      'docID': docID,
      'notice': notice,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'pea_no': peaNo,
      'cus_name': cusName,
      'line': line,
      'status': status,
      'status_txt': statusTxt,
      'type': type,
      'type_txt': typeTxt,
      'tel': tel,
      'address': address,
      'images': images,
      'readNumber': readNumber,
      'lat': lat,
      'lng': lng,
      'paymentDate': paymentDate,
      'dataStatus': dataStatus,
      'refnoti_date': refnoti_date,
      'timestamp': timestamp,
      'userId': userId,
      'importDate': importDate,
      'image_befor_wmmr': image_befor_wmmr,
    };
  }

  factory Dmsxmodel.fromMap(Map<String, dynamic> map) {
    return Dmsxmodel(
      id: map['id'] ?? '',
      ca: map['ca'] ?? '',
      docID: map['docID'] ?? '',
      notice: map['notice'] ?? '',
      employeeId: map['employeeId'] ?? '',
      employeeName: map['employeeName'] ?? '',
      peaNo: map['pea_no'] ?? '',
      cusName: map['cus_name'] ?? '',
      line: map['line'] ?? '',
      status: map['status'] ?? '',
      statusTxt: map['status_txt'] ?? '',
      type: map['type'] ?? '',
      typeTxt: map['type_txt'] ?? '',
      tel: map['tel'] ?? '',
      address: map['address'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      readNumber: map['readNumber'] ?? '',
      lat: map['lat'] ?? '',
      lng: map['lng'] ?? '',
      paymentDate: map['paymentDate'] ?? '',
      dataStatus: map['dataStatus'] ?? '',
      refnoti_date: map['refnoti_date'] ?? '',
      timestamp: map['timestamp'] ?? '',
      userId: map['userId'] ?? '',
      importDate: map['importDate'] ?? '',
      image_befor_wmmr: map['image_befor_wmmr'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Dmsxmodel.fromJson(String source) =>
      Dmsxmodel.fromMap(json.decode(source));
}

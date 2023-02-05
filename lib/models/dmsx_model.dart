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
  final String invoice;
  final String arrears;
  final String images;
  final String readNumber;
  final String lat;
  final String lng;
  final String paymentDate;
  final String dataStatus;
  final String refnoti_date;
  final String timestamp;
  final String userId;
  final String importDate;
  Dmsxmodel({
    this.id,
    this.ca,
    this.docID,
    this.notice,
    this.employeeId,
    this.employeeName,
    this.peaNo,
    this.cusName,
    this.line,
    this.status,
    this.statusTxt,
    this.type,
    this.typeTxt,
    this.tel,
    this.address,
    this.invoice,
    this.arrears,
    this.images,
    this.readNumber,
    this.lat,
    this.lng,
    this.paymentDate,
    this.dataStatus,
    this.refnoti_date,
    this.timestamp,
    this.userId,
    this.importDate,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ca': ca,
      'docID': docID,
      'notice': notice,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'peaNo': peaNo,
      'cusName': cusName,
      'line': line,
      'status': status,
      'statusTxt': statusTxt,
      'type': type,
      'typeTxt': typeTxt,
      'tel': tel,
      'address': address,
      'invoice': invoice,
      'arrears': arrears,
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
      invoice: map['invoice'] ?? '',
      arrears: map['arrears'] ?? '',
      images: map['images'] ?? '',
      readNumber: map['readNumber'] ?? '',
      lat: map['lat'] ?? '',
      lng: map['lng'] ?? '',
      paymentDate: map['paymentDate'] ?? '',
      dataStatus: map['dataStatus'] ?? '',
      refnoti_date: map['refnoti_date'] ?? '',
      timestamp: map['timestamp'] ?? '',
      userId: map['user_id'] ?? '',
      importDate: map['import_date'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Dmsxmodel.fromJson(String source) => Dmsxmodel.fromMap(json.decode(source));
}

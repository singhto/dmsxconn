class InsxModel {
  String id;
  String ca;
  String peaNo;
  String cusName;
  String cusId;
  String status;
  String tel;
  String invoiceNo;
  String billDate;
  String bpNo;
  String writeId;
  String portion;
  String ptcNo;
  String address;
  String newPeriodDate;
  String writeDate;
  String total;
  String billNo;
  String lat;
  String lng;
  String invoiceStatus;
  String notiDate;
  String payDate;
  String updateDate;
  String timestamp;
  String workDate;
  String workImage;
  String workImageLat;
  String workImageLng;
  String workerCode;
  String workerName;
  String userId;
  String distance;

  InsxModel(
      {this.id,
      this.ca,
      this.peaNo,
      this.cusName,
      this.cusId,
      this.status,
      this.tel,
      this.invoiceNo,
      this.billDate,
      this.bpNo,
      this.writeId,
      this.portion,
      this.ptcNo,
      this.address,
      this.newPeriodDate,
      this.writeDate,
      this.total,
      this.billNo,
      this.lat,
      this.lng,
      this.invoiceStatus,
      this.notiDate,
      this.payDate,
      this.updateDate,
      this.timestamp,
      this.workDate,
      this.workImage,
      this.workImageLat,
      this.workImageLng,
      this.workerCode,
      this.workerName,
      this.userId,
      this.distance});

  InsxModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ca = json['ca'];
    peaNo = json['pea_no'];
    cusName = json['cus_name'];
    cusId = json['cus_id'];
    status = json['status'];
    tel = json['tel'];
    invoiceNo = json['invoice_no'];
    billDate = json['bill_date'];
    bpNo = json['bp_no'];
    writeId = json['write_id'];
    portion = json['portion'];
    ptcNo = json['ptc_no'];
    address = json['address'];
    newPeriodDate = json['new_period_date'];
    writeDate = json['write_date'];
    total = json['total'];
    billNo = json['bill_no'];
    lat = json['lat'];
    lng = json['lng'];
    invoiceStatus = json['invoice_status'];
    notiDate = json['noti_date'];
    payDate = json['pay_date'];
    updateDate = json['update_date'];
    timestamp = json['timestamp'];
    workDate = json['work_date'];
    workImage = json['work_image'];
    workImageLat = json['work_image_lat'];
    workImageLng = json['work_image_lng'];
    workerCode = json['worker_code'];
    workerName = json['worker_name'];
    userId = json['user_id'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ca'] = this.ca;
    data['pea_no'] = this.peaNo;
    data['cus_name'] = this.cusName;
    data['cus_id'] = this.cusId;
    data['status'] = this.status;
    data['tel'] = this.tel;
    data['invoice_no'] = this.invoiceNo;
    data['bill_date'] = this.billDate;
    data['bp_no'] = this.bpNo;
    data['write_id'] = this.writeId;
    data['portion'] = this.portion;
    data['ptc_no'] = this.ptcNo;
    data['address'] = this.address;
    data['new_period_date'] = this.newPeriodDate;
    data['write_date'] = this.writeDate;
    data['total'] = this.total;
    data['bill_no'] = this.billNo;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['invoice_status'] = this.invoiceStatus;
    data['noti_date'] = this.notiDate;
    data['pay_date'] = this.payDate;
    data['update_date'] = this.updateDate;
    data['timestamp'] = this.timestamp;
    data['work_date'] = this.workDate;
    data['work_image'] = this.workImage;
    data['work_image_lat'] = this.workImageLat;
    data['work_image_lng'] = this.workImageLng;
    data['worker_code'] = this.workerCode;
    data['worker_name'] = this.workerName;
    data['user_id'] = this.userId;
    data['distance'] = this.distance;
    return data;
  }
}

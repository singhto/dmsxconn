class InsxCheckModel {
  String idCheck;
  String ca;
  String peaNo;
  String cusName;
  String cusTel;
  String invoiceNo;
  String ptcInsx;
  String notiStatus;
  String imageInsx;
  String imgDate;
  String workDate;
  int distance;
  String userId;
  int userIdCheck;
  String statusCheck;
  String importDate;

  InsxCheckModel(
      {this.idCheck,
      this.ca,
      this.peaNo,
      this.cusName,
      this.cusTel,
      this.invoiceNo,
      this.ptcInsx,
      this.notiStatus,
      this.imageInsx,
      this.imgDate,
      this.workDate,
      this.distance,
      this.userId,
      this.userIdCheck,
      this.statusCheck,
      this.importDate});

  InsxCheckModel.fromJson(Map<String, dynamic> json) {
    idCheck = json['id_check'];
    ca = json['ca'];
    peaNo = json['pea_no'];
    cusName = json['cus_name'];
    cusTel = json['cus_tel'];
    invoiceNo = json['invoice_no'];
    ptcInsx = json['ptc_insx'];
    notiStatus = json['noti_status'];
    imageInsx = json['image_insx'];
    imgDate = json['img_date'];
    workDate = json['work_date'];
    distance = json['distance'];
    userId = json['user_id'];
    userIdCheck = json['user_id_check'];
    statusCheck = json['status_check'];
    importDate = json['import_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_check'] = this.idCheck;
    data['ca'] = this.ca;
    data['pea_no'] = this.peaNo;
    data['cus_name'] = this.cusName;
    data['cus_tel'] = this.cusTel;
    data['invoice_no'] = this.invoiceNo;
    data['ptc_insx'] = this.ptcInsx;
    data['noti_status'] = this.notiStatus;
    data['image_insx'] = this.imageInsx;
    data['img_date'] = this.imgDate;
    data['work_date'] = this.workDate;
    data['distance'] = this.distance;
    data['user_id'] = this.userId;
    data['user_id_check'] = this.userIdCheck;
    data['status_check'] = this.statusCheck;
    data['import_date'] = this.importDate;
    return data;
  }
}

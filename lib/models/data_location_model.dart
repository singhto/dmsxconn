class DataLocationModel {
  String idCheck;
  String ca;
  String peaNo;
  String cusName;
  String cusTel;
  String ptcInsx;
  String notiStatus;
  String imageInsx;
  String imgDate;

  DataLocationModel(
      {this.idCheck,
      this.ca,
      this.peaNo,
      this.cusName,
      this.cusTel,
      this.ptcInsx,
      this.notiStatus,
      this.imageInsx,
      this.imgDate});

  DataLocationModel.fromJson(Map<String, dynamic> json) {
    idCheck = json['id_check'];
    ca = json['ca'];
    peaNo = json['pea_no'];
    cusName = json['cus_name'];
    cusTel = json['cus_tel'];
    ptcInsx = json['ptc_insx'];
    notiStatus = json['noti_status'];
    imageInsx = json['image_insx'];
    imgDate = json['img_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_check'] = this.idCheck;
    data['ca'] = this.ca;
    data['pea_no'] = this.peaNo;
    data['cus_name'] = this.cusName;
    data['cus_tel'] = this.cusTel;
    data['ptc_insx'] = this.ptcInsx;
    data['noti_status'] = this.notiStatus;
    data['image_insx'] = this.imageInsx;
    data['img_date'] = this.imgDate;
    return data;
  }
}

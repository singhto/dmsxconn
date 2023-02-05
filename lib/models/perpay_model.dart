class PerPayModel {
  String id;
  String refUserId;
  String prepayType;
  String prepayAmount;
  String prepayDate;
  String prepayStatus;
  String prepayFile;

  PerPayModel(
      {this.id,
      this.refUserId,
      this.prepayType,
      this.prepayAmount,
      this.prepayDate,
      this.prepayStatus,
      this.prepayFile});

  PerPayModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    refUserId = json['ref_user_id'];
    prepayType = json['prepay_type'];
    prepayAmount = json['prepay_amount'];
    prepayDate = json['prepay_date'];
    prepayStatus = json['prepay_status'];
    prepayFile = json['prepay_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ref_user_id'] = this.refUserId;
    data['prepay_type'] = this.prepayType;
    data['prepay_amount'] = this.prepayAmount;
    data['prepay_date'] = this.prepayDate;
    data['prepay_status'] = this.prepayStatus;
    data['prepay_file'] = this.prepayFile;
    return data;
  }
}
class OutlayModel {
  String id;
  String costTypeId;
  String supplierName;
  String supplierAddress;
  String supplierTaxid;
  String orderFromId;
  String branch;
  String userId;
  String details;
  String number;
  String priceUnit;
  String sum;
  String tax;
  String referenceNumber;
  String image;
  String createdAt;
  String outlayStatus;
  String createBy;

  OutlayModel(
      {this.id,
      this.costTypeId,
      this.supplierName,
      this.supplierAddress,
      this.supplierTaxid,
      this.orderFromId,
      this.branch,
      this.userId,
      this.details,
      this.number,
      this.priceUnit,
      this.sum,
      this.tax,
      this.referenceNumber,
      this.image,
      this.createdAt,
      this.outlayStatus,
      this.createBy});

  OutlayModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    costTypeId = json['costType_id'];
    supplierName = json['supplier_name'];
    supplierAddress = json['supplier_address'];
    supplierTaxid = json['supplier_taxid'];
    orderFromId = json['orderFrom_id'];
    branch = json['branch'];
    userId = json['user_id'];
    details = json['details'];
    number = json['number'];
    priceUnit = json['priceUnit'];
    sum = json['sum'];
    tax = json['tax'];
    referenceNumber = json['referenceNumber'];
    image = json['image'];
    createdAt = json['createdAt'];
    outlayStatus = json['outlay_status'];
    createBy = json['create_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['costType_id'] = this.costTypeId;
    data['supplier_name'] = this.supplierName;
    data['supplier_address'] = this.supplierAddress;
    data['supplier_taxid'] = this.supplierTaxid;
    data['orderFrom_id'] = this.orderFromId;
    data['branch'] = this.branch;
    data['user_id'] = this.userId;
    data['details'] = this.details;
    data['number'] = this.number;
    data['priceUnit'] = this.priceUnit;
    data['sum'] = this.sum;
    data['tax'] = this.tax;
    data['referenceNumber'] = this.referenceNumber;
    data['image'] = this.image;
    data['createdAt'] = this.createdAt;
    data['outlay_status'] = this.outlayStatus;
    data['create_by'] = this.createBy;
    return data;
  }
}

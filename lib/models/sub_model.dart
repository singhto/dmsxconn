class SubModel {
  String supplierId;
  String supplierName;
  String supplierAddress;
  String supplierTaxid;
  String orderFromId;
  String branch;
  String createBy;
  String supplierDate;

  SubModel(
      {this.supplierId,
      this.supplierName,
      this.supplierAddress,
      this.supplierTaxid,
      this.orderFromId,
      this.branch,
      this.createBy,
      this.supplierDate});

  SubModel.fromJson(Map<String, dynamic> json) {
    supplierId = json['supplier_id'];
    supplierName = json['supplier_name'];
    supplierAddress = json['supplier_address'];
    supplierTaxid = json['supplier_taxid'];
    orderFromId = json['orderFrom_id'];
    branch = json['branch'];
    createBy = json['createBy'];
    supplierDate = json['supplierDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supplier_id'] = this.supplierId;
    data['supplier_name'] = this.supplierName;
    data['supplier_address'] = this.supplierAddress;
    data['supplier_taxid'] = this.supplierTaxid;
    data['orderFrom_id'] = this.orderFromId;
    data['branch'] = this.branch;
    data['createBy'] = this.createBy;
    data['supplierDate'] = this.supplierDate;
    return data;
  }
}

class GetDatModel {
  String getDatId;
  String getDatList;

  GetDatModel({this.getDatId, this.getDatList});

  GetDatModel.fromJson(Map<String, dynamic> json) {
    getDatId = json['getDat_id'];
    getDatList = json['getDat_list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['getDat_id'] = this.getDatId;
    data['getDat_list'] = this.getDatList;
    return data;
  }
}

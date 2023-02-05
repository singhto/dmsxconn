class ManualModel {
  String mId;
  String mTopic;
  String mDetail;
  String mImageUrl;
  String mLink;
  String mCreated;
  String mType;

  ManualModel(
      {this.mId,
      this.mTopic,
      this.mDetail,
      this.mImageUrl,
      this.mLink,
      this.mCreated,
      this.mType});

  ManualModel.fromJson(Map<String, dynamic> json) {
    mId = json['m_id'];
    mTopic = json['m_topic'];
    mDetail = json['m_detail'];
    mImageUrl = json['m_imageUrl'];
    mLink = json['m_link'];
    mCreated = json['m_created'];
    mType = json['m_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['m_id'] = this.mId;
    data['m_topic'] = this.mTopic;
    data['m_detail'] = this.mDetail;
    data['m_imageUrl'] = this.mImageUrl;
    data['m_link'] = this.mLink;
    data['m_created'] = this.mCreated;
    data['m_type'] = this.mType;
    return data;
  }
}

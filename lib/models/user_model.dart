class UserModel {
  String userId;
  String staffname;
  String staffsurname;
  String staffno;
  String username;
  String password;
  String branchId;
  String userLevel;
  String userBranch;
  String userEmail;
  String peaId;
  String userType;
  String userStatus;
  String leader;
  String userDate;
  String refUserId;
  String userIdCard;
  String userPhone;
  String userAdress;
  String userBankName;
  String userBankNumber;
  String userImg;

  UserModel(
      {this.userId,
      this.staffname,
      this.staffsurname,
      this.staffno,
      this.username,
      this.password,
      this.branchId,
      this.userLevel,
      this.userBranch,
      this.userEmail,
      this.peaId,
      this.userType,
      this.userStatus,
      this.leader,
      this.userDate,
      this.refUserId,
      this.userIdCard,
      this.userPhone,
      this.userAdress,
      this.userBankName,
      this.userBankNumber,
      this.userImg});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    staffname = json['staffname'];
    staffsurname = json['staffsurname'] ?? '';
    staffno = json['staffno'];
    username = json['username'];
    password = json['password'];
    branchId = json['branch_id'];
    userLevel = json['user_level'];
    userBranch = json['user_branch'];
    userEmail = json['user_email'];
    peaId = json['pea_id'];
    userType = json['user_type'];
    userStatus = json['user_status'];
    leader = json['leader'];
    userDate = json['user_date'];
    refUserId = json['ref_user_id'];
    userIdCard = json['user_id_card'];
    userPhone = json['user_phone'];
    userAdress = json['user_adress'];
    userBankName = json['user_bank_name'];
    userBankNumber = json['user_bank_number'];
    userImg = checkNull(json['user_img']);
  }

  String checkNull(String string){
    String result = string;
    if (result == null) {
      result = '';
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['staffname'] = this.staffname;
    data['staffsurname'] = this.staffsurname;
    data['staffno'] = this.staffno;
    data['username'] = this.username;
    data['password'] = this.password;
    data['branch_id'] = this.branchId;
    data['user_level'] = this.userLevel;
    data['user_branch'] = this.userBranch;
    data['user_email'] = this.userEmail;
    data['pea_id'] = this.peaId;
    data['user_type'] = this.userType;
    data['user_status'] = this.userStatus;
    data['leader'] = this.leader;
    data['user_date'] = this.userDate;
    data['ref_user_id'] = this.refUserId;
    data['user_id_card'] = this.userIdCard;
    data['user_phone'] = this.userPhone;
    data['user_adress'] = this.userAdress;
    data['user_bank_name'] = this.userBankName;
    data['user_bank_number'] = this.userBankNumber;
    data['user_img'] = this.userImg;
    return data;
  }
}

class LoginRequestModel {
  LoginRequestModel({
    this.userid,
    this.password,
  });

  late final String? userid;
  late final String? password;

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userid'] = userid;
    _data['password'] = password;
    return _data;
  }
}

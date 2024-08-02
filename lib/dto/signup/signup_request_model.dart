class SignupRequestModel {
  SignupRequestModel({
    this.username,
    this.nickname,
    this.userId,
    this.password,
    this.email,
    this.phoneNumber,
    this.birth,
  });

  late final String? username;
  late final String? nickname;
  late final String? userId;
  late final String? password;
  late final String? email;
  late final String? phoneNumber;
  late final String? birth;

  SignupRequestModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    nickname = json['nickname'];
    userId = json['userId'];
    password = json['password'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    birth = json['birth'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['username'] = username;
    _data['nickname'] = nickname;
    _data['userId'] = userId;
    _data['password'] = password;
    _data['email'] = email;
    _data['phoneNumber'] = phoneNumber;
    _data['birth'] = birth;
    return _data;
  }
}

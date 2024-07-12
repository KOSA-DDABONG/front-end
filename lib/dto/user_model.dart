class User {
  User({
    required this.username,
    required this.nickname,
    required this.userid,
    this.password,
    required this.email,
    required this.phonenumber,
    required this.birth,
    this.profileimage,
    // this.createdtime,
    // this.recentaccess,
  });

  late final String username;
  late final String nickname;
  late final String userid;
  late final String? password;
  late final String email;
  late final String phonenumber;
  late final String birth;
  late final String? profileimage;
  // late final DateTime? createdtime;
  // late final DateTime? recentaccess;

  @override
  String toString() {
    return '''
      User {
        username: $username,
        nickname: $nickname,
        userid: $userid,
        password: $password,
        email: $email,
        phonenumber: $phonenumber,
        birth: $birth,
        profileimage: $profileimage,
      }''';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      nickname: json['nickname'] ?? '',
      userid: json['userid'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
      birth: json['birth'] ?? '',
      profileimage: json['profileimage'] ?? '',
      // createdtime: DateTime.parse(json['createdtime'] ?? ''),
      // recentaccess: DateTime.parse(json['recentaccess'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'nickname': nickname,
      'userid': userid,
      'password': password,
      'email': email,
      'phonenumber': phonenumber,
      'birth': birth,
      'profileimage': profileimage,
      // 'createdtime': createdtime?.toIso8601String(),
      // 'recentaccess': recentaccess?.toIso8601String(),
    };
  }

  // Convert the createdAt array to a DateTime object
  static DateTime toDateTime(List<dynamic> createdAtArray) {
    return DateTime(
      createdAtArray[0],
      createdAtArray[1],
      createdAtArray[2],
      createdAtArray[3],
      createdAtArray[4],
      createdAtArray[5],
      createdAtArray[6] ~/ 1000000,
      createdAtArray[6] % 1000000 ~/ 1000, // Remaining nanoseconds to microseconds
    );
  }

  // Convert a DateTime object to the createdAt array
  static List<int> fromDateTime(DateTime createdAt) {
    return [
      createdAt.year,
      createdAt.month,
      createdAt.day,
      createdAt.hour,
      createdAt.minute,
      createdAt.second,
      createdAt.millisecond * 1000000 + createdAt.microsecond,
    ];
  }
}

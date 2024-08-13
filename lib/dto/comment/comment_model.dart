class Comment {
  Comment({
    required this.username,
    required this.nickname,
    required this.userId,
    this.password,
    required this.email,
    required this.phoneNumber,
    required this.birth,
    this.profileimage,
    this.createdTime,
    this.recessAccess,
  });

  late final String username;
  late final String nickname;
  late final String userId;
  late final String? password;
  late final String email;
  late final String phoneNumber;
  late final String birth;
  late final String? profileimage;
  late final DateTime? createdTime;
  late final DateTime? recessAccess;

  @override
  String toString() {
    return '''
      User {
        username: $username,
        nickname: $nickname,
        userId: $userId,
        password: $password,
        email: $email,
        phoneNumber: $phoneNumber,
        birth: $birth,
        profileimage: $profileimage,
        createdTime: $createdTime,
        recessAccess: $recessAccess
      }''';
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      username: json['username'] ?? '',
      nickname: json['nickname'] ?? '',
      userId: json['userId'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      birth: json['birth'] ?? '',
      profileimage: json['profileimage'] ?? '',
      createdTime: json['createdTime'] != null && json['createdTime'].isNotEmpty
          ? DateTime.parse(json['createdTime'])
          : null,
      recessAccess: json['recessAccess'] != null && json['recessAccess'].isNotEmpty
          ? DateTime.parse(json['recessAccess'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'nickname': nickname,
      'userId': userId,
      'password': password,
      'email': email,
      'phoneNumber': phoneNumber,
      'birth': birth,
      'profileimage': profileimage,
      'createdTime': createdTime?.toIso8601String(),
      'recessAccess': recessAccess?.toIso8601String(),
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

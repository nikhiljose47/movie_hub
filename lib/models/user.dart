class User {
  final int? id;
  final String firstName;
  final String lastName;
  final String avatar;

  /// For POST response (ReqRes returns string id)
  final String? createdId;
  final String? job;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    this.createdId,
    this.job,
  });

  /// 🔹 GET users response
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  /// 🔹 POST create user response
  factory User.fromCreateResponse(Map<String, dynamic> json) {
    return User(
      firstName: json['name'] ?? '',
      lastName: '',
      avatar: '',
      createdId: json['id'],
      job: json['job'],
    );
  }

  String get fullName => '$firstName $lastName';
}

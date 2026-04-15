class User {
  final String id;
  final String firstName;
  final String lastName;
  final String avatar;
  final String? job;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    this.job,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  factory User.fromCreateResponse(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      firstName: json['name'] ?? '',
      lastName: '',
      avatar: '',
      job: json['job'],
    );
  }

  String get fullName => '$firstName $lastName';
}
class User {
  String hashid;
  String name;
  String username;
  String email;

  User({
    required this.hashid,
    required this.name,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      hashid: json['hashid'].toString(),
      name: json['name'].toString(),
      username: json['username'].toString(),
      email: json['email'].toString(),
    );
  }
}
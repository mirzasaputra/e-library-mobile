class Member {
  String hashid;
  String name;
  String phone;
  String email;
  String address;

  Member({
    required this.hashid,
    required this.name,
    required this.phone,
    required this.email,
    required this.address
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      hashid: json['hashid'].toString(),
      name: json['name'].toString(),
      phone: json['phone'].toString(),
      email: json['email'].toString(),
      address: json['address'].toString(),
    );
  }
}
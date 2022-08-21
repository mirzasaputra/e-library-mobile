class Genre {
  String hashid;
  String name;

  Genre({
    required this.hashid,
    required this.name
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      hashid: json['hashid'].toString(),
      name: json['name'].toString()
    );
  }
}
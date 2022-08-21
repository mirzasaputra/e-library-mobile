class Book {
  String hashid;
  String name;
  String? description;
  String publicationYear;
  String author;

  Book({
    required this.hashid,
    required this.name,
    this.description,
    required this.publicationYear,
    required this.author,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      hashid: json['hashid'].toString(),
      name: json['name'].toString(),
      description: json['description'].toString(),
      publicationYear: json['publication_year'].toString(),
      author: json['author'].toString(),
    );
  }
}
class Book {
  final int? bookId; // null for a book not yet created
  final String title;
  final String author;
  final String isbn;
  final String category;
  final int publicationYear;
  final bool status;

  Book({
    this.bookId,
    required this.title,
    required this.author,
    required this.isbn,
    required this.category,
    required this.publicationYear,
    required this.status,
  });

  // Used when reading a book back from the API (GET / POST responses).
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['bookId'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      isbn: json['isbn'] as String,
      category: json['category'] as String,
      publicationYear: json['publicationYear'] as int,
      status: json['status'] as bool,
    );
  }

  // Used when sending a new book to POST /api/books.
  // bookId is intentionally excluded — the server generates it.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'isbn': isbn,
      'category': category,
      'publicationYear': publicationYear,
      'status': status,
    };
  }
}
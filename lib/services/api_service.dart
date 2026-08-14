import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  // Flutter Web runs in the same browser as the API, so localhost works.
  // (Flutter Mobile on an Android emulator would need 10.0.2.2 instead.)
  static const String baseUrl = 'http://10.84.208.32:3000/api/books';

  // GET /api/books
  static Future<List<Book>> getBooks() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books (status ${response.statusCode})');
    }
  }

  // GET /api/books/:id
  static Future<Book> getBookById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Book.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Book not found.');
    } else {
      throw Exception('Failed to load book (status ${response.statusCode})');
    }
  }

  // POST /api/books
  // Returns the full created Book (including its new bookId) on success.
  // Throws an Exception with the server's error message on failure.
  static Future<Book> createBook(Book book) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(book.toJson()),
    );

    if (response.statusCode == 201) {
      return Book.fromJson(jsonDecode(response.body));
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['error'] ?? 'Failed to create book.');
    }
  }
}
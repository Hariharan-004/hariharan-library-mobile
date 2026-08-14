import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import 'book_detail_screen.dart';
import 'add_book_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = ApiService.getBooks();
  }

  // Re-fetches the list. Called on pull-to-refresh and after returning
  // from the Add Book screen, so newly added books show up.
  void _refreshBooks() {
    setState(() {
      _booksFuture = ApiService.getBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Library — Books')),
      body: RefreshIndicator(
        onRefresh: () async => _refreshBooks(),
        child: FutureBuilder<List<Book>>(
          future: _booksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Failed to load books.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final books = snapshot.data ?? [];

            if (books.isEmpty) {
              return const Center(child: Text('No books yet. Tap + to add one.'));
            }

            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  trailing: Chip(
                    label: Text(book.status ? 'Active' : 'Inactive'),
                    backgroundColor:
                        book.status ? Colors.green[100] : Colors.grey[300],
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailScreen(book: book),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBookScreen()),
          );
          // If a book was successfully added, refresh the list to show it.
          if (result == true) {
            _refreshBooks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
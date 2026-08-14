import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _isbnController = TextEditingController();
  final _yearController = TextEditingController();

  static const List<String> _categories = [
    'Fiction',
    'Non-Fiction',
    'Science',
    'History',
    'Technology',
    'Other',
  ];

  String? _selectedCategory;
  bool _status = true; // defaults to Active on the form
  bool _isSubmitting = false;
  String? _serverError; // shows the API's { "error": "..." } message, if any

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Client-side validation runs first (Form.validate()).
    // Even if this passes, the server still validates independently —
    // client-side checks are for fast feedback, not a replacement for
    // server-side validation.
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      setState(() => _serverError = 'Please select a category.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _serverError = null;
    });

    final newBook = Book(
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      isbn: _isbnController.text.trim(),
      category: _selectedCategory!,
      publicationYear: int.parse(_yearController.text.trim()),
      status: _status,
    );

    try {
      await ApiService.createBook(newBook);
      if (!mounted) return;
      // Pop back to the list screen, signalling success (true) so the
      // list knows to refresh and show the newly added book.
      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        // Exception's toString() includes "Exception: " prefix — strip it
        // so the message shown matches the server's raw error text.
        _serverError = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Scaffold(
      appBar: AppBar(title: const Text('Add a Book')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_serverError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _serverError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Title is required.'
                    : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Author is required.'
                    : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _isbnController,
                decoration: const InputDecoration(labelText: 'ISBN'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'ISBN is required.'
                    : null,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: (value) =>
                    value == null ? 'Category is required.' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Publication Year'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Publication year is required.';
                  }
                  final year = int.tryParse(value.trim());
                  if (year == null) return 'Enter a valid number.';
                  if (year < 1500 || year > currentYear) {
                    return 'Year must be between 1500 and $currentYear.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              SwitchListTile(
                title: const Text('Active'),
                value: _status,
                onChanged: (value) => setState(() => _status = value),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Add Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
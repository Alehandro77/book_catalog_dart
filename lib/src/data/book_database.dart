import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import 'repositories/genre_repository.dart';
import 'repositories/publisher_repository.dart';
import 'repositories/book_repository.dart';
import 'repositories/author_repository.dart';
import 'repositories/book_author_repository.dart';

class BookDatabase {
  final Database _sqlite;

  late final GenreRepository genres;
  late final PublisherRepository publishers;
  late final BookRepository books;
  late final AuthorRepository authors;
  late final BookAuthorRepository bookAuthors;

  BookDatabase(String filePath) : _sqlite = sqlite3.open(filePath) {
    _createTables();
    _initRepositories();
  }

  factory BookDatabase.inApp() {
    final filePath = p.join(Directory.current.path, 'book_catalog.db');
    return BookDatabase(filePath);
  }

  void _initRepositories() {
    genres = GenreRepository(_sqlite);
    publishers = PublisherRepository(_sqlite);
    books = BookRepository(_sqlite);
    authors = AuthorRepository(_sqlite);
    bookAuthors = BookAuthorRepository(_sqlite);
  }

  void _createTables() {
    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS genres (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS publishers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        city TEXT,
        foundationYear INTEGER
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS books (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        year INTEGER,
        pageCount INTEGER,
        genreId TEXT NOT NULL,
        publisherId TEXT NOT NULL,
        FOREIGN KEY (genreId) REFERENCES genres(id) ON DELETE CASCADE,
        FOREIGN KEY (publisherId) REFERENCES publishers(id) ON DELETE CASCADE
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS authors (
        id TEXT PRIMARY KEY,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        birthYear INTEGER
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS book_authors (
        id TEXT PRIMARY KEY,
        bookId TEXT NOT NULL,
        authorId TEXT NOT NULL,
        FOREIGN KEY (bookId) REFERENCES books(id) ON DELETE CASCADE,
        FOREIGN KEY (authorId) REFERENCES authors(id) ON DELETE CASCADE,
        UNIQUE(bookId, authorId)
      );
    ''');
  }

  void close() {
    _sqlite.dispose();
  }
}

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../domain/books.dart';
import '../domain/authors.dart';
import '../domain/genres.dart';
import '../domain/publishing_houses.dart';
import '../domain/book_author.dart';

class BookDatabase {
  final Database _sqlite;

  BookDatabase(String filePath) : _sqlite = sqlite3.open(filePath) {
    _createTables();
  }

  factory BookDatabase.inApp() {
    final filePath = p.join(Directory.current.path, 'book_catalog.db');
    return BookDatabase(filePath);
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

  void insertGenre(Genres genre) {
    _sqlite.execute(
      'INSERT OR REPLACE INTO genres(id, name, description) VALUES(?,?,?)',
      [genre.id, genre.name, genre.description],
    );
  }

  List<Genres> getAllGenres() {
    final rows = _sqlite.select('SELECT id, name, description FROM genres');
    return rows.map((row) => Genres.fromMap(row)).toList();
  }

  Genres? getGenreById(String id) {
    final rows = _sqlite.select(
      'SELECT id, name, description FROM genres WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? Genres.fromMap(rows.first) : null;
  }

  void deleteGenre(String id) {
    _sqlite.execute('DELETE FROM genres WHERE id=?', [id]);
  }

  void insertPublisher(PublishingHouses publisher) {
    _sqlite.execute(
      'INSERT OR REPLACE INTO publishers(id, name, city, foundationYear) VALUES(?,?,?,?)',
      [publisher.id, publisher.name, publisher.city, publisher.foundationYear],
    );
  }

  List<PublishingHouses> getAllPublishers() {
    final rows = _sqlite.select('SELECT id, name, city, foundationYear FROM publishers');
    return rows.map((row) => PublishingHouses.fromMap(row)).toList();
  }

  PublishingHouses? getPublisherById(String id) {
    final rows = _sqlite.select(
      'SELECT id, name, city, foundationYear FROM publishers WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? PublishingHouses.fromMap(rows.first) : null;
  }

  void deletePublisher(String id) {
    _sqlite.execute('DELETE FROM publishers WHERE id=?', [id]);
  }

  void insertBook(Book book) {
    _sqlite.execute(
      'INSERT OR REPLACE INTO books(id, title, year, pageCount, genreId, publisherId) VALUES(?,?,?,?,?,?)',
      [book.id, book.title, book.year, book.pageCount, book.genreId, book.publisherId],
    );
  }

  List<Book> getAllBooks() {
    final rows = _sqlite.select('SELECT id, title, year, pageCount, genreId, publisherId FROM books');
    return rows.map((row) => Book.fromMap(row)).toList();
  }

  Book? getBookById(String id) {
    final rows = _sqlite.select(
      'SELECT id, title, year, pageCount, genreId, publisherId FROM books WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? Book.fromMap(rows.first) : null;
  }

  void deleteBook(String id) {
    _sqlite.execute('DELETE FROM books WHERE id=?', [id]);
  }

  void insertAuthor(Author author) {
    _sqlite.execute(
      'INSERT OR REPLACE INTO authors(id, firstName, lastName, birthYear) VALUES(?,?,?,?)',
      [author.id, author.firstName, author.lastName, author.birthYear],
    );
  }

  List<Author> getAllAuthors() {
    final rows = _sqlite.select('SELECT id, firstName, lastName, birthYear FROM authors');
    return rows.map((row) => Author.fromMap(row)).toList();
  }

  Author? getAuthorById(String id) {
    final rows = _sqlite.select(
      'SELECT id, firstName, lastName, birthYear FROM authors WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? Author.fromMap(rows.first) : null;
  }

  void deleteAuthor(String id) {
    _sqlite.execute('DELETE FROM authors WHERE id=?', [id]);
  }

  void insertBookAuthor(BookAuthor bookAuthor) {
    _sqlite.execute(
      'INSERT OR REPLACE INTO book_authors(id, bookId, authorId) VALUES(?,?,?)',
      [bookAuthor.id, bookAuthor.bookId, bookAuthor.authorId],
    );
  }

  List<BookAuthor> getAllBookAuthors() {
    final rows = _sqlite.select('SELECT id, bookId, authorId FROM book_authors');
    return rows.map((row) => BookAuthor.fromMap(row)).toList();
  }

  List<Author> getAuthorsByBookId(String bookId) {
    final rows = _sqlite.select('''
      SELECT a.id, a.firstName, a.lastName, a.birthYear 
      FROM authors a
      JOIN book_authors ba ON a.id = ba.authorId
      WHERE ba.bookId = ?
    ''', [bookId]);
    return rows.map((row) => Author.fromMap(row)).toList();
  }

  List<Book> getBooksByAuthorId(String authorId) {
    final rows = _sqlite.select('''
      SELECT b.id, b.title, b.year, b.pageCount, b.genreId, b.publisherId
      FROM books b
      JOIN book_authors ba ON b.id = ba.bookId
      WHERE ba.authorId = ?
    ''', [authorId]);
    return rows.map((row) => Book.fromMap(row)).toList();
  }

  void deleteBookAuthor(String id) {
    _sqlite.execute('DELETE FROM book_authors WHERE id=?', [id]);
  }

  void deleteAllBookAuthorsByBookId(String bookId) {
    _sqlite.execute('DELETE FROM book_authors WHERE bookId=?', [bookId]);
  }

  void close() {
    _sqlite.dispose();
  }
}
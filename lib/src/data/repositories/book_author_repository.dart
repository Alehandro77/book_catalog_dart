import 'package:sqlite3/sqlite3.dart';
import '../../domain/books.dart';
import '../../domain/authors.dart';
import '../../domain/book_author.dart';

class BookAuthorRepository {
  final Database _db;
  BookAuthorRepository(this._db);

  void insert(BookAuthor bookAuthor) {
    _db.execute(
      'INSERT OR REPLACE INTO book_authors(id, bookId, authorId) VALUES(?,?,?)',
      [bookAuthor.id, bookAuthor.bookId, bookAuthor.authorId],
    );
  }

  List<BookAuthor> getAll() {
    final rows = _db.select('SELECT id, bookId, authorId FROM book_authors');
    return rows.map((row) => BookAuthor.fromMap(row)).toList();
  }

  List<Author> getAuthorsByBookId(String bookId) {
    final rows = _db.select('''
      SELECT a.id, a.firstName, a.lastName, a.birthYear 
      FROM authors a
      JOIN book_authors ba ON a.id = ba.authorId
      WHERE ba.bookId = ?
    ''', [bookId]);
    return rows.map((row) => Author.fromMap(row)).toList();
  }

  List<Book> getBooksByAuthorId(String authorId) {
    final rows = _db.select('''
      SELECT b.id, b.title, b.year, b.pageCount, b.genreId, b.publisherId
      FROM books b
      JOIN book_authors ba ON b.id = ba.bookId
      WHERE ba.authorId = ?
    ''', [authorId]);
    return rows.map((row) => Book.fromMap(row)).toList();
  }

  void delete(String id) {
    _db.execute('DELETE FROM book_authors WHERE id=?', [id]);
  }

  void deleteByBookId(String bookId) {
    _db.execute('DELETE FROM book_authors WHERE bookId=?', [bookId]);
  }
}
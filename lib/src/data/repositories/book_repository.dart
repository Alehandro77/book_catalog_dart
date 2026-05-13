import 'package:sqlite3/sqlite3.dart';
import '../../domain/books.dart';

class BookRepository {
  final Database _db;
  BookRepository(this._db);

  void insert(Book book) {
    _db.execute(
      'INSERT OR REPLACE INTO books(id, title, year, pageCount, genreId, publisherId) VALUES(?,?,?,?,?,?)',
      [book.id, book.title, book.year, book.pageCount, book.genreId, book.publisherId],
    );
  }

  List<Book> getAll() {
    final rows = _db.select('SELECT id, title, year, pageCount, genreId, publisherId FROM books');
    return rows.map((row) => Book.fromMap(row)).toList();
  }

  Book? getById(String id) {
    final rows = _db.select('SELECT id, title, year, pageCount, genreId, publisherId FROM books WHERE id=?', [id]);
    return rows.isNotEmpty ? Book.fromMap(rows.first) : null;
  }

  void delete(String id) {
    _db.execute('DELETE FROM books WHERE id=?', [id]);
  }
}
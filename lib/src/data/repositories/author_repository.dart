import 'package:sqlite3/sqlite3.dart';
import '../../domain/authors.dart';

class AuthorRepository {
  final Database _db;
  AuthorRepository(this._db);

  void insert(Author author) {
    _db.execute(
      'INSERT OR REPLACE INTO authors(id, firstName, lastName, birthYear) VALUES(?,?,?,?)',
      [author.id, author.firstName, author.lastName, author.birthYear],
    );
  }

  List<Author> getAll() {
    final rows = _db.select('SELECT id, firstName, lastName, birthYear FROM authors');
    return rows.map((row) => Author.fromMap(row)).toList();
  }

  Author? getById(String id) {
    final rows = _db.select('SELECT id, firstName, lastName, birthYear FROM authors WHERE id=?', [id]);
    return rows.isNotEmpty ? Author.fromMap(rows.first) : null;
  }

  void delete(String id) {
    _db.execute('DELETE FROM authors WHERE id=?', [id]);
  }
}
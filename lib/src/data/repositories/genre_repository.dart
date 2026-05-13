import 'package:sqlite3/sqlite3.dart';
import '../../domain/genres.dart';

class GenreRepository {
  final Database _db;
  GenreRepository(this._db);

  void insert(Genres genre) {
    _db.execute(
      'INSERT OR REPLACE INTO genres(id, name, description) VALUES(?,?,?)',
      [genre.id, genre.name, genre.description],
    );
  }

  List<Genres> getAll() {
    final rows = _db.select('SELECT id, name, description FROM genres');
    return rows.map((row) => Genres.fromMap(row)).toList();
  }

  Genres? getById(String id) {
    final rows = _db.select('SELECT id, name, description FROM genres WHERE id=?', [id]);
    return rows.isNotEmpty ? Genres.fromMap(rows.first) : null;
  }

  void delete(String id) {
    _db.execute('DELETE FROM genres WHERE id=?', [id]);
  }
}
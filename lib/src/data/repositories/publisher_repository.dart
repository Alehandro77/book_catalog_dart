import 'package:sqlite3/sqlite3.dart';
import '../../domain/publishing_houses.dart';

class PublisherRepository {
  final Database _db;
  PublisherRepository(this._db);

  void insert(PublishingHouses publisher) {
    _db.execute(
      'INSERT OR REPLACE INTO publishers(id, name, city, foundationYear) VALUES(?,?,?,?)',
      [publisher.id, publisher.name, publisher.city, publisher.foundationYear],
    );
  }

  List<PublishingHouses> getAll() {
    final rows = _db.select('SELECT id, name, city, foundationYear FROM publishers');
    return rows.map((row) => PublishingHouses.fromMap(row)).toList();
  }

  PublishingHouses? getById(String id) {
    final rows = _db.select('SELECT id, name, city, foundationYear FROM publishers WHERE id=?', [id]);
    return rows.isNotEmpty ? PublishingHouses.fromMap(rows.first) : null;
  }

  void delete(String id) {
    _db.execute('DELETE FROM publishers WHERE id=?', [id]);
  }
}
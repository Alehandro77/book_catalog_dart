import 'dart:io';

import 'package:test/test.dart';
import 'package:book_catalog/book_catalog.dart';

void main() {
  test('Нагрузочный тест: вставка и чтение 1000 книг', () {
    final dbFile = File('test_load.db');
    final db = BookDatabase(dbFile.path);

    final genre = Genres(id: 'g1', name: 'Тестовый жанр');
    final publisher = PublishingHouses(id: 'p1', name: 'Тестовое издательство');
    db.insertGenre(genre);
    db.insertPublisher(publisher);

    final stopwatch = Stopwatch()..start();
    
    for (int i = 0; i < 1000; i++) {
      final book = Book(
        id: 'book_$i',
        title: 'Книга $i',
        year: 2000 + (i % 24),
        pageCount: 100 + i,
        genreId: 'g1',
        publisherId: 'p1',
      );
      db.insertBook(book);
    }
    
    final insertTime = stopwatch.elapsedMilliseconds;
    stopwatch.reset();

    final allBooks = db.getAllBooks();
    final readTime = stopwatch.elapsedMilliseconds;
    
    stopwatch.stop();
    
    expect(allBooks.length, 1000);
    print('Вставка 1000 книг: $insertTimeмс');
    print('Чтение 1000 книг: $readTimeмс');
    
    db.close();
    dbFile.deleteSync();
  });
}
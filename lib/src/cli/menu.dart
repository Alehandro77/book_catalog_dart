import 'dart:io';

import '../data/book_database.dart';
import '../domain/books.dart';
import '../domain/authors.dart';
import '../domain/genres.dart';
import '../domain/publishing_houses.dart';
import '../domain/book_author.dart';
import 'input_helper.dart';

void runMenu(BookDatabase db) {
  while (true) {
    stdout.writeln('''
--- Книжный каталог ---
1 - список книг
2 - добавить книгу
3 - удалить книгу
-----------------------
4 - список авторов
5 - добавить автора
6 - удалить автора
-----------------------
7 - список жанров
8 - добавить жанр
9 - удалить жанр
-----------------------
10 - список издательств
11 - добавить издательство
12 - удалить издательство
-----------------------
13 - показать всё из БД
14 - добавить связь книга-автор
0 - выход
Выберите пункт:''');

    final choice = stdin.readLineSync()?.trim() ?? '';
    switch (choice) {
      case '1':
        _printBooks(db);
        break;
      case '2':
        _addBook(db);
        break;
      case '3':
        _deleteBook(db);
        break;
      case '4':
        _printAuthors(db);
        break;
      case '5':
        _addAuthor(db);
        break;
      case '6':
        _deleteAuthor(db);
        break;
      case '7':
        _printGenres(db);
        break;
      case '8':
        _addGenre(db);
        break;
      case '9':
        _deleteGenre(db);
        break;
      case '10':
        _printPublishers(db);
        break;
      case '11':
        _addPublisher(db);
        break;
      case '12':
        _deletePublisher(db);
        break;
      case '13':
        _printAllFromDb(db);
        break;
      case '14':
        _addBookAuthor(db);
        break;
      case '0':
        stdout.writeln('До свидания.');
        return;
      default:
        stdout.writeln('Неизвестная команда.');
    }
  }
}

void _printBooks(BookDatabase db) {
  final list = db.books.getAll();
  if (list.isEmpty) {
    stdout.writeln('Книг нет.');
    return;
  }
  for (final b in list) {
    final authors = db.bookAuthors.getAuthorsByBookId(b.id);
    final authorNames = authors.map((a) => '${a.firstName} ${a.lastName}').join(', ');
    stdout.writeln('id: ${b.id} | ${b.title} | ${b.year} | ${b.pageCount} стр | Авторы: $authorNames');
  }
}

void _printAuthors(BookDatabase db) {
  final list = db.authors.getAll();
  if (list.isEmpty) {
    stdout.writeln('Авторов нет.');
    return;
  }
  for (final a in list) {
    stdout.writeln('id: ${a.id} | ${a.firstName} ${a.lastName} | ${a.birthYear}');
  }
}

void _printGenres(BookDatabase db) {
  final list = db.genres.getAll();
  if (list.isEmpty) {
    stdout.writeln('Жанров нет.');
    return;
  }
  for (final g in list) {
    stdout.writeln('id: ${g.id} | ${g.name} | ${g.description ?? ''}');
  }
}

void _printPublishers(BookDatabase db) {
  final list = db.publishers.getAll();
  if (list.isEmpty) {
    stdout.writeln('Издательств нет.');
    return;
  }
  for (final p in list) {
    stdout.writeln('id: ${p.id} | ${p.name} | ${p.city ?? ''} | ${p.foundationYear ?? ''}');
  }
}

void _printAllFromDb(BookDatabase db) {
  print("\nКниги:");
  _printBooks(db);
  print("\nАвторы:");
  _printAuthors(db);
  print("\nЖанры:");
  _printGenres(db);
  print("\nИздательства:");
  _printPublishers(db);
  
  print("\nСвязи книга-автор:");
  final links = db.bookAuthors.getAll();
  if (links.isEmpty) {
    stdout.writeln('Связей нет.');
  } else {
    for (final link in links) {
      stdout.writeln('id: ${link.id} | книга: ${link.bookId} | автор: ${link.authorId}');
    }
  }
}

void _addBook(BookDatabase db) {
  print('\nДобавление книги');

  final id = readNonEmptyString('id книги: ');
  final title = readNonEmptyString('название: ');
  final year = readOptionalPositiveInt('год (Enter - пропустить): ');
  final pages = readOptionalPositiveInt('страниц (Enter - пропустить): ');
  final genreId = readNonEmptyString('id жанра: ');
  final publisherId = readNonEmptyString('id издательства: ');

  final genre = db.genres.getById(genreId);
  if (genre == null) {
    stdout.writeln('Ошибка: жанр с id "$genreId" не найден.');
    return;
  }

  final publisher = db.publishers.getById(publisherId);
  if (publisher == null) {
    stdout.writeln('Ошибка: издательство с id "$publisherId" не найдено.');
    return;
  }

  db.books.insert(Book(
    id: id,
    title: title,
    year: year,
    pageCount: pages,
    genreId: genreId,
    publisherId: publisherId,
  ));
  stdout.writeln('Книга сохранена.');
}

void _deleteBook(BookDatabase db) {
  final id = readNonEmptyString('id книги для удаления: ');
  final book = db.books.getById(id);
  if (book == null) {
    stdout.writeln('Ошибка: книга с id "$id" не найдена.');
    return;
  }
  db.bookAuthors.deleteByBookId(id);
  db.books.delete(id);
  stdout.writeln('Книга удалена.');
}

void _addAuthor(BookDatabase db) {
  print('\nДобавление автора');

  final id = readNonEmptyString('id автора: ');
  final firstName = readNonEmptyString('имя: ');
  final lastName = readNonEmptyString('фамилия: ');
  final birthYear = readOptionalPositiveInt('год рождения (Enter - пропустить): ');

  db.authors.insert(Author(
    id: id,
    firstName: firstName,
    lastName: lastName,
    birthYear: birthYear,
  ));
  stdout.writeln('Автор сохранён.');
}

void _deleteAuthor(BookDatabase db) {
  final id = readNonEmptyString('id автора для удаления: ');
  final author = db.authors.getById(id);
  if (author == null) {
    stdout.writeln('Ошибка: автор с id "$id" не найден.');
    return;
  }
  db.authors.delete(id);
  stdout.writeln('Автор удалён.');
}

void _addGenre(BookDatabase db) {
  print('\nДобавление жанра');

  final id = readNonEmptyString('id жанра: ');
  final name = readNonEmptyString('название: ');
  final description = readOptionalString('описание (Enter - пропустить): ');

  db.genres.insert(Genres(
    id: id,
    name: name,
    description: description.isEmpty ? null : description,
  ));
  stdout.writeln('Жанр сохранён.');
}

void _deleteGenre(BookDatabase db) {
  final id = readNonEmptyString('id жанра для удаления: ');
  final genre = db.genres.getById(id);
  if (genre == null) {
    stdout.writeln('Ошибка: жанр с id "$id" не найден.');
    return;
  }
  db.genres.delete(id);
  stdout.writeln('Жанр удалён.');
}

void _addPublisher(BookDatabase db) {
  print('\nДобавление издательства');

  final id = readNonEmptyString('id издательства: ');
  final name = readNonEmptyString('название: ');
  final city = readOptionalString('город (Enter - пропустить): ');
  final foundationYear = readOptionalPositiveInt('год основания (Enter - пропустить): ');

  db.publishers.insert(PublishingHouses(
    id: id,
    name: name,
    city: city.isEmpty ? null : city,
    foundationYear: foundationYear,
  ));
  stdout.writeln('Издательство сохранено.');
}

void _deletePublisher(BookDatabase db) {
  final id = readNonEmptyString('id издательства для удаления: ');
  final publisher = db.publishers.getById(id);
  if (publisher == null) {
    stdout.writeln('Ошибка: издательство с id "$id" не найдено.');
    return;
  }
  db.publishers.delete(id);
  stdout.writeln('Издательство удалено.');
}

void _addBookAuthor(BookDatabase db) {
  print('\nДобавление связи книга-автор');

  final id = readNonEmptyString('id связи: ');
  final bookId = readNonEmptyString('id книги: ');
  final authorId = readNonEmptyString('id автора: ');

  final book = db.books.getById(bookId);
  if (book == null) {
    stdout.writeln('Ошибка: книга с id "$bookId" не найдена.');
    return;
  }

  final author = db.authors.getById(authorId);
  if (author == null) {
    stdout.writeln('Ошибка: автор с id "$authorId" не найден.');
    return;
  }

  db.bookAuthors.insert(BookAuthor(
    id: id,
    bookId: bookId,
    authorId: authorId,
  ));
  stdout.writeln('Связь сохранена.');
}

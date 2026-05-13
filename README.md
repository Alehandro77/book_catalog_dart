# book_catalog — модульное CLI-приложение на Dart

Консольное приложение для учета книг, авторов, жанров и издательств с хранением данных в SQLite.

## Предметная область

Система для управления книжным каталогом:

- книги (`Book`);
- авторы (`Authors`);
- жанры (`Genres`);
- издательства (`PublishingHouses`);
- связи книга-автор (`BookAuthor`).

Книга привязана к одному жанру и одному издательству, но может иметь несколько авторов.

## Архитектура и структура папок

Проект разделен на модули по слоям:

```text
lib/
  book_catalog.dart                # публичный экспорт
  src/
    domain/                        # сущности и базовые интерфейсы
      identity.dart
      book.dart
      author.dart
      genre.dart
      publisher.dart
      book_author.dart
    data/
      book_database.dart           # Открытие SQLite, создание таблиц
      repositories/                # Классы для CRUD
        genre_repository.dart
        publisher_repository.dart
        book_repository.dart
        author_repository.dart
        book_author_repository.dart
    cli/                           # меню и обработка ввода
      menu.dart
      input_helper.dart
bin/
  book_catalog.dart                # точка входа (main)
test/
  book_catalog_test.dart           # базовые тесты
```

## Что вынесено в каждый слой и почему

- `domain`: описывает данные и преобразования (`toMap`/`fromMap`), не зависит от SQL и консоли.
- `data`: отвечает за хранение, создание таблиц и CRUD-запросы.
- `cli`: отвечает за взаимодействие с пользователем (`stdin`/`stdout`) и навигацию по меню.
- `bin`: только запуск приложения и закрытие ресурсов.

Такое разделение упрощает поддержку, тестирование и замену инфраструктуры (например, SQLite на другой способ хранения).

## Реализованная функциональность

- CRUD для книг, авторов, жанров, издательств
- добавление связей книга-автор
- просмотр книг по автору
- вывод всех таблиц БД в консоль

## Валидации

1. Обязательное текстовое поле - значение не пустое после trim()
2. Числовое поле больше 0 (год рождения, год основания, страницы)

## Тесты

1. Нагрузочное тестирование - запись / чтение 1000 книг

## Запуск

```bash
dart pub get
dart run bin/book_catalog.dart
dart run test/book_catalog_test.dart
```

Установить зависимости:

```bash
dart pub get
```

Запустить приложение:

```bash
dart run
```

Запустить тесты:

```bash
dart run test/book_catalog_test.dart
```

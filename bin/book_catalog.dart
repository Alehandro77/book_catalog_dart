import 'package:book_catalog/book_catalog.dart';

void main(List<String> arguments) {
  final db = BookDatabase.inApp();
  try {
    runMenu(db);
  } finally {
    db.close();
  }
}
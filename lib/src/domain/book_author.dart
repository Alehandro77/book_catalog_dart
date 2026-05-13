import 'identity.dart';

class BookAuthor implements Identity {
  @override
  final String id;
  final String bookId;
  final String authorId;

  const BookAuthor({
    required this.id,
    required this.bookId,
    required this.authorId,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'bookId': bookId,
        'authorId': authorId,
      };

  factory BookAuthor.fromMap(Map<String, dynamic> map) {
    return BookAuthor(
      id: map['id'] as String,
      bookId: map['bookId'] as String,
      authorId: map['authorId'] as String,
    );
  }

  @override
  String toString() => 'Book $bookId -> Author $authorId';
}
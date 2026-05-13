import 'identity.dart';

class Book implements Identity {
  @override
  final String id;
  final String title;
  final int? year;
  final int? pageCount;
  final String genreId;
  final String publisherId;

  const Book({
    required this.id,
    required this.title,
    this.year,
    this.pageCount,
    required this.genreId,
    required this.publisherId,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'year': year,
        'pageCount': pageCount,
        'genreId': genreId,
        'publisherId': publisherId,
      };

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as String,
      title: map['title'] as String,
      year: map['year'] as int?,
      pageCount: map['pageCount'] as int?,
      genreId: map['genreId'] as String,
      publisherId: map['publisherId'] as String,
    );
  }

  @override
  String toString() => title;
}
import 'identity.dart';

class Author implements Identity {
  @override
  final String id;
  final String firstName;
  final String lastName;
  final int? birthYear;

  const Author({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.birthYear,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'birthYear': birthYear,
      };

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      id: map['id'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      birthYear: map['birthYear'] as int?,
    );
  }

  @override
  String toString() => '$firstName $lastName';
}
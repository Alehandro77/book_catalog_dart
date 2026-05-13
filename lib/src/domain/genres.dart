import 'identity.dart';

class Genres implements Identity {
  @override
  final String id;
  final String name;
  final String? description;

  const Genres({
    required this.id,
    required this.name,
    this.description,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
      };

  factory Genres.fromMap(Map<String, dynamic> map) {
    return Genres(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
    );
  }

  @override
  String toString() => name;
}
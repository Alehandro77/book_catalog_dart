import 'identity.dart';

class PublishingHouses implements Identity {
  @override
  final String id;
  final String name;
  final String? city;
  final int? foundationYear;

  const PublishingHouses({
    required this.id,
    required this.name,
    this.city,
    this.foundationYear,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'city': city,
        'foundationYear': foundationYear,
      };

  factory PublishingHouses.fromMap(Map<String, dynamic> map) {
    return PublishingHouses(
      id: map['id'] as String,
      name: map['name'] as String,
      city: map['city'] as String?,
      foundationYear: map['foundationYear'] as int?,
    );
  }

  @override
  String toString() => name;
}
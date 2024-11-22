import 'package:adopet/data/Owner.dart';

class Dog {
  final int id;
  final String name;
  final double age;
  final String gender;
  final String color;
  final double weight;
  final String location;
  final String imageUrl;
  final String description;
  final Owner owner;

  Dog({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.color,
    required this.weight,
    required this.location,
    required this.imageUrl,
    required this.description,
    required this.owner,
  });

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      color: json['color'],
      weight: json['weight'],
      location: json['location'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      owner: Owner.fromJson(json['owner']),
    );
  }
}

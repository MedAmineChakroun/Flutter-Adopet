import 'package:adopet/data/Owner.dart';

class Dog {
  final String? id;
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
    this.id,
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
      id: json['_id'],
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

  Map<String, dynamic> toJson({bool forUpdate = false}) {
    final data = <String, dynamic>{
      'name': name,
      'age': age,
      'gender': gender,
      'color': color,
      'weight': weight,
      'location': location,
      'imageUrl': imageUrl,
      'description': description,
      'owner': owner.toJson(),
    };
    //ken chya3mel update me ybadalch _id yo93od houwa bidou eli 5tarou
    if (!forUpdate) {
      data['_id'] = id;
    }
    return data;
  }
}

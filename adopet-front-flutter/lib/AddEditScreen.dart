import 'package:adopet/DogForm.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'data/Dog.dart';

//deux methodes edit / add
class AddEditScreen extends StatelessWidget {
  final Dog? dog;
  const AddEditScreen({Key? key, this.dog}) : super(key: key);

  Future<void> addDog(BuildContext context, Dog newDog) async {
    final url = Uri.parse('http://localhost:3000/dogs');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(newDog.toJson()),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dog added successfully!')),
        );
        Navigator.pop(context, newDog);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add dog.')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while adding dog.')),
      );
    }
  }

  Future<void> editDog(BuildContext context, Dog updatedDog) async {
    final url = Uri.parse('http://localhost:3000/dogs/${dog!.id}');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedDog.toJson(forUpdate: true)),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dog updated successfully!')),
        );
        Navigator.pop(context, updatedDog);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to update dog: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while updating dog.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = dog != null;
    //ken isEditing is true ya3mel edit else add
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Dog' : 'Add Dog'),
      ),
      body: DogForm(
        dog: dog,
        onSave: (updatedDog) async {
          if (isEditing) {
            await editDog(context, updatedDog);
          } else {
            await addDog(context, updatedDog);
          }
        },
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'data/Dog.dart';
import 'AddEditScreen.dart';

class DogListScreen extends StatefulWidget {
  @override
  _DogListScreenState createState() => _DogListScreenState();
}

class _DogListScreenState extends State<DogListScreen> {
  List<Dog> dogList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchDogs();
  }

  Future<void> fetchDogs() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/dogs'));

      if (response.statusCode == 200) {
        final List<dynamic> dogJson = jsonDecode(response.body);

        setState(() {
          dogList = dogJson.map((json) => Dog.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load dogs');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        errorMessage = 'Failed to fetch dogs. Please try again.';
        isLoading = false;
      });
    }
  }

  void onDelete(Dog dog) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${dog.name}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                final response = await http.delete(
                  Uri.parse('http://localhost:3000/dogs/${dog.id}'),
                );

                if (response.statusCode == 200) {
                  setState(() {
                    dogList.remove(dog);
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${dog.name} has been deleted.')),
                  );
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete ${dog.name}.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void onEdit(Dog dog) async {
    final updatedDog = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditScreen(dog: dog),
      ),
    );

    if (updatedDog != null && updatedDog is Dog) {
      setState(() {
        final index = dogList.indexWhere((d) => d.id == updatedDog.id);
        if (index != -1) {
          dogList[index] = updatedDog;
        }
      });

      //ya3mel refresh
      fetchDogs();
    }
  }

  void onAdd() async {
    final newDog = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditScreen(),
      ),
    );

    if (newDog != null && newDog is Dog) {
      setState(() {
        dogList.add(newDog);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adopt a Pet'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: TextButton(
              onPressed: onAdd,
              child: Text(
                'Add +',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 100),
                  itemCount: dogList.length,
                  itemBuilder: (context, index) {
                    final dog = dogList[index];
                    return Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      elevation: 5,
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            dog.imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.fill,
                          ),
                        ),
                        title: Text(
                          dog.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dog.location,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${dog.gender}',
                              style: TextStyle(
                                fontSize: 14,
                                color: dog.gender == 'Female'
                                    ? const Color.fromARGB(255, 178, 22, 74)
                                    : const Color.fromARGB(255, 22, 123, 205),
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                onEdit(dog);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                onDelete(dog);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          context.go('/dog/${dog.id}');
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

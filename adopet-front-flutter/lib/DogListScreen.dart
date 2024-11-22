import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'data/Dog.dart';
import 'package:go_router/go_router.dart';

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
      final response = await http.get(
          // bech tastit 3al teliphoun 7atit ip adresse mta3 lwifi
          Uri.parse('http://192.168.1.15:3000/dogs'));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adopt a Pet'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: dogList.length,
                  itemBuilder: (context, index) {
                    final dog = dogList[index];
                    return Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            dog.imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
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
                            )
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

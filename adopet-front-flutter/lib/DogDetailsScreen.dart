import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'data/Dog.dart';

class DogDetailsScreen extends StatefulWidget {
  final String dogId;

  DogDetailsScreen({required this.dogId});

  @override
  _DogDetailsScreenState createState() => _DogDetailsScreenState();
}

class _DogDetailsScreenState extends State<DogDetailsScreen> {
  Dog? dog;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchDogDetails();
  }

  Future<void> fetchDogDetails() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost3000/dogs/${widget.dogId}'));

      if (response.statusCode == 200) {
        setState(() {
          dog = Dog.fromJson(jsonDecode(response.body));
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch dog details');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        errorMessage = 'Failed to fetch dog details. Please try again.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dog Details'),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 138, 49),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/');
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : dog == null
                  ? Center(child: Text('Dog not found'))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              dog!.imageUrl,
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            dog!.name,
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            dog!.location,
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[600]),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              DetailCard(
                                  label: "Age", value: '${dog!.age} years'),
                              DetailCard(label: "Gender", value: dog!.gender),
                              DetailCard(label: "Color", value: dog!.color),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Weight: ${dog!.weight} kg',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Description',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            dog!.description,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 32),
                          Text(
                            'Owner Info',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    AssetImage(dog!.owner.imageUrl),
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dog!.owner.name,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    dog!.owner.bio,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
    );
  }
}

class DetailCard extends StatelessWidget {
  final String label;
  final String value;

  DetailCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.deepPurple[50],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

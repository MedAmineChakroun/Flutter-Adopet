import 'package:adopet/data/Dog.dart';
import 'package:adopet/data/Owner.dart';
import 'package:flutter/material.dart';

class DogForm extends StatefulWidget {
  final Dog? dog;
  final Function(Dog) onSave;

  const DogForm({Key? key, this.dog, required this.onSave}) : super(key: key);

  @override
  _DogFormState createState() => _DogFormState();
}

class _DogFormState extends State<DogForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController locationController;
  late final TextEditingController imageUrlController;
  late final TextEditingController colorController;
  late final TextEditingController descriptionController;
  late final TextEditingController ageController;
  late final TextEditingController weightController;

  String gender = 'Male';

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.dog?.name ?? '');
    locationController =
        TextEditingController(text: widget.dog?.location ?? '');
    imageUrlController = TextEditingController(
        text: widget.dog?.imageUrl ?? 'assets/DefaultDog.png');
    colorController = TextEditingController(text: widget.dog?.color ?? '');
    descriptionController =
        TextEditingController(text: widget.dog?.description ?? '');
    ageController = TextEditingController(text: widget.dog?.age.toString());
    weightController =
        TextEditingController(text: widget.dog?.weight.toString());
    gender = widget.dog?.gender ?? gender;
  }

  //gender par defaut 7titou male
  //imageUrl 7atit DefaultDof.png , par defaut w tet 7at fel input awel me t7ot el formulaire
  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    imageUrlController.dispose();
    colorController.dispose();
    descriptionController.dispose();
    ageController.dispose();
    weightController.dispose();
    super.dispose();
  }

  //7atit owner par default
  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final newDog = Dog(
        name: nameController.text,
        location: locationController.text,
        gender: gender,
        imageUrl: imageUrlController.text,
        age: double.tryParse(ageController.text) ?? 0.0,
        color: colorController.text,
        description: descriptionController.text,
        weight: double.tryParse(weightController.text) ?? 0.0,
        owner: widget.dog?.owner ??
            Owner(
              name: 'Spikey Sanju',
              bio: 'Developer & Pet Lover',
              imageUrl: 'assets/owner.png',
            ),
      );

      widget.onSave(newDog);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'This field is required'
                    : null,
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) => value == null || value.isEmpty
                    ? 'This field is required'
                    : null,
              ),
              DropdownButtonFormField<String>(
                value: gender,
                items: ['Male', 'Female']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (value) => setState(() => gender = value!),
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              TextFormField(
                controller: imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                ),
              ),
              TextFormField(
                controller: colorController,
                decoration: InputDecoration(labelText: 'Color'),
                validator: (value) => value == null || value.isEmpty
                    ? 'This field is required'
                    : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) => value == null || value.isEmpty
                    ? 'This field is required'
                    : null,
                maxLines: 3,
              ),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age (years)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  final num = double.tryParse(value);
                  if (num == null || num <= 0) {
                    return 'Enter a valid positive number';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  final num = double.tryParse(value);
                  if (num == null || num <= 0) {
                    return 'Enter a valid positive number';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text(widget.dog == null ? 'Add Dog' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

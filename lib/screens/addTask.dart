import 'dart:io';
import 'package:bucketo/screens/home.dart';
import 'package:bucketo/util.dart';
import 'package:bucketo/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:path/path.dart';

class AddTaskScreen extends StatefulWidget {
  static const String id = 'addtask_screen';
  const AddTaskScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String selectedCategory = 'Other';
  DateTime selectedDate = DateTime.now();
  File? _image;
  String? _imageUrl;
  String link = '';

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _uploadImageToFirebase() async {
    if (_image == null) {
      print('No image to upload.');
      return;
    }

    try {
      final fileName = basename(_image!.path);
      final storageReference =
          FirebaseStorage.instance.ref().child('images/$fileName');

      await storageReference.putFile(_image!);

      _imageUrl = await storageReference.getDownloadURL();
      print('Image uploaded to Firebase: $_imageUrl');
    } catch (e) {
      print('Error uploading image to Firebase: $e');
    }
  }

  List<Map<String, dynamic>> categories = [
    {'name': 'Personal', 'color': Colors.yellow},
    {'name': 'Adventure', 'color': Colors.blue},
    {'name': 'Travel', 'color': Colors.green},
    {'name': 'Skills', 'color': CustomColors.PurpleIcon},
    {'name': 'Shopping', 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bucket List Item'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              SizedBox(
                height: 45,
                child: TextFormField(
                  controller: titleController,
                  onChanged: (value) {
                    // Update the state when text changes
                    setState(() {});
                  },
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    color: Colors.grey[850],
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your title',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                    contentPadding:
                        const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    border: InputBorder.none,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(50.0),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 45,
                child: TextFormField(
                  controller: descriptionController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    color: Colors.grey[850],
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter the Description here',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(
                        0.0, 10.0, 0.0, 0.0), // Adjust padding
                    border: InputBorder.none,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(50.0),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.grey),
                    bottom: BorderSide(width: 1.0, color: Colors.grey),
                  ),
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: categories
                      .map((category) => _buildCategoryItem(category))
                      .toList(),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text(
                    'Achieve it by: ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  Center(
                    child: Text(
                      DateFormat('dd MMMM yy').format(selectedDate),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != selectedDate) {
                    setState(() {
                      selectedDate = pickedDate!;
                    });
                  }
                },
                child: const Text('Select Date'),
              ),
              const SizedBox(height: 30),
              _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        _image!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:
                          const Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
              ElevatedButton(
                onPressed: () async {
                  await _getImage();
                },
                child: const Text('Pick and Upload Image'),
              ),
              const SizedBox(height: 30),
              TextFormField(
                autofocus: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  color: Colors.grey[850],
                ),
                decoration: InputDecoration(
                  hintText: 'Input reference Links her.',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  border: InputBorder.none,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    link = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    // Check if user is logged in
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      // User is logged in, proceed with saving data
                      saveData(user.email.toString());
                      Navigator.pushNamed(context, Home.id);
                    } else {
                      Navigator.pushNamed(context, LoginScreen.id);
                      // User is not logged in, show authentication screen
                      // You can implement your own logic to handle authentication
                      // or use an authentication package like firebase_auth
                      // For simplicity, we're just printing a message here
                      print('User not logged in. Please log in.');
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    titleController.text.isNotEmpty
                        ? CustomColors.BlueDark
                        : const Color.fromRGBO(229, 229, 229, 1.0),
                  ),
                  foregroundColor: WidgetStateProperty.all<Color>(
                    titleController.text.isNotEmpty
                        ? const Color.fromRGBO(255, 255, 255, 1.0)
                        : const Color.fromRGBO(148, 148, 148, 1.0),
                  ),
                ),
                child: const Text('Save'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromRGBO(255, 205, 210, 1)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveData(String userEmail) async {
    try {
      final CollectionReference tasks =
          FirebaseFirestore.instance.collection('tasks');

      await _uploadImageToFirebase();

      DocumentReference documentReference = await tasks.add({
        'title': titleController.text,
        'description': descriptionController.text,
        'category': selectedCategory,
        'date': selectedDate,
        'imageUrl': _imageUrl,
        'link': link,
        'isDone': false,
        'isStarred': false,
        'user': userEmail, // Add user email to the task
      });

      String documentId = documentReference.id;
      await documentReference.update({'Id': documentId});
    } catch (e) {
      print('Error saving data to Firestore: $e');
    }
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    String categoryName = category['name'];
    Color categoryColor = category['color'];
    bool isSelected = selectedCategory == categoryName;

    return InkWell(
      onTap: () {
        setState(() {
          selectedCategory = categoryName;
        });
      },
      child: Center(
        child: isSelected
            ? _buildSelectedCategoryItem(categoryColor, categoryName)
            : _buildNonSelectedCategoryItem(categoryColor, categoryName),
      ),
    );
  }

  Widget _buildSelectedCategoryItem(Color color, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: color,
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildNonSelectedCategoryItem(Color color, String label) {
    return Row(
      children: [
        Container(
          height: 10.0,
          width: 10.0,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: Text(label),
        ),
      ],
    );
  }
}

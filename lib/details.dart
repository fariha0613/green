import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  bool isDonate = false;
  bool isLoading = false;
  bool isImageUploading = false;

  String? selectedCategory;
  String? uploadedImageUrl;

  final String cloudinaryApiKey = '274289191242395';
  final String cloudinaryCloudName = 'daftglzki';
  final String cloudinaryUploadPreset = 'Green123';

  XFile? _pickedFile;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) {
      setState(() => _pickedFile = file);
    }
  }

  Future<String?> uploadImageToCloudinary(XFile file) async {
    try {
      final uri = Uri.parse(
          'https://api.cloudinary.com/v1_1/$cloudinaryCloudName/image/upload');

      final request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = cloudinaryUploadPreset;
      request.fields['api_key'] = cloudinaryApiKey;

      if (kIsWeb) {
        final bytes = await file.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: file.name,
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
        ));
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);

      if (response.statusCode == 200) {
        return jsonData['secure_url'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> uploadData() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter product name")),
      );
      return false;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Select category")),
      );
      return false;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login first")),
      );
      return false;
    }

    String? imageUrl;

    if (_pickedFile != null) {
      setState(() => isImageUploading = true);
      imageUrl = await uploadImageToCloudinary(_pickedFile!);
      setState(() => isImageUploading = false);
    }

    try {
      await FirebaseFirestore.instance.collection('products').add({
        'name': nameController.text.trim(),
        'description': descriptionController.text.trim(),
        'category': selectedCategory,
        'price': isDonate ? 0 : int.tryParse(priceController.text) ?? 0,
        'isDonate': isDonate,
        'imageUrl': imageUrl ?? '',
        'sellerId': user.uid, // 🔥 IMPORTANT
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Product Details", style: TextStyle(color: Colors.white)),
        actions: [
          isLoading || isImageUploading
              ? Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : TextButton(
                  onPressed: () async {
                    setState(() => isLoading = true);
                    final ok = await uploadData();
                    setState(() => isLoading = false);

                    if (ok && mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => homepage()),
                        (route) => false,
                      );
                    }
                  },
                  child: Text("Confirm",
                      style: TextStyle(color: Colors.white)),
                )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Icon(Icons.image),
                    SizedBox(width: 10),
                    Text(_pickedFile?.name ?? "Select Image"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            DropdownButton<String>(
              value: selectedCategory,
              hint: Text("Select Category"),
              isExpanded: true,
              items: ["Clothes", "Electronics", "Furniture", "Others"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => selectedCategory = v),
            ),

            SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),

            SizedBox(height: 20),

            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),

            SizedBox(height: 20),

            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: "Price"),
            ),

            Row(
              children: [
                Checkbox(
                  value: isDonate,
                  onChanged: (v) => setState(() => isDonate = v!),
                ),
                Text("Donate")
              ],
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
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

  // 🔐 Cloudinary credentials
  final String cloudinaryApiKey = '274289191242395';
  final String cloudinaryApiSecret = 'ZAMJ4H7XtUkW83D0AGU5mb9lgtU';
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

      final response = await request.send().timeout(Duration(seconds: 30));
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);

      if (response.statusCode == 200) {
        return jsonData['secure_url'] as String?;
      } else {
        print('Cloudinary upload error: $jsonData');
        return null;
      }
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      return null;
    }
  }

  Future<bool> uploadData() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a product name")),
      );
      return false;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a category")),
      );
      return false;
    }

    String? imageUrl;
    if (_pickedFile != null) {
      setState(() => isImageUploading = true);
      imageUrl = await uploadImageToCloudinary(_pickedFile!);
      setState(() => isImageUploading = false);

      if (imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image upload failed. Please try again.")),
        );
        return false;
      }
    }

    try {
      await FirebaseFirestore.instance.collection('products').add({
        'name': nameController.text.trim(),
        'description': descriptionController.text.trim(),
        'category': selectedCategory,
        'price': isDonate ? 0 : int.tryParse(priceController.text) ?? 0,
        'isDonate': isDonate,
        'imageUrl': imageUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      }).timeout(Duration(seconds: 10));

      return true;
    } catch (e) {
      print('Firestore upload error: $e');
      return false;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Product Details", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          isLoading || isImageUploading
              ? Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(color: Colors.white),
          )
              : TextButton(
            onPressed: () async {
              setState(() => isLoading = true);
              final success = await uploadData();
              setState(() => isLoading = false);

              if (success && mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => homepage()),
                      (route) => false,
                );
              }
            },
            child: Text("Confirm",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Upload
            GestureDetector(
              onTap: isImageUploading ? null : pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                ),
                child: isImageUploading
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.green),
                      SizedBox(height: 10),
                      Text("Uploading image...",
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                )
                    : Text ("image selected"),
              ),
            ),

            if (_pickedFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextButton.icon(
                  onPressed: () => setState(() => _pickedFile = null),
                  icon: Icon(Icons.delete, color: Colors.red),
                  label: Text("Remove image", style: TextStyle(color: Colors.red)),
                ),
              ),

            SizedBox(height: 20),

            // Category Dropdown
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: selectedCategory,
                hint: Text("Select Category",
                    style: TextStyle(color: Colors.black)),
                isExpanded: true,
                underline: SizedBox(),
                items: ["Clothes", "Electronics", "Furniture", "Others"]
                    .map((category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedCategory = value);
                },
              ),
            ),

            SizedBox(height: 20),

            // Product Name
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Product Name",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // Description
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // Price
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              enabled: !isDonate,
              decoration: InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15),

            // Donate Toggle
            Row(
              children: [
                Checkbox(
                  value: isDonate,
                  onChanged: (value) {
                    setState(() {
                      isDonate = value!;
                      if (isDonate) {
                        priceController.text = "0";
                      } else {
                        priceController.clear();
                      }
                    });
                  },
                ),
                Text("Donate (Price will be 0)")
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
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

  Future<bool> uploadData() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a product name")),
      );
      return false;
    }

    try {
      await FirebaseFirestore.instance
          .collection('products')
          .add({
        'name': nameController.text.trim(),
        'description': descriptionController.text.trim(),
        'price': isDonate ? 0 : int.tryParse(priceController.text) ?? 0,
        'isDonate': isDonate,
        'createdAt': FieldValue.serverTimestamp(),
      })
          .timeout(Duration(seconds: 10));

      return true;
    }  catch (e) {
      if (mounted) {

      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Products Details", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          isLoading
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
            child: Text("Confirm", style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Image upload
            GestureDetector(
              onTap: () {
                // Image upload later
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text("+ Upload Picture", style: TextStyle(fontSize: 18)),
                ),
              ),
            ),

            SizedBox(height: 30),

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

            // Donate Option
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
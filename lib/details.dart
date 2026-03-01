import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Green background
        title: Text(
          "Product Details",
          style: TextStyle(color: Colors.white), // White text
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // White back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // After confirm → Go to Homepage
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => homepage()),
                    (route) => false,
              );
            },
            child: Text(
              "Confirm",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Upload Picture
            GestureDetector(
              onTap: () {
                // Image upload logic will be added later
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "+ Upload Picture",
                    style: TextStyle(fontSize: 18),
                  ),
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
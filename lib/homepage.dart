import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green/models/productModel.dart'; // Updated import
import 'choose.dart';
import 'SearchPage.dart';

class homepage extends StatelessWidget {
  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          children: [

            // Top PageView slider
            SizedBox(
              height: 300,
              child: PageView.builder(
                physics: PageScrollPhysics(),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Image.asset(
                    "assets/images/pic${index + 1}.png",
                    fit: BoxFit.fitWidth,
                  );
                },
              ),
            ),

            SizedBox(height: 10),

            // Search box
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SearchPage()),
                  );
                },
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search products...",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            // TabBar
            TabBar(
              labelColor: Colors.green,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.green,
              tabs: [
                Tab(text: "Furniture"),
                Tab(text: "Cloths"),
                Tab(text: "Electronics"),
                Tab(text: "Others"),
              ],
            ),

            // TabBarView with Firestore products
            Expanded(
              child: TabBarView(
                children: [
                  buildProductList("Furniture"),
                  buildProductList("Cloths"),
                  buildProductList("Electronics"),
                  buildProductList("Others"),
                ],
              ),
            ),

          ],
        ),

        // Bottom Navigation Bar
        bottomNavigationBar: Container(
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              buildNavItem(Icons.home, "Home", Colors.green, () {}),

              buildNavItem(Icons.search, "Explore", Colors.green, () {
                Navigator.pushNamed(context, "search");
              }),

              buildNavItem(CupertinoIcons.cart, "My Cart", Colors.green, () {
                Navigator.pushNamed(context, "cartPage");
              }),

              buildNavItem(Icons.person, "Account", Colors.green, () {
                Navigator.pushNamed(context, "account");
              }),

              buildNavItem(Icons.swap_horiz, "Switch", Colors.green, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChoosePage()),
                );
              }),

            ],
          ),
        ),
      ),
    );
  }

  // Widget to build a navigation item
  Widget buildNavItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build products list filtered by category
  Widget buildProductList(String category) {
    return StreamBuilder<List<Product>>(
      stream: _productService.getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No products found"));
        }

        // Filter products by category
        final products = snapshot.data!
            .where((product) => product.category == category)
            .toList();

        if (products.isEmpty) {
          return Center(child: Text("No products in $category"));
        }

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: ListTile(
                leading: Image.network(
                  product.imageUrl,
                  width: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(product.name),
                subtitle: Text(product.description),
                trailing: Text(
                  product.isDonate ? "Free" : "\$${product.price.toStringAsFixed(2)}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
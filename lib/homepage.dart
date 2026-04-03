import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green/hpCategory.dart';
import 'package:green/models/productModel.dart';
import 'choose.dart';
import 'SearchPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class homepage extends StatelessWidget {
  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    print("UID: ${FirebaseAuth.instance.currentUser?.uid}");
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          children: [
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

            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3), // ✅ FIXED
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

            Expanded(
              child: StreamBuilder<List<Product>>(
                stream: _productService.getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: Colors.green));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No products found"));
                  }

                  final allProducts = snapshot.data!;

                  final categories = ["Furniture", "Cloths", "Electronics", "Others"];

                  return TabBarView(
                    children: categories.map((cat) {
                      final filtered = allProducts
                          .where((p) => p.category.toLowerCase() == cat.toLowerCase())
                          .toList();
                      return HpCategory(products: filtered);
                    }).toList(),
                  );
                },
              ),
            ),

          ],
        ),

        bottomNavigationBar: Container(
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.home, color: Colors.green, size: 30),
                    Text(
                      "Home",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "favourite");
                  },
                  child: Column(
                    children: [
                      Icon(Icons.favorite, color: Colors.green, size: 30),
                      Text(
                        "Favourite",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "cartPage");
                  },
                  child: Column(
                    children: [
                      Icon(CupertinoIcons.cart, color: Colors.green, size: 30),
                      Text(
                        "My Cart",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "account");
                  },
                  child: Column(
                    children: [
                      Icon(Icons.person, color: Colors.green, size: 30),
                      Text(
                        "Account",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChoosePage()),
                    );
                  },
                  child: Column(
                    children: [
                      Icon(Icons.swap_horiz, color: Colors.green, size: 30),
                      Text(
                        "Switch",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green/hpCategory.dart';
import 'package:green/models/productModel.dart';
import 'choose.dart';
import 'SearchPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class homepage extends StatelessWidget {
  homepage({super.key});

  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    print("UID: ${FirebaseAuth.instance.currentUser?.uid}");

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: SizedBox(
                        height: 160,
                        width: double.infinity,
                        child: PageView.builder(
                          physics: const PageScrollPhysics(),
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Image.asset(
                              "assets/images/pic${index + 1}.png",
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 28,
                    right: 28,
                    bottom: -28,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.25),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SearchPage()),
                          );
                        },
                        child: const AbsorbPointer(
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
                  ),
                ],
              ),

              const SizedBox(height: 42),

              const TabBar(
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
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No products found"));
                    }

                    final allProducts = snapshot.data!;
                    final categories = [
                      "Furniture",
                      "Cloths",
                      "Electronics",
                      "Others",
                    ];

                    return TabBarView(
                      children: categories.map((cat) {
                        final filtered = allProducts
                            .where(
                              (p) => p.category.toLowerCase() == cat.toLowerCase(),
                        )
                            .toList();

                        return HpCategory(products: filtered);
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        bottomNavigationBar: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: const [
                    Icon(Icons.home, color: Colors.green, size: 30),
                    Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
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
                    children: const [
                      Icon(Icons.favorite, color: Colors.green, size: 30),
                      Text(
                        "Favourite",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
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
                    children: const [
                      Icon(CupertinoIcons.cart, color: Colors.green, size: 30),
                      Text(
                        "My Cart",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
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
                    children: const [
                      Icon(Icons.person, color: Colors.green, size: 30),
                      Text(
                        "Account",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
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
                    children: const [
                      Icon(Icons.swap_horiz, color: Colors.green, size: 30),
                      Text(
                        "Switch",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
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
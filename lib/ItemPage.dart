import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green/models/productModel.dart';
import 'favourite_service.dart';
import 'hpCategory.dart';

class ItemPage extends StatelessWidget {
  final Product product;

  ItemPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final ProductService _productService = ProductService();

    return Scaffold(
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            height: 320,
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_back, size: 28),
                      ),
                      FavouriteButton(
                          product: product, favService: FavouriteService()),
                    ],
                  ),
                ),
                Expanded(
                  child: Image.network(
                    product.imageUrl,
                    height: 200,
                    width: 280,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.image_not_supported,
                            size: 100, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(product.name,
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Text(
                  product.isDonate
                      ? "Free"
                      : "\$${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Product Details",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(product.description, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          SizedBox(height: 15),
          StreamBuilder<List<Product>>(
            stream: _productService.getProducts(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox();

              final related = snapshot.data!
                  .where((p) => p.category == product.category && p.id != product.id)
                  .toList();

              if (related.isEmpty) return SizedBox();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text("Only For You",
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 5),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: related.map((p) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ItemPage(product: p),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 140,
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(top: 8, bottom: 8, left: 20),
                            decoration: BoxDecoration(
                              color: Colors.green[300],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 8),
                              ],
                            ),
                            child: Image.network(
                              p.imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.image_not_supported, color: Colors.white),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "cartPage"),
              child: Container(
                height: 60,
                width: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.green[300],
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(CupertinoIcons.cart_fill,
                    color: Colors.white, size: 35),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 60,
                width: 220,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.green[300],
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Buy Now",
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
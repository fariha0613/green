import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green/models/productModel.dart';
import 'cart_service.dart';
import 'favourite_service.dart';
import 'hpCategory.dart';

class ItemPage extends StatelessWidget {
  final Product product;

  ItemPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final ProductService productService = ProductService();
    final CartService cartService = CartService();

    Future<void> addProductToCartAndOpenCart() async {
      try {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please login first")),
          );
          return;
        }

        await cartService.addToCart(product);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${product.name} added to cart")),
        );

        Navigator.pushNamed(context, "cartPage");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add to cart: $e")),
        );
      }
    }

    Future<void> addProductToCartOnly() async {
      try {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please login first")),
          );
          return;
        }

        await cartService.addToCart(product);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${product.name} added to cart")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add to cart: $e")),
        );
      }
    }

    return Scaffold(
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            height: 320,
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, size: 28),
                      ),
                      FavouriteButton(
                        product: product,
                        favService: FavouriteService(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Image.network(
                    product.imageUrl,
                    height: 200,
                    width: 280,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 20),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  product.isDonate
                      ? "Free"
                      : "\$${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            margin: const EdgeInsets.symmetric(horizontal: 20),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Product Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(product.description, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          StreamBuilder<List<Product>>(
            stream: productService.getProducts(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();

              final related = snapshot.data!
                  .where((p) => p.category == product.category && p.id != product.id)
                  .toList();

              if (related.isEmpty) return const SizedBox();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      "Only For You",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
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
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                              left: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[300],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Image.network(
                              p.imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.image_not_supported,
                                color: Colors.white,
                              ),
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () async {
                await addProductToCartAndOpenCart();
              },
              child: Container(
                height: 60,
                width: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  CupertinoIcons.cart_fill,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await addProductToCartOnly();
              },
              child: Container(
                height: 60,
                width: 220,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Buy Now",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
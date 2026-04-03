import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'cart_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();

  static const double deliveryFee = 10.0;
  static const double discount = 0.0;

  double _getSubtotal(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    double subtotal = 0;

    for (final doc in docs) {
      final data = doc.data();
      final bool selected = data['selected'] ?? false;
      final bool isDonate = data['isDonate'] ?? false;
      final int quantity = data['quantity'] ?? 1;
      final num price = data['price'] ?? 0;

      if (selected) {
        subtotal += (isDonate ? 0.0 : price.toDouble()) * quantity;
      }
    }

    return subtotal;
  }

  bool _allSelected(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    if (docs.isEmpty) return false;
    return docs.every((doc) => (doc.data()['selected'] ?? false) == true);
  }

  int _selectedItemCount(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    return docs.where((doc) => (doc.data()['selected'] ?? false) == true).length;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("My Cart"),
          backgroundColor: Colors.green,
        ),
        body: const Center(
          child: Text(
            "Please login first to use your cart.",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _cartService.getCartStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Something went wrong:\n${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data?.docs ?? [];
            final subtotal = _getSubtotal(docs);
            final total = docs.isEmpty
                ? 0.0
                : (subtotal + deliveryFee - discount).clamp(0.0, double.infinity);
            final allSelected = _allSelected(docs);
            final selectedCount = _selectedItemCount(docs);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, size: 28),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        "My Cart",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[300],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 1,
                            )
                          ],
                        ),
                        child: Icon(
                          Icons.shopping_cart,
                          size: 30,
                          color: Colors.green[300],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: docs.isEmpty
                      ? const Center(
                    child: Text(
                      "Your cart is empty",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                      : ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        color: Colors.white,
                        child: Column(
                          children: [
                            CheckboxListTile(
                              activeColor: Colors.green,
                              title: Text(
                                "Select all items ($selectedCount selected)",
                                style: const TextStyle(fontSize: 18),
                              ),
                              value: allSelected,
                              onChanged: (value) async {
                                await _cartService.selectAll(value ?? false);
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            const Divider(height: 30, thickness: 1),
                            ...docs.map((doc) {
                              final data = doc.data();
                              final String productId = doc.id;
                              final String name = data['name'] ?? '';
                              final String imageUrl = data['imageUrl'] ?? '';
                              final num rawPrice = data['price'] ?? 0;
                              final bool isDonate = data['isDonate'] ?? false;
                              final int quantity = data['quantity'] ?? 1;
                              final bool selected = data['selected'] ?? false;

                              final double price =
                              isDonate ? 0.0 : rawPrice.toDouble();

                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 12,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                          activeColor: Colors.green[300],
                                          value: selected,
                                          onChanged: (newValue) async {
                                            await _cartService.updateSelected(
                                              productId,
                                              newValue ?? false,
                                            );
                                          },
                                        ),
                                        Container(
                                          height: 80,
                                          width: 80,
                                          padding: const EdgeInsets.all(5),
                                          margin: const EdgeInsets.only(left: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.green[100],
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                              ),
                                            ],
                                          ),
                                          child: imageUrl.isNotEmpty
                                              ? Image.network(
                                            imageUrl,
                                            fit: BoxFit.contain,
                                            errorBuilder: (context,
                                                error,
                                                stackTrace) =>
                                            const Icon(Icons
                                                .image_not_supported),
                                          )
                                              : const Icon(
                                              Icons.image_not_supported),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                maxLines: 2,
                                                overflow:
                                                TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                isDonate
                                                    ? "Free (Donate)"
                                                    : "\$${price.toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green[400],
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "Item total: \$${(price * quantity).toStringAsFixed(2)}",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                await _cartService
                                                    .removeFromCart(productId);
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    await _cartService
                                                        .decreaseQuantity(
                                                        productId);
                                                  },
                                                  child: Container(
                                                    height: 28,
                                                    width: 28,
                                                    alignment:
                                                    Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color:
                                                      Colors.green[300],
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(5),
                                                    ),
                                                    child: const Icon(
                                                      Icons.remove,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                                  child: Text(
                                                    quantity
                                                        .toString()
                                                        .padLeft(2, '0'),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    await _cartService
                                                        .increaseQuantity(
                                                        productId);
                                                  },
                                                  child: Container(
                                                    height: 28,
                                                    width: 28,
                                                    alignment:
                                                    Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color:
                                                      Colors.green[300],
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(5),
                                                    ),
                                                    child: const Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    const Divider(thickness: 1),
                                  ],
                                ),
                              );
                            }).toList(),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Sub-Total:",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "\$${subtotal.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 20, thickness: 1),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Delivery Fee:",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        docs.isEmpty
                                            ? "\$0.00"
                                            : "\$${deliveryFee.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 20, thickness: 1),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Discount:",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "-\$${discount.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _cartService.getCartStream(),
        builder: (context, snapshot) {
          final docs = snapshot.data?.docs ?? [];
          final subtotal = _getSubtotal(docs);
          final total = docs.isEmpty
              ? 0.0
              : (subtotal + deliveryFee - discount).clamp(0.0, double.infinity);

          return Container(
            height: 130,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total : \$${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Checkout logic not added yet."),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Check out",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
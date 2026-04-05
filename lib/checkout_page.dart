import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:green/models/productModel.dart';
import 'cart_service.dart';
import 'order_service.dart';

class CheckoutPage extends StatefulWidget {
  final Product? buyNowProduct;

  const CheckoutPage({super.key, this.buyNowProduct});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final CartService _cartService = CartService();
  final OrderService _orderService = OrderService();

  bool _isPlacingOrder = false;
  String _paymentMethod = 'Cash on Delivery';

  static const double deliveryFee = 70.0;
  static const double discount = 0.0;

  bool get _isBuyNowMode => widget.buyNowProduct != null;

  List<Map<String, dynamic>> _buildCartItemsFromDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    return docs.map((doc) {
      final data = doc.data();
      final bool isDonate = data['isDonate'] ?? false;
      final int quantity = data['quantity'] ?? 1;
      final num rawPrice = data['price'] ?? 0;
      final double price = isDonate ? 0.0 : rawPrice.toDouble();

      return {
        'productId': data['productId'] ?? doc.id,
        'name': data['name'] ?? '',
        'imageUrl': data['imageUrl'] ?? '',
        'price': price,
        'category': data['category'] ?? '',
        'description': data['description'] ?? '',
        'isDonate': isDonate,
        'sellerId': data['sellerId'] ?? '',
        'quantity': quantity,
        'itemTotal': price * quantity,
      };
    }).toList();
  }

  List<Map<String, dynamic>> _buildBuyNowItems() {
    final product = widget.buyNowProduct!;
    final double price = product.isDonate ? 0.0 : product.price.toDouble();

    return [
      {
        'productId': product.id ?? '',
        'name': product.name,
        'imageUrl': product.imageUrl,
        'price': price,
        'category': product.category,
        'description': product.description,
        'isDonate': product.isDonate,
        'sellerId': product.sellerId,
        'quantity': 1,
        'itemTotal': price,
      }
    ];
  }

  double _getSubtotalFromItems(List<Map<String, dynamic>> items) {
    double subtotal = 0.0;
    for (final item in items) {
      subtotal += (item['itemTotal'] ?? 0).toDouble();
    }
    return subtotal;
  }

  Future<void> _placeOrder({
    required List<Map<String, dynamic>> items,
    List<DocumentReference<Map<String, dynamic>>> cartRefsToDelete = const [],
  }) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isPlacingOrder = true);

    try {
      final subtotal = _getSubtotalFromItems(items);
      final total =
          (subtotal + deliveryFee - discount).clamp(0.0, double.infinity);

      await _orderService.placeOrder(
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        fullAddress: _addressController.text.trim(),
        cityArea: _zipController.text.trim(),
        landmark: _landmarkController.text.trim(),
        deliveryNote: _noteController.text.trim(),
        paymentMethod: _paymentMethod,
        items: items,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        discount: discount,
        total: total,
        cartRefsToDelete: cartRefsToDelete,
      );

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Order Placed"),
          content: const Text("Your order has been placed successfully."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }

  Widget _field(String label, TextEditingController c,
      {bool requiredField = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        validator: (v) {
          if (!requiredField) return null;
          if (v == null || v.isEmpty) return "Required";
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String t, String v, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(t, style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
        Text(v, style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _isBuyNowMode ? null : _cartService.getSelectedCartStream(),
        builder: (context, snapshot) {
          List<Map<String, dynamic>> items = [];
          List<DocumentReference<Map<String, dynamic>>> refs = [];

          if (_isBuyNowMode) {
            items = _buildBuyNowItems();
          } else {
            final docs = snapshot.data?.docs ?? [];
            items = _buildCartItemsFromDocs(docs);
            refs = docs.map((e) => e.reference).toList();
          }

          final subtotal = _getSubtotalFromItems(items);
          final total =
              (subtotal + deliveryFee - discount).clamp(0.0, double.infinity);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Customer Info",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  _field("Full Name", _fullNameController),
                  _field("Phone Number", _phoneController),
                  _field("Email Address", _emailController),

                  const SizedBox(height: 15),

                  const Text(
                    "Delivery Info",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  _field("Country", _countryController),
                  _field("Full Address", _addressController),
                  _field("House / Flat No.", _houseController),
                  _field("Zip Code / Postal Code", _zipController),
                  _field(
                    "Nearby Landmark (Optional)",
                    _landmarkController,
                    requiredField: false,
                  ),
                  _field(
                    "Delivery Note (Optional)",
                    _noteController,
                    requiredField: false,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Order Summary",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  _summaryRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
                  const Divider(),
                  _summaryRow("Delivery Fee", "\$70"),
                  const Divider(),
                  _summaryRow(
                    "Final Total",
                    "\$${total.toStringAsFixed(2)}",
                    bold: true,
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isPlacingOrder
                          ? null
                          : () => _placeOrder(
                                items: items,
                                cartRefsToDelete: refs,
                              ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: _isPlacingOrder
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Place Order"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
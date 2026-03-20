import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? id;
  String name;
  String description;
  String category;
  double price;
  bool isDonate;
  String imageUrl;
  Timestamp createdAt;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.isDonate,
    required this.imageUrl,
    Timestamp? createdAt,
  }) : createdAt = createdAt ?? Timestamp.now();

  // Convert Product object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name.trim(),
      'description': description.trim(),
      'category': category,
      'price': price,
      'isDonate': isDonate,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Create Product object from Firestore document snapshot
  factory Product.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      isDonate: data['isDonate'] ?? false,
      imageUrl: data['imageUrl'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}

class ProductService {
  final CollectionReference _productCollection =
  FirebaseFirestore.instance.collection('products');

  // Add a new product
  Future<void> addProduct(Product product) async {
    await _productCollection.add(product.toMap());
  }

  // Fetch all products as a stream
  Stream<List<Product>> getProducts() {
    return _productCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromDocument(doc)).toList());
  }
}
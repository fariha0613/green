import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green/models/productModel.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _cartRef {
    return _firestore.collection('users').doc(_uid).collection('cart');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCartStream() {
    return _cartRef.orderBy('addedAt', descending: true).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSelectedCartStream() {
    return _cartRef.where('selected', isEqualTo: true).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSelectedCartItemsOnce() {
    return _cartRef.where('selected', isEqualTo: true).get();
  }

  Future<void> addToCart(Product product) async {
    if (product.id == null || product.id!.isEmpty) {
      throw Exception("Product ID is missing");
    }

    final docRef = _cartRef.doc(product.id);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (snapshot.exists) {
        final currentQty = (snapshot.data()?['quantity'] ?? 1) as int;
        transaction.update(docRef, {
          'quantity': currentQty + 1,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        transaction.set(docRef, {
          'productId': product.id,
          'name': product.name,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'category': product.category,
          'description': product.description,
          'isDonate': product.isDonate,
          'sellerId': product.sellerId,
          'quantity': 1,
          'selected': true,
          'addedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  Future<void> removeFromCart(String productId) async {
    await _cartRef.doc(productId).delete();
  }

  Future<void> increaseQuantity(String productId) async {
    await _cartRef.doc(productId).update({
      'quantity': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> decreaseQuantity(String productId) async {
    final docRef = _cartRef.doc(productId);
    final snapshot = await docRef.get();

    if (!snapshot.exists) return;

    final currentQty = (snapshot.data()?['quantity'] ?? 1) as int;

    if (currentQty <= 1) {
      await docRef.delete();
    } else {
      await docRef.update({
        'quantity': currentQty - 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> updateSelected(String productId, bool value) async {
    await _cartRef.doc(productId).update({
      'selected': value,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> selectAll(bool value) async {
    final snapshot = await _cartRef.get();
    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {
        'selected': value,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }
}
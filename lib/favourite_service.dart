import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavouriteService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser!.uid;

// Add to favourites
  Future<void> addToFavourites(Map<String, dynamic> product, String productId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favourites')
        .doc(productId)
        .set(product);
  }

// Remove from favourites
  Future<void> removeFromFavourites(String productId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favourites')
        .doc(productId)
        .delete();
  }

// Check if favourite
  Stream<bool> isFavourite(String productId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favourites')
        .doc(productId)
        .snapshots()
        .map((doc) => doc.exists);
  }

// Get all favourites
  Stream<QuerySnapshot> getFavourites() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favourites')
        .snapshots();
  }
}

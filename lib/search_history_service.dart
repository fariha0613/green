import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  Future<List<String>> getSearchHistory() async {
    if (_uid == null) return [];

    final doc = await _firestore.collection('searchHistory').doc(_uid).get();

    if (!doc.exists) return [];

    final data = doc.data();
    if (data == null) return [];

    final searches = data['searches'];
    if (searches is List) {
      return List<String>.from(searches);
    }

    return [];
  }

  Future<void> saveSearch(String query) async {
    if (_uid == null) return;

    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return;

    final docRef = _firestore.collection('searchHistory').doc(_uid);
    final doc = await docRef.get();

    List<String> searches = [];

    if (doc.exists && doc.data() != null && doc.data()!['searches'] is List) {
      searches = List<String>.from(doc.data()!['searches']);
    }

    searches.removeWhere(
          (item) => item.toLowerCase() == trimmedQuery.toLowerCase(),
    );

    searches.insert(0, trimmedQuery);

    if (searches.length > 3) {
      searches = searches.sublist(0, 3);
    }

    await docRef.set({
      'searches': searches,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeSingleSearch(String query) async {
    if (_uid == null) return;

    final docRef = _firestore.collection('searchHistory').doc(_uid);
    final doc = await docRef.get();

    if (!doc.exists || doc.data() == null) return;

    List<String> searches = [];
    if (doc.data()!['searches'] is List) {
      searches = List<String>.from(doc.data()!['searches']);
    }

    searches.removeWhere(
          (item) => item.toLowerCase() == query.trim().toLowerCase(),
    );

    await docRef.set({
      'searches': searches,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> clearAllSearches() async {
    if (_uid == null) return;

    await _firestore.collection('searchHistory').doc(_uid).set({
      'searches': [],
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
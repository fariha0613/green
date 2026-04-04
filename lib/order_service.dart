import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> placeOrder({
    required String fullName,
    required String phoneNumber,
    required String fullAddress,
    required String cityArea,
    required String landmark,
    required String deliveryNote,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double deliveryFee,
    required double discount,
    required double total,
    List<DocumentReference<Map<String, dynamic>>> cartRefsToDelete = const [],
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    if (items.isEmpty) {
      throw Exception("No order items found");
    }

    final orderRef = _firestore.collection('orders').doc();

    final int totalQuantity = items.fold<int>(
      0,
          (sum, item) => sum + ((item['quantity'] ?? 0) as int),
    );

    final batch = _firestore.batch();

    batch.set(orderRef, {
      'orderId': orderRef.id,
      'userId': user.uid,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'fullAddress': fullAddress,
      'cityArea': cityArea,
      'landmark': landmark,
      'deliveryNote': deliveryNote,
      'paymentMethod': paymentMethod,
      'items': items,
      'itemCount': items.length,
      'totalQuantity': totalQuantity,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'total': total,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    for (final ref in cartRefsToDelete) {
      batch.delete(ref);
    }

    await batch.commit();
  }
}
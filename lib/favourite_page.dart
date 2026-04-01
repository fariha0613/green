import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'favourite_service.dart';

class FavouritePage extends StatelessWidget {
  final FavouriteService favService = FavouriteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Favourites"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: favService.getFavourites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No favourites yet"));
          }

          final favs = snapshot.data!.docs;

          return GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          ),
          itemCount: favs.length,
          itemBuilder: (context, index) {
          final data = favs[index];

          return Card(
          child: Column(
          children: [
          Image.network(data['image'], height: 100),
          Text(data['name']),
          Text("\$${data['price']}"),
          ],
          ),
          );
          },
          );
        },
      ),
    );
  }
}

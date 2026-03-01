import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static List<String> persistentSearches = [];

  TextEditingController searchController = TextEditingController();

  // popular products
  List<String> popularImages = [
    "assets/images/pic7.png",
    "assets/images/pic8.png",
    "assets/images/pic9.png",
    "assets/images/pic10.png"
  ];

  void addSearch(String query) {
    if (query.trim().isEmpty) return;

    setState(() {
      // Remove duplicate
      persistentSearches.remove(query);

      // Add to start
      persistentSearches.insert(0, query);

      // last 3 rakhbo
      if (persistentSearches.length > 3)
        persistentSearches = persistentSearches.sublist(0, 3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F5F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search products...",
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              border: InputBorder.none,
            ),
            onSubmitted: (value) {
              addSearch(value);
              searchController.clear(); // search diye enter dile input clear
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Popular Products Section
              Text(
                "Popular Products",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (String img in popularImages)
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.green[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(img, fit: BoxFit.contain),
                      )
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Recent Searches Section
              Text(
                "Recent Searches",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  if (persistentSearches.isEmpty)
                    Text("No recent searches", style: TextStyle(color: Colors.grey)),
                  for (String recent in persistentSearches)
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.history, color: Colors.green),
                          SizedBox(width: 10),
                          Text(
                            recent,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
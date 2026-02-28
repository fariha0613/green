import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {


  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // Background Image
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              "assets/images/account.png", // you can change image later
              fit: BoxFit.cover,
            ),
          ),

          // Dark overlay (less transparency)
          Container(
            color: Colors.black.withOpacity(0.6),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  // Back Button
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Profile Picture
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: Colors.green),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Sadia Akter",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    "sadia@email.com",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 30),

                  // White Card Area
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      children: [

                        // Earned Points
                        ListTile(
                          leading: const Icon(Icons.stars, color: Colors.green),
                          title: const Text("Earned Points"),
                          trailing: const Text("250"),
                        ),

                        const Divider(),

                        // Previous Orders
                        ListTile(
                          leading: const Icon(Icons.shopping_bag, color: Colors.green),
                          title: const Text("Previous Orders"),
                          trailing: const Text("5 Orders"),
                        ),

                        const Divider(),

                        // Address
                        ListTile(
                          leading: const Icon(Icons.location_on, color: Colors.green),
                          title: const Text("Delivery Address"),
                          subtitle: const Text("Dhaka, Bangladesh"),
                        ),

                        const Divider(),

                        // Logout
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text("Log Out"),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
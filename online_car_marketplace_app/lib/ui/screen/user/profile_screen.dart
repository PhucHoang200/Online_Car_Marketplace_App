import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<Map<String, dynamic>?> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(body: Center(child: Text("No user data found")));
        }

        final userData = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: () => Navigator.pop(context)),
            title: const Text('Profile'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(radius: 40, backgroundColor: Colors.teal),
                const SizedBox(height: 8),
                Text(userData['name'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Text("Buyer / Seller"),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.phone),
                    const SizedBox(width: 8),
                    Text(userData['phone'] ?? ''),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.email),
                    const SizedBox(width: 8),
                    Text(userData['email'] ?? ''),
                  ],
                ),
                const Spacer(),
                ListTile(leading: const Icon(Icons.favorite), title: const Text("Favorites")),
                ListTile(leading: const Icon(Icons.payment), title: const Text("Payments")),
                ListTile(leading: const Icon(Icons.share), title: const Text("Tell your friends")),
                ListTile(leading: const Icon(Icons.settings), title: const Text("Settings")),
                ListTile(leading: const Icon(Icons.logout), title: const Text("Logout")),
              ],
            ),
          ),
        );
      },
    );
  }
}

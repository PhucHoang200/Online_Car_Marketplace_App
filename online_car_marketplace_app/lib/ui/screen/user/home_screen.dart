import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // thêm go_router

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text("Hello, Sayan", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text("Here You can sell and buy second-hand car"),
            const SizedBox(height: 32),
            const Text("What would you like to do?", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _buildOption(context, "For sale", "Get the best price for your car instantly", '/sell'),
            const SizedBox(height: 16),
            _buildOption(context, "For buy", "Choose from 1000+ MRL certified cars", '/buy'),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, String title, String subtitle, String routePath) {
    return GestureDetector(
      onTap: () => context.go(routePath),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Icon(Icons.favorite_border, color: Colors.orange),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(subtitle),
                  ],
                ),
              ),
              const Icon(Icons.favorite_border, color: Colors.orange),
            ],
          ),
        ),
      ),
    );
  }
}

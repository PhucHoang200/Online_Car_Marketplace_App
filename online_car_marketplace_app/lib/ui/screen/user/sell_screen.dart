import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../../models/post_model.dart';
import '../../../providers/post_provider.dart';
import 'package:online_car_marketplace_app/navigation/app_router.dart';
import 'package:online_car_marketplace_app/providers/brand_provider.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final carNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<BrandProvider>(context, listen: false).fetchBrands();
  }

  @override
  void dispose() {
    carNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              _buildBanner(),
              const SizedBox(height: 16),
              _buildCarNumberInput(),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {}, // TODO: handle price fetch
                child: const Text('Get a price'),
              ),
              const SizedBox(height: 16),
              const Center(child: Text("Or", style: TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(height: 16),
              _buildBrandSelector(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Image.asset('assets/images/car mask.png', height: 180, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Sell your car at", style: TextStyle(color: Colors.white, fontSize: 18)),
                Text("Best price", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarNumberInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Enter your car number"),
        const SizedBox(height: 6),
        TextField(
          controller: carNumberController,
          decoration: InputDecoration(
            hintText: "e.g. DL45 VC 4321",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () => context.go('/buy'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
            child: const Text("Switch to Buy", style: TextStyle(color: Colors.black)),
          ),
        ),
      ],
    );
  }

  Widget _buildBrandSelector() {
    return Consumer<BrandProvider>(
      builder: (context, brandProvider, child) {
        if (brandProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final brands = brandProvider.brands;

        if (brands.isEmpty) {
          return const Center(child: Text('No brands available'));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: brands.map((brand) {
              final brandName = brand.name.toUpperCase();
              final brandAvatarPath = 'assets/brands/${brand.name.toLowerCase()}.png';

              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        brandAvatarPath,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(brandName, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }


  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {},
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Sell'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorite'),
        BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Help'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      ],
    );
  }
}

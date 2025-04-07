import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_car_marketplace_app/data/models/car_model.dart';
import 'package:online_car_marketplace_app/data/repositories/car_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_car_marketplace_app/data/repositories/image_repository.dart';

class CarDetailScreen extends StatelessWidget {
  final int carId;

  CarDetailScreen({required this.carId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<String>>(
        future: ImageRepository().getCarImages(carId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final imageUrls = snapshot.data ?? [];
          return ListView.builder(
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Image.network(
                imageUrls[index],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          );
        },
      ),
    );
  }
}
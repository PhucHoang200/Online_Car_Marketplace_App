// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../repositories/car_provider.dart';
// import '../widgets/car_card.dart';
//
// class CarListingScreen extends StatefulWidget {
//   const CarListingScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CarListingScreen> createState() => _CarListingScreenState();
// }
//
// class _CarListingScreenState extends State<CarListingScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Load cars when the screen is first loaded
//     Future.microtask(
//           () => context.read<CarProvider>().loadCars(),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Car Listing'),
//       ),
//       body: Consumer<CarProvider>(
//         builder: (context, carProvider, child) {
//           if (carProvider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (carProvider.error.isNotEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(carProvider.error),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () => carProvider.loadCars(),
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           if (carProvider.cars.isEmpty) {
//             return const Center(
//               child: Text('No cars available'),
//             );
//           }
//
//           return ListView.builder(
//             itemCount: carProvider.cars.length,
//             itemBuilder: (context, index) {
//               final car = carProvider.cars[index];
//               return CarCard(car: car);
//             },
//           );
//         },
//       ),
//     );
//   }
// }
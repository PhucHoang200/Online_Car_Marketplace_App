import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:online_car_marketplace_app/ui/screen/user/introduction.dart';

void main() {
  runApp(const MyApp());
=======
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:online_car_marketplace_app/providers/post_provider.dart';
import 'package:online_car_marketplace_app/providers/brand_provider.dart';
import 'package:online_car_marketplace_app/services/firebase_options.dart';
import 'package:online_car_marketplace_app/navigation/app_router.dart'; // thêm dòng này

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => BrandProvider()),
      ],
      child: const MyApp(),
    ),
  );
>>>>>>> 607664d37ac64913bad8538443f8493e3a325e76
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp(
      title: 'Online Car Marketplace',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LandingPage(),
    );
  }
}

=======
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
>>>>>>> 607664d37ac64913bad8538443f8493e3a325e76

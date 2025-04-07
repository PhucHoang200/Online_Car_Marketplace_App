import 'package:flutter/material.dart';
import 'core/firebase/firebase_config.dart';
import 'init_data_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize();
  runApp(MaterialApp(home: InitDataScreen()));
}
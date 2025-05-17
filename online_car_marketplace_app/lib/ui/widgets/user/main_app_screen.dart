import 'package:flutter/material.dart';
import 'main_bottom_navigation_bar.dart';

class MainAppScreen extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainAppScreen({super.key, required this.child, required this.currentIndex});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: MainBottomNavigationBar(currentIndex: widget.currentIndex),
    );
  }
}
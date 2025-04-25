import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_car_marketplace_app/ui/screen/user/home_screen.dart';
import 'package:online_car_marketplace_app/ui/screen/user/sell_screen.dart';
import 'package:online_car_marketplace_app/ui/screen/user/buy_screen.dart';
import 'package:online_car_marketplace_app/ui/screen/user/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/buy',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/sell',
      builder: (context, state) => const SellScreen(),
    ),
    GoRoute(
      path: '/buy',
      builder: (context, state) => const BuyScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(), // Thêm route Profile
    ),
  ],
);

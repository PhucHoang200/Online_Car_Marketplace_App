import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_car_marketplace_app/ui/screen/auth/register_screen.dart';
import 'package:online_car_marketplace_app/ui/screen/user/sell_screen.dart';
import 'package:online_car_marketplace_app/ui/screen/user/buy_screen.dart';
import 'package:online_car_marketplace_app/ui/screen/user/profile_screen.dart';
import 'package:online_car_marketplace_app/ui/screen/auth/login_user_screen.dart';
import 'package:online_car_marketplace_app/ui/screen/user/introduction.dart';
import 'package:online_car_marketplace_app/ui/screen/user/model_list_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        final uId = state.extra as String;
        return ProfileScreen(uid: uId);
      },
    ),
    GoRoute(
      path: '/buy',
      builder: (context, state) {
        // Lấy tham số từ extra
        final uId = state.extra as String;  // Truyền qua extra
        return BuyScreen(uid: uId);  // Truyền userId vào BuyScreen
      },
    ),
    GoRoute(
      path: '/sell',
      builder: (context, state) => const SellScreen(),
    ),
    GoRoute(
      path: '/models',
      builder: (context, state) {
        final brandId = state.uri.queryParameters['brandId'];
        final brandName = state.uri.queryParameters['brandName'];
        if (brandId == null || brandName == null) {
          return const Center(child: Text('Error: Missing brandId or brandName'));
        }
        return ModelListScreen(brandId: brandId, name: brandName);
      },
    ),
  ],
);


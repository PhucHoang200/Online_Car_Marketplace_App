import 'package:flutter/material.dart';
import '../models/favorite_model.dart';
import '../repositories/favorite_repository.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteRepository _favoriteRepository = FavoriteRepository();

  List<Favorite> _favorites = [];
  List<Favorite> get favorites => _favorites;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _favoriteRepository.getFavorites();
    } catch (e) {
      print('Error fetching favorites: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFavorite(Favorite favorite) async {
    try {
      await _favoriteRepository.addFavorite(favorite);
      _favorites.add(favorite);
      notifyListeners();
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }
}

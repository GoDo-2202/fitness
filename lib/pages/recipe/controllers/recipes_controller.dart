import 'package:flutter/foundation.dart';
import 'package:fitness/models/recipe.dart';
import 'package:fitness/services/api_service.dart';

class RecipesController extends ChangeNotifier {
  final SpoonacularApi api;

  RecipesController({required this.api});

  final List<Recipe> _recipes = [];
  List<Recipe> get recipes => List.unmodifiable(_recipes);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String _query = "";
  bool get query => _hasMore;
  int _offset = 0;
  final int _pageSize = 10;

  Future<void> loadRecipes({bool isRefresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    if (isRefresh) {
      _offset = 0;
      _recipes.clear();
      _hasMore = true;
    }
    notifyListeners();

    try {
      final result = await api.searchRecipes(_query, _offset);
      _recipes.addAll(result);
      _offset += 1;
      _hasMore = result.length >= _pageSize;
    } catch (e) {
      debugPrint("Error loading recipes: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreRecipes() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final result = await api.searchRecipes(_query, _offset);
      _recipes.addAll(result);
      _offset += 1;
      _hasMore = result.length >= _pageSize;
    } catch (e) {
      debugPrint("Error loading more recipes: $e");
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void updateQuery(String newQuery) {
    _query = newQuery;
    loadRecipes(isRefresh: true);
  }

  void reset() {
    _recipes.clear();
    _offset = 0;
    _hasMore = true;
    notifyListeners();
  }
}

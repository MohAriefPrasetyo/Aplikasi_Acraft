import 'package:flutter/material.dart';
import '../models/craft_model.dart';
import '../services/craft_service.dart';

class HomeViewModel extends ChangeNotifier {
  final _craftService = CraftService();

  bool _isGridLayout = false;
  bool get isGridLayout => _isGridLayout;

  bool isLoading = false;
  String? errorMessage;
  List<Craft> _allCrafts = [];
  String _searchQuery = '';

  List<Craft> get allCrafts => _allCrafts;

  HomeViewModel() {
    loadCrafts();
  }

  Future<void> loadCrafts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      _allCrafts = await _craftService.fetchCrafts();
    } catch (e) {
      debugPrint('Supabase error: $e');
      errorMessage = e.toString();
      _allCrafts = [];
    }
    isLoading = false;
    notifyListeners();
  }

  List<Craft> filteredByTab(String tab) {
    return _allCrafts.where((item) {
      final matchTab = item.category == tab;
      final matchSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchTab && matchSearch;
    }).toList();
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleLayout() {
    _isGridLayout = !_isGridLayout;
    notifyListeners();
  }
}

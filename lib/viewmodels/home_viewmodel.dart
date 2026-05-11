import '../models/craft_model.dart';
import '../services/craft_service.dart';

class HomeViewModel {
  final _craftService = CraftService();

  List<Craft> allCrafts = [];
  bool isGridLayout = false;
  String searchQuery = '';

  Future<void> loadCrafts() async {
    allCrafts = await _craftService.fetchCrafts();
  }

  List<Craft> filteredByTab(String tab) {
    return allCrafts.where((item) {
      final matchTab = item.category == tab;
      final matchSearch = searchQuery.isEmpty ||
          item.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchTab && matchSearch;
    }).toList();
  }
}

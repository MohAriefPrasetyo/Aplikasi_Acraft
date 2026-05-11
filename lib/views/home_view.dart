import 'package:flutter/material.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/craft_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final HomeViewModel _homeVM = HomeViewModel();
  bool _isLoading = false;
  bool _isGridLayout = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await _homeVM.loadCrafts();
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          Image.asset(
            'lib/assets/craft.png',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 200,
              color: const Color(0xFFD2B48C),
              child: const Center(
                child: Icon(Icons.image, size: 60, color: Colors.white),
              ),
            ),
          ),

          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: const Color(0xFFB8860B),
                    labelColor: const Color(0xFFB8860B),
                    unselectedLabelColor: Colors.black87,
                    labelStyle:
                        const TextStyle(fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(text: "Koleksi"),
                      Tab(text: "Populer"),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isGridLayout ? Icons.list : Icons.grid_view,
                    color: const Color(0xFFB8860B),
                  ),
                  onPressed: () {
                    setState(() {
                      _isGridLayout = !_isGridLayout;
                      _homeVM.isGridLayout = _isGridLayout;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person_outline,
                      color: Color(0xFFB8860B)),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/profile'),
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildContent("Koleksi"),
                _buildContent("Populer"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String tab) {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF7B3F00)));
    }
    final items = _homeVM.filteredByTab(tab);
    if (items.isEmpty) {
      return const Center(
          child: Text("Belum ada data",
              style: TextStyle(color: Colors.grey)));
    }
    if (_isGridLayout) {
      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) =>
            CraftCard(craft: items[index], isGrid: true),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) =>
          CraftCard(craft: items[index], isGrid: false),
    );
  }
}

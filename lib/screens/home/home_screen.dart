import 'package:flutter/material.dart';
import 'package:plantyard/screens/profile/profile_screen.dart';
import 'package:plantyard/screens/shop/cart_screen.dart';
import 'package:plantyard/screens/shop/plant_detail_screen.dart';
import 'package:plantyard/screens/shop/all_plants_screen.dart';
import 'package:plantyard/screens/shop/category_plants_screen.dart';
import 'package:plantyard/widgets/plant_card.dart';
import 'package:plantyard/widgets/category_card.dart';
import 'package:plantyard/models/plant_model.dart';
import 'package:plantyard/models/category_model.dart';
import 'package:plantyard/services/cart_service.dart';
import 'package:plantyard/services/plant_data_service.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({super.key, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Category> _categories;
  late List<Plant> _featuredPlants;
  late List<Plant> _recentPlants;
  List<Plant> _searchResults = [];
  bool _isSearching = false;

  final CartService _cartService = CartService();
  int _cartItemCount = 0;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _cartService.addListener(_updateCartCount);
    _cartService.loadCart();
  }

  @override
  void dispose() {
    _cartService.removeListener(_updateCartCount);
    _searchController.dispose();
    super.dispose();
  }

  void _updateCartCount() {
    setState(() {
      _cartItemCount = _cartService.itemCount;
    });
  }

  void _loadData() {
    _categories = PlantDataService.categories;
    _featuredPlants = PlantDataService.featuredPlants;
    _recentPlants = PlantDataService.recentPlants;
  }

  // ===== RECHÈCH =====
  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }
    setState(() {
      _isSearching = true;
      _searchResults = PlantDataService.searchPlants(query);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final crossAxisCount = isTablet ? 4 : 2;
    final categoryWidth = isTablet ? 150 : 120;
    final plantCardWidth = isTablet ? 280 : 220;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PlantYard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              if (_cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _cartItemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mesaj Byenveni
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.eco,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Byenveni ${widget.email.split('@')[0]}!',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    'Jaden ou nan pòch ou',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ===== BA RECHÈCH (fonksyonèl) =====
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Color(0xFF2E7D32)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: _onSearchChanged,
                                decoration: const InputDecoration(
                                  hintText: 'Chèche yon plant...',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 14),
                                ),
                              ),
                            ),
                            if (_isSearching)
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.grey),
                                onPressed: _clearSearch,
                                padding: EdgeInsets.zero,
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ===== REZILTA RECHÈCH =====
                      if (_isSearching) ...[
                        if (_searchResults.isEmpty) ...[
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 40),
                              child: Column(
                                children: [
                                  Icon(Icons.search_off,
                                      size: 60,
                                      color: Colors.grey.shade400),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Plant oswa pwodui pa disponib',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Eseye chèche "tomat", "kaktis" oswa "aloe"',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ] else ...[
                          Text(
                            '${_searchResults.length} rezilta pou "${_searchController.text}"',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: 0.65,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              return PlantCard(
                                plant: _searchResults[index],
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PlantDetailScreen(
                                        plant: _searchResults[index],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ],

                      // ===== KONTNI NÒMAL (kache lè ap chèche) =====
                      if (!_isSearching) ...[
                        // Kategori
                        const Text(
                          'Kategori',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: isTablet ? 150 : 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _categories.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: categoryWidth.toDouble(),
                                margin: const EdgeInsets.only(right: 12),
                                child: CategoryCard(
                                  category: _categories[index],
                                  onTap: () {
                                    // ===== NAVIGASYON VÈ KATEGORI =====
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CategoryPlantsScreen(
                                          category: _categories[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Plant popilè
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Plant popilè',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              // ===== WÈ TOUT =====
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AllPlantsScreen(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF2E7D32),
                              ),
                              child: const Text(
                                'Wè tout',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: isTablet ? 400 : 360,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _featuredPlants.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: plantCardWidth.toDouble(),
                                margin: const EdgeInsets.only(right: 16),
                                child: PlantCard(
                                  plant: _featuredPlants[index],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PlantDetailScreen(
                                          plant: _featuredPlants[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Nouvo plant
                        const Text(
                          'Nouvo plant',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _recentPlants.length,
                          itemBuilder: (context, index) {
                            return PlantCard(
                              plant: _recentPlants[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PlantDetailScreen(
                                      plant: _recentPlants[index],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 10),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ).then((_) => setState(() => _selectedIndex = 0));
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Akèy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Pwofil',
          ),
        ],
      ),
    );
  }
}
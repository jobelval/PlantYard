import 'package:flutter/material.dart';
import 'package:plantyard/screens/shop/products_screen.dart';
import 'package:plantyard/screens/profile/profile_screen.dart';
import 'package:plantyard/screens/shop/cart_screen.dart';
import 'package:plantyard/widgets/category_card.dart';
import 'package:plantyard/widgets/plant_card.dart';
import 'package:plantyard/services/api_service.dart';
import 'package:plantyard/models/plant_model.dart';
import 'package:plantyard/models/category_model.dart';
import 'package:plantyard/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({super.key, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Plant> _featuredPlants = [];
  List<Category> _categories = [];
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // An reyalite, sa pral chaje apèl API
      // Pou kounye a, n ap itilize done senp
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _featuredPlants = [
          Plant(
            id: '1',
            name: 'Monstera Deliciosa',
            scientificName: 'Monstera deliciosa',
            description: 'Yon plant elegant ak fey ajoure',
            price: 45.99,
            category: 'Plant d\'enteryè',
            images: ['https://example.com/monstera.jpg'],
            inStock: true,
            stockQuantity: 10,
            nurseryId: 'nur1',
            nurseryName: 'Pepinyè Vèt',
            careInstructions: {
              'light': 'Mwayen',
              'water': '2 fwa pa semèn',
              'temperature': '18-25°C',
            },
            rating: 4.5,
            reviewsCount: 23,
          ),
          // Ajoute plis plant...
        ];

        _categories = [
          Category(
            id: 'cat1',
            name: 'Plant d\'enteryè',
            icon: '🏠',
            imageUrl: '',
            plantCount: 15,
          ),
          Category(
            id: 'cat2',
            name: 'Plant medsin',
            icon: '🌿',
            imageUrl: '',
            plantCount: 8,
          ),
          Category(
            id: 'cat3',
            name: 'Fwi ak legim',
            icon: '🍅',
            imageUrl: '',
            plantCount: 12,
          ),
          Category(
            id: 'cat4',
            name: 'Plant dekoratif',
            icon: '🎍',
            imageUrl: '',
            plantCount: 20,
          ),
        ];

        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlantYard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: AppStrings.searchHint,
                          border: InputBorder.none,
                          icon: const Icon(Icons.search),
                        ),
                        onTap: () {
                          // Navigate to search screen
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Welcome message
                    Text(
                      'Bonjou, ${widget.email.split('@')[0]}!',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Categories
                    const Text(
                      'Kategori',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          return CategoryCard(
                            category: _categories[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductsScreen(
                                    category: _categories[index],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Featured plants
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Plant popilè',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Voir tout
                          },
                          child: const Text('Wè tout'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: _featuredPlants.length,
                      itemBuilder: (context, index) {
                        return PlantCard(
                          plant: _featuredPlants[index],
                          onTap: () {
                            // Navigate to plant details
                          },
                        );
                      },
                    ),
                  ],
                ),
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
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Akèy'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Pwofil'),
        ],
      ),
    );
  }
}

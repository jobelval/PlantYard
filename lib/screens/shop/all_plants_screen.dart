import 'package:flutter/material.dart';
import 'package:plantyard/models/plant_model.dart';
import 'package:plantyard/screens/shop/plant_detail_screen.dart';
import 'package:plantyard/widgets/plant_card.dart';
import 'package:plantyard/services/plant_data_service.dart';

class AllPlantsScreen extends StatefulWidget {
  const AllPlantsScreen({super.key});

  @override
  State<AllPlantsScreen> createState() => _AllPlantsScreenState();
}

class _AllPlantsScreenState extends State<AllPlantsScreen> {
  final List<Plant> _allPlants = PlantDataService.allPlants;
  List<Plant> _filtered = [];
  String _selectedCategory = 'Tout';
  String _sortBy = 'Popilè'; // 'Popilè', 'Pri ↑', 'Pri ↓', 'Non'

  final List<String> _categories = [
    'Tout',
    'Plant entryè',
    'Plant medsin',
    'Fwi ak legim',
    'Plant dekoratif',
    'Kaktis',
  ];

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  void _applyFilters() {
    List<Plant> result = _selectedCategory == 'Tout'
        ? List.from(_allPlants)
        : _allPlants
            .where((p) => p.category == _selectedCategory)
            .toList();

    switch (_sortBy) {
      case 'Pri ↑':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Pri ↓':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Non':
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      default: // Popilè
        result.sort((a, b) => b.rating.compareTo(a.rating));
    }

    setState(() => _filtered = result);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final crossAxisCount = isTablet ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tout plant yo (${_filtered.length})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Bouton triye
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Colors.white),
            onSelected: (val) {
              _sortBy = val;
              _applyFilters();
            },
            itemBuilder: (context) => [
              _sortItem('Popilè', Icons.star),
              _sortItem('Pri ↑', Icons.arrow_upward),
              _sortItem('Pri ↓', Icons.arrow_downward),
              _sortItem('Non', Icons.sort_by_alpha),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtre kategori
          Container(
            color: const Color(0xFF2E7D32).withOpacity(0.05),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () {
                      _selectedCategory = cat;
                      _applyFilters();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2E7D32)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF2E7D32),
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Gril plant yo
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.eco_outlined,
                            size: 60, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'Pa gen plant nan kategori sa',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      return PlantCard(
                        plant: _filtered[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PlantDetailScreen(plant: _filtered[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _sortItem(String val, IconData icon) {
    return PopupMenuItem<String>(
      value: val,
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 8),
          Text(val),
          if (_sortBy == val) ...[
            const Spacer(),
            const Icon(Icons.check, size: 16, color: Color(0xFF2E7D32)),
          ],
        ],
      ),
    );
  }
}
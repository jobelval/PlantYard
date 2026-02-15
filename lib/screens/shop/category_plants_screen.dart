import 'package:flutter/material.dart';
import 'package:plantyard/models/category_model.dart';
import 'package:plantyard/models/plant_model.dart';
import 'package:plantyard/screens/shop/plant_detail_screen.dart';
import 'package:plantyard/widgets/plant_card.dart';
import 'package:plantyard/services/plant_data_service.dart';

class CategoryPlantsScreen extends StatelessWidget {
  final Category category;

  const CategoryPlantsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final List<Plant> plants =
        PlantDataService.getPlantsByCategory(category.name);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final crossAxisCount = isTablet ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(category.icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(
              category.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header kategori
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF2E7D32).withOpacity(0.07),
            child: Text(
              '${plants.length} plant nan kategori sa',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          Expanded(
            child: plants.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category.icon,
                          style: const TextStyle(fontSize: 60),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Pa gen plant disponib\nnant kategori sa pou kounye a',
                          textAlign: TextAlign.center,
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
                    itemCount: plants.length,
                    itemBuilder: (context, index) {
                      return PlantCard(
                        plant: plants[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PlantDetailScreen(plant: plants[index]),
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
}
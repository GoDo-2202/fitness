import 'package:fitness/models/category_model.dart';
import 'package:fitness/pages/home/widgets/category_cell.dart';
import 'package:fitness/pages/recipe/controllers/recipes_controller.dart';
import 'package:fitness/pages/recipe/recipe_page.dart';
import 'package:fitness/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategorySection extends StatelessWidget {
  final List<CategoryModel> categories;

  const CategorySection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.only(left: 24),
        separatorBuilder: (_, __) => const SizedBox(width: 25),
        itemBuilder: (context, index) {
          final item = categories[index];
          // return CategoryCell(category: item);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => RecipesController(api: SpoonacularApi()),
                    child: const RecipePage(),
                  ),
                ),
              );
            },
            child: CategoryCell(category: item),
          );
        },
      ),
    );
  }
}

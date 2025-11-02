import 'package:fitness/core/widgets/custom_app_bar.dart';
import 'package:fitness/models/recipe.dart';
import 'package:fitness/pages/home/widgets/search_field.dart';
import 'package:fitness/pages/recipe/controllers/recipes_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final ScrollController _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<RecipesController>();
      controller.loadRecipes();

      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 1000 &&
            !controller.isLoadingMore &&
            controller.hasMore) {
          controller.loadMoreRecipes();
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RecipesController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(
        title: 'Search food',
        showBackButton: true,
        showActions: false,
      ),
      body: Column(
        children: [
          SearchField(
            controller: _searchController,
            onChanged: (value) {
              if (value.trim().isNotEmpty) {
                controller.updateQuery(value.trim());
                _scrollController.jumpTo(0);
              }
            },
          ),
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  key: ValueKey(controller.query),
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: controller.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = controller.recipes[index];
                    return _foodCell(recipe);
                  },
                ),
                if (controller.isLoading)
                  const Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (!controller.isLoading && controller.recipes.isEmpty)
                  const Center(
                    child: Text("No recipes found"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Card _foodCell(Recipe recipe) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _imageFoodCell(recipe),
        ),
        title: Text(recipe.title),
        onTap: () {
          // TODO: Navigate to detail page
        },
      ),
    );
  }

  Image _imageFoodCell(Recipe recipe) {
    return Image.network(
      recipe.image,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 60,
          height: 60,
          color: Colors.grey[200],
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        );
      },
    );
  }
}

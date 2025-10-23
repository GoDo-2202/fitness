import 'package:fitness/models/category_model.dart';
import 'package:fitness/pages/home/widgets/recomment_diet_cell.dart';
import 'package:flutter/material.dart';

class RecommentDietSection extends StatelessWidget {
  final List<CategoryModel> categories;
  const RecommentDietSection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: SizedBox(
        height: 200,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return RecommentDietCell(category: categories[index]);
            },
            separatorBuilder: (context, index) => const SizedBox(width: 25),
            itemCount: categories.length),
      ),
    );
  }
}

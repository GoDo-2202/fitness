import 'package:fitness/models/category_model.dart';
import 'package:fitness/pages/home/widgets/popular_cell.dart';
import 'package:flutter/material.dart';

class PopularSection extends StatefulWidget {
  final List<CategoryModel> categories;

  const PopularSection({super.key, required this.categories});

  @override
  State<PopularSection> createState() => _PopularSectionState();
}

class _PopularSectionState extends State<PopularSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        child: ListView.separated(
            itemCount: widget.categories.length,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(
                  height: 25,
                ),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return PopularCell(category: widget.categories[index]);
            }),
      ),
    );
  }
}

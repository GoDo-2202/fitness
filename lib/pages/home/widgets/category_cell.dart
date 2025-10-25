import 'package:fitness/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryCell extends StatelessWidget {
  final CategoryModel category;

  const CategoryCell({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blue.withAlpha(90),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(category.iconPath),
          ),
          Text(category.name,
              style: const TextStyle(color: Colors.black, fontSize: 12))
        ],
      ),
    );
  }
}

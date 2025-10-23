import 'package:fitness/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecommentDietCell extends StatelessWidget {
  final CategoryModel category;
  const RecommentDietCell({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 239,
      decoration: BoxDecoration(
          color: Colors.blue.withAlpha(90),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              alignment: Alignment.center,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: SvgPicture.asset(category.iconPath)),
          Text(
            category.name,
            style: const TextStyle(color: Colors.black, fontSize: 12),
          )
        ],
      ),
    );
  }
}

import 'package:fitness/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailFood extends StatelessWidget {
  final CategoryModel category;
  const DetailFood({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SvgPicture.asset('assets/icons/button.svg'),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Detail ${category.name}',
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}

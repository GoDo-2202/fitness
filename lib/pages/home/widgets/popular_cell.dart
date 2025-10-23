import 'package:fitness/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PopularCell extends StatelessWidget {
  final CategoryModel category;
  const PopularCell({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: const Color(0x001d1617).withOpacity(0.11),
                blurRadius: 40,
                spreadRadius: 0.0)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SvgPicture.asset(
              'assets/icons/pancakes.svg',
              width: 45,
              height: 45,
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Blueberry Pancake',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'Medium | 30mins | 230kCal',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 10),
            child: Container(
              alignment: Alignment.center,
              height: 24,
              width: 24,
              child: SvgPicture.asset('assets/icons/button.svg'),
            ),
          )
        ],
      ),
    );
  }
}

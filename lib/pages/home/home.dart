import 'package:fitness/models/category_model.dart';
import 'package:fitness/pages/home/widgets/category_section.dart';
import 'package:fitness/pages/home/widgets/popurlar_section.dart';
import 'package:fitness/pages/home/widgets/recomment_diet_section.dart';
import 'package:fitness/pages/home/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];

  void _getCategories() {
    categories = CategoryModel.getCategories();
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    _getCategories();
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const SearchField(),
          const SizedBox(height: 40),
          _titleSection(titleSection: 'Category'),
          const SizedBox(height: 12),
          CategorySection(categories: categories),
          const SizedBox(height: 40),
          _titleSection(titleSection: 'Recommendation for Diet'),
          const SizedBox(height: 12),
          RecommentDietSection(categories: categories),
          const SizedBox(height: 40),
          _titleSection(titleSection: 'Popular'),
          const SizedBox(height: 12),
          PopularSection(categories: categories)
        ],
      ),
    );
  }

  Padding _titleSection({required String titleSection}) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Text(titleSection,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          )),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Breakfast',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              color: const Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10)),
          child: SvgPicture.asset('assets/icons/Arrow - Left 2.svg'),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                color: const Color(0xffF7F8F8),
                borderRadius: BorderRadius.circular(10)),
            child: SvgPicture.asset('assets/icons/dots.svg'),
          ),
        )
      ],
    );
  }
}

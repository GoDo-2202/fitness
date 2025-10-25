import 'package:fitness/core/l10n/localizations_extension.dart';
import 'package:fitness/core/widgets/custom_app_bar.dart';
import 'package:fitness/models/category_model.dart';
import 'package:fitness/pages/home/widgets/category_section.dart';
import 'package:fitness/pages/home/widgets/home_page_body.dart';
import 'package:fitness/pages/home/widgets/popurlar_section.dart';
import 'package:fitness/pages/home/widgets/recomment_diet_section.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: context.localizations.breakfast,
          showBackButton: false,
          showActions: true,
        ),
        backgroundColor: Colors.white,
        body: HomePageBody(
          titleSectionBuilder: ({required String titleSection}) =>
              _titleSection(titleSection),
          categorySectionBuilder: ({required List<CategoryModel> categories}) =>
              CategorySection(categories: categories),
          recommentDietSectionBuilder: (
                  {required List<CategoryModel> categories}) =>
              RecommentDietSection(categories: categories),
          popularSectionBuilder: ({required List<CategoryModel> categories}) =>
              PopularSection(categories: categories),
        ));
  }

  static Padding _titleSection(String titleSection) {
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
}

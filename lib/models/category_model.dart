import 'package:fitness/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CategoryModel {
  String id;
  String name;
  String iconPath;
  Color boxColor;

  CategoryModel({
    String? id,
    required this.name,
    required this.iconPath,
    required this.boxColor,
  }) : id = id ?? const Uuid().v4();

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(CategoryModel(
        name: 'Salad',
        iconPath: Assets.icons.plate,
        boxColor: const Color(0xff9DCEFF)));

    categories.add(CategoryModel(
        name: 'Cake',
        iconPath: Assets.icons.pancakes,
        boxColor: const Color(0xffEEA4CE)));

    categories.add(CategoryModel(
        name: 'Pie',
        iconPath: Assets.icons.pie,
        boxColor: const Color(0xff9DCEFF)));

    categories.add(CategoryModel(
        name: 'Smoothies',
        iconPath: Assets.icons.orangeSnacks,
        boxColor: const Color(0xffEEA4CE)));

    return categories;
  }
}

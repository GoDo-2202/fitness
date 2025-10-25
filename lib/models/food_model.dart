import 'package:fitness/models/category_model.dart';
import 'package:uuid/uuid.dart';

class FoodModel {
  String id;
  String name;
  String description;
  CategoryModel category;

  FoodModel(
      {String? id,
      required this.name,
      required this.description,
      required this.category})
      : id = id ?? const Uuid().v4();
}

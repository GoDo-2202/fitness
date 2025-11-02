import 'package:fitness/models/category_model.dart';
import 'package:fitness/pages/home/widgets/recomment_diet_cell.dart';
import 'package:fitness/pages/picsum_page/controllers/picsum_controller.dart';
import 'package:fitness/pages/picsum_page/picsum_page.dart';
import 'package:fitness/services/media_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              return GestureDetector(
                child: RecommentDietCell(category: categories[index]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider(
                        create: (_) => PicsumController(api: MediaService()),
                        child: const PicsumPage(),
                      ),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 25),
            itemCount: categories.length),
      ),
    );
  }
}

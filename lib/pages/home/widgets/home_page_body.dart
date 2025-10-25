import 'package:fitness/models/category_model.dart';
import 'package:fitness/pages/home/widgets/search_field.dart';
import 'package:flutter/material.dart';

class HomePageBody extends StatefulWidget {
  final Widget Function({required String titleSection}) titleSectionBuilder;
  final Widget Function({required List<CategoryModel> categories})
      categorySectionBuilder;
  final Widget Function({required List<CategoryModel> categories})
      recommentDietSectionBuilder;
  final Widget Function({required List<CategoryModel> categories})
      popularSectionBuilder;

  const HomePageBody({
    super.key,
    required this.titleSectionBuilder,
    required this.categorySectionBuilder,
    required this.recommentDietSectionBuilder,
    required this.popularSectionBuilder,
  });

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  final ScrollController _scrollController = ScrollController();

  /// Danh sách category
  List<CategoryModel> categories = [];
  List<CategoryModel> categoriesPopular = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCategories();
    _scrollController.addListener(_onScroll);
  }

  void _getCategories() {
    // Giữ dữ liệu local, không cần setState ở đây
    categories = CategoryModel.getCategories();
    categoriesPopular = CategoryModel.getCategories();
  }

  Future<void> _loadMorePopular() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      categoriesPopular.addAll(CategoryModel.getCategories());
    });
  }

  void _onScroll() {
    if (isLoading) return;
    if (categoriesPopular.length >= 30) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      setState(() => isLoading = true);
      _loadMorePopular().then((_) {
        if (mounted) setState(() => isLoading = false);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      children: [
        const SearchField(),
        const SizedBox(height: 40),
        widget.titleSectionBuilder(titleSection: 'Category'),
        const SizedBox(height: 12),
        widget.categorySectionBuilder(categories: categories),
        const SizedBox(height: 40),
        widget.titleSectionBuilder(titleSection: 'Recommendation for Diet'),
        const SizedBox(height: 12),
        widget.recommentDietSectionBuilder(categories: categories),
        const SizedBox(height: 40),
        widget.titleSectionBuilder(titleSection: 'Popular'),
        const SizedBox(height: 12),
        widget.popularSectionBuilder(categories: categoriesPopular),
        const SizedBox(height: 12),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

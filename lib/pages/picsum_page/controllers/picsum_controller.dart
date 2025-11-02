import 'package:fitness/models/picsum_model.dart';
import 'package:fitness/services/media_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PicsumController extends ChangeNotifier {
  final MediaService api;

  PicsumController({required this.api});

  final List<PicsumModel> _futureImages = [];
  List<PicsumModel> get futureImages => List.unmodifiable(_futureImages);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int _offset = 0;
  final int _pageSize = 50;

  final Set<String> _selectedIds = {};
  Set<String> get selectedIds => _selectedIds;

  bool isSelected(String id) => _selectedIds.contains(id);

  void toggleSelection(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedIds.clear();
    notifyListeners();
  }

  Future<void> loadImages({bool isRefresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    if (isRefresh) {
      _offset = 0;
      _futureImages.clear();
      _hasMore = true;
    }
    notifyListeners();

    try {
      final result =
          await api.fetchPicsumImages(page: _offset, limit: _pageSize);

      _futureImages.addAll(result);
      _offset += 1;
      _hasMore = result.length >= _pageSize;
    } catch (e) {
      debugPrint("Error loading images: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreImages() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final result =
          await api.fetchPicsumImages(page: _offset, limit: _pageSize);

      _futureImages.addAll(result);
      _offset += 1;
      _hasMore = result.length >= _pageSize;
    } catch (e) {
      debugPrint("Error loading more images: $e");
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> downloadSelectedImage() async {
    for (final id in _selectedIds) {
      final image = _futureImages.firstWhere((e) => e.id == id);
      await api.saveImageToGallery(image.downloadUrl);
    }
  }

  Future<void> downloadMultipleImage() async {
    final urls = futureImages
        .where((e) => selectedIds.contains(e.id))
        .map((e) => e.downloadUrl)
        .toList();

    try {
      await api.downloadMultipleImage(urls);

      _selectedIds.clear();
      notifyListeners();
    } catch (e) {
      print('Download failed: $e');
    }
  }
}

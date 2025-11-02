import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:fitness/models/picsum_model.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaService {
  final Dio _dio = Dio();

  Future<void> downloadMultipleImage(List<String> urls) async {
    if (urls.isEmpty) return;
    if (!await _requestPermission()) {
      throw Exception('Không có quyền truy cập thư viện ảnh');
    }

    for (final url in urls) {
      try {
        final response = await _dio.get<List<int>>(
          url,
          options: Options(responseType: ResponseType.bytes),
        );

        final bytes = Uint8List.fromList(response.data!);
        await ImageGallerySaver.saveImage(
          bytes,
          quality: 100,
          name: "picsum_${DateTime.now().millisecondsSinceEpoch}",
        );

        await Future.delayed(const Duration(milliseconds: 200)); // nhẹ máy hơn
      } catch (e) {
        print("Lỗi khi tải $url: $e");
      }
    }
  }

  Future<void> saveImageToGallery(String imageUrl) async {
    if (await _requestPermission() == false) {
      throw Exception('Không có quyền truy cập thư viện ảnh');
    }

    // Download image
    final response = await _dio.get<List<int>>(imageUrl,
        options: Options(responseType: ResponseType.bytes));

    final Uint8List imageData = Uint8List.fromList(response.data!);

    final result = await ImageGallerySaver.saveImage(imageData,
        quality: 100, name: "picsum_${DateTime.now().millisecondsSinceEpoch}");
    print("Save success $result");
  }

  Future<bool> _requestPermission() async {
    try {
      if (Platform.isIOS) {
        var status = await Permission.photos.request();

        if (status.isDenied || status.isPermanentlyDenied) {
          // Thử xin quyền đầy đủ nếu "Add only" bị từ chối
          status = await Permission.photos.request();
        }

        if (status.isGranted) {
          print('✅ Quyền lưu ảnh (iOS) được cấp.');
          return true;
        } else if (status.isPermanentlyDenied) {
          print('🚫 Quyền lưu ảnh (iOS) bị từ chối vĩnh viễn.');
          openAppSettings();
          return false;
        } else {
          print('⚠️ Người dùng từ chối quyền lưu ảnh (iOS).');
          return false;
        }
      } else if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (status.isGranted) {
          print('✅ Quyền lưu ảnh (Android) được cấp.');
          return true;
        } else if (status.isPermanentlyDenied) {
          print('🚫 Quyền lưu ảnh (Android) bị từ chối vĩnh viễn.');
          openAppSettings();
          return false;
        } else {
          print('⚠️ Người dùng từ chối quyền lưu ảnh (Android).');
          return false;
        }
      }
    } catch (e) {
      print('❌ Lỗi khi xin quyền lưu ảnh: $e');
    }
    return false;
  }

  Future<List<PicsumModel>> fetchPicsumImages({
    int page = 1,
    int limit = 10,
    int width = 400,
    int height = 400,
  }) async {
    final response = await http.get(
      Uri.parse('https://picsum.photos/v2/list?page=$page&limit=$limit'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((json) {
        final original = PicsumModel.fromJson(json);

        // Dùng link ảnh nhỏ để tránh chiếm nhiều bộ nhớ
        final resizedUrl =
            'https://picsum.photos/id/${original.id}/$width/$height';

        return PicsumModel(
          id: original.id,
          author: original.author,
          width: width,
          height: height,
          url: original.url,
          downloadUrl: resizedUrl,
        );
      }).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }

  Future<void> downloadMultipleImagePatch(
    List<String> urls, {
    int patchSize = 5, // số ảnh download song song mỗi patch
    Function(int downloaded, int total)? onProgress, // callback progress
  }) async {
    if (urls.isEmpty) return;
    if (!await _requestPermission()) {
      throw Exception('Không có quyền truy cập thư viện ảnh');
    }

    int total = urls.length;
    int downloadedCount = 0;

    for (var i = 0; i < urls.length; i += patchSize) {
      final patch = urls.sublist(
        i,
        (i + patchSize).clamp(0, urls.length),
      );

      // Download song song trong patch
      await Future.wait(patch.map((url) async {
        try {
          final response = await _dio.get<List<int>>(
            url,
            options: Options(responseType: ResponseType.bytes),
          );

          final bytes = Uint8List.fromList(response.data!);
          await ImageGallerySaver.saveImage(
            bytes,
            quality: 100,
            name: "picsum_${DateTime.now().millisecondsSinceEpoch}",
          );

          downloadedCount++;
          if (onProgress != null) onProgress(downloadedCount, total);

          // Delay nhẹ để giảm load máy
          await Future.delayed(const Duration(milliseconds: 100));
        } catch (e) {
          print("Lỗi khi tải $url: $e");
        }
      }));

      // Delay giữa các patch để an toàn memory hơn
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }
}

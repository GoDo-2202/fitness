import 'dart:io';

import 'package:fitness/models/picsum_model.dart';
import 'package:fitness/pages/picsum_page/controllers/picsum_controller.dart';
import 'package:fitness/services/media_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PicsumPage extends StatefulWidget {
  const PicsumPage({super.key});

  @override
  State<PicsumPage> createState() => _PicsumPageState();
}

class _PicsumPageState extends State<PicsumPage> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<PicsumModel>> futureImages;
  late final MediaService mediaService;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<PicsumController>();
      controller.loadImages();
      _scrollController.addListener(() {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;
        const delta = 500.0;

        if (maxScroll - currentScroll <= delta) {
          if (!controller.isLoadingMore && controller.hasMore) {
            controller.loadMoreImages();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PicsumController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Picsum Gallery'),
        actions: [
          if (controller.selectedIds.isNotEmpty)
            downloadImageButton(controller, context),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadImages(isRefresh: true);
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: GridView.builder(
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 4 ảnh mỗi hàng
              crossAxisSpacing: 4, // khoảng cách ngang
              mainAxisSpacing: 4, // khoảng cách dọc
              childAspectRatio: 1, // hình vuông
            ),
            itemCount: controller.futureImages.length,
            itemBuilder: (context, index) {
              if (index >= controller.futureImages.length) {
                return showIndicator();
              }

              final image = controller.futureImages[index];
              final isSelected = controller.isSelected(image.id);

              return GestureDetector(
                onTap: () => controller.toggleSelection(image.id),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    picsumImage(image),
                    // ✅ Checkbox overlay
                    checkboxOverlay(isSelected),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  IconButton downloadImageButton(
      PicsumController controller, BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.download),
      onPressed: () async {
        try {
          // 1️⃣ Xin quyền lưu ảnh
          bool granted = false;
          if (Platform.isIOS) {
            final status = await Permission.photos.request();
            if (status.isGranted) {
              granted = true;
            } else if (status.isPermanentlyDenied) {
              openAppSettings(); // mở Settings nếu deny vĩnh viễn
              return;
            }
          } else if (Platform.isAndroid) {
            final status = await Permission.storage.request();
            if (status.isGranted) {
              granted = true;
            } else if (status.isPermanentlyDenied) {
              openAppSettings();
              return;
            }
          }

          if (!granted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Không có quyền lưu ảnh')),
            );
            return;
          }

          // 2️⃣ Quyền đã được cấp → download ảnh
          await controller.downloadMultipleImage();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tải ảnh thành công 🎉')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: $e')),
          );
        }
      },
    );
  }

  Positioned checkboxOverlay(bool isSelected) {
    return Positioned(
      top: 4,
      right: 4,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.black38,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(2),
        child: Icon(
          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  ClipRRect picsumImage(PicsumModel image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CachedNetworkImage(
        fadeInDuration: Duration.zero,
        imageUrl: image.downloadUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.broken_image),
      ),
    );
  }

  Center showIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

// FutureBuilder<List<PicsumModel>>(
    //   future: futureImages,
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(child: CircularProgressIndicator());
    //     } else if (snapshot.hasError) {
    //       return Center(child: Text('Error: ${snapshot.error}'));
    //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    //       return const Center(child: Text('No images found'));
    //     }
    //     final images = snapshot.data!;
    //     return imageCell(images);
    //   },
    // );

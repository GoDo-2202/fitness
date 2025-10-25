import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showActions;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.showActions = true,
    this.onBackPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: showBackButton
          ? GestureDetector(
              onTap: onBackPressed ?? () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: const Color(0xffF7F8F8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SvgPicture.asset('assets/icons/Arrow - Left 2.svg'),
              ),
            )
          : const SizedBox(),
      actions: showActions
          ? (actions ??
              [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xffF7F8F8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset('assets/icons/dots.svg'),
                  ),
                )
              ])
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

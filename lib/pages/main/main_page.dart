import 'package:fitness/pages/home/home.dart';
import 'package:fitness/pages/settings/setting_page_body.dart';
import 'package:flutter/material.dart';
import 'package:fitness/core/widgets/custom_bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    SettingPageBody(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 15),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFAEE6FF),
          elevation: 4,
          onPressed: () {
            // TODO: mở camera hoặc popup
          },
          shape: const CircleBorder(),
          child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTabSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        onCameraPressed: () {
          // TODO: xử lý khi bấm camera
        },
      ),
    );
  }
}

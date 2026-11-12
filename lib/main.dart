
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/resize_screen.dart';
import 'screens/compress_screen.dart';
import 'screens/saved_images_screen.dart';

void main() {
  runApp(const ImageApp());
}

class ImageApp extends StatelessWidget {
  const ImageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Resizer and Compressor',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF0B1D4A),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    ResizeScreen(),
    CompressScreen(),
    SavedImagesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0B1D4A),
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_size_select_large),
            label: 'Resize',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compress),
            label: 'Compress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Saved Images',
          ),
        ],
      ),
    );
  }
}

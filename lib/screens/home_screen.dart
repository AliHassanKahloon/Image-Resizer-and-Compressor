
import 'package:flutter/material.dart';
import '../services/image_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ImageService.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Resizer & Compressor'),
        backgroundColor: const Color(0xFF0B1D4A),
        foregroundColor: Colors.white,
      ),

      body: AnimatedBuilder(
        animation: service,
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                const Icon(
                  Icons.image,
                  size: 90,
                  color: Colors.blue,
                ),

                const Text(
                  'Manage Your Images',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Text(
                  'Resize and compress your photos easily',
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: service.selectedImage != null
                      ? Image.file(
                    service.selectedImage!,
                    fit: BoxFit.contain,
                  )
                      : const Center(
                    child: Icon(
                      Icons.add_photo_alternate,
                      size: 130,
                      color: Colors.grey,
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await service.pickImage();
                      } catch (e) {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Select Image'),
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          );
        },
      ),
    );
  }
}

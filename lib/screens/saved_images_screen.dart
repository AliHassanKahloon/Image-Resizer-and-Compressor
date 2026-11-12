import 'dart:io';

import 'package:flutter/material.dart';
import '../services/image_service.dart';

class SavedImagesScreen extends StatefulWidget {
  const SavedImagesScreen({super.key});

  @override
  State<SavedImagesScreen> createState() =>
      _SavedImagesScreenState();
}

class _SavedImagesScreenState extends State<SavedImagesScreen> {
  @override
  void initState() {
    super.initState();
    ImageService.instance.refreshSavedImages();
  }

  String getFileSize(File file) {
    final size = file.lengthSync();

    if (size < 1024) {
      return '$size bytes';
    }

    if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)} KB';
    }

    return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  void openImage(File file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Image Preview'),
            backgroundColor: const Color(0xFF0B1D4A),
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.file(file),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = ImageService.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Images'),
        backgroundColor: const Color(0xFF0B1D4A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: service.refreshSavedImages,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: service,
        builder: (context, child) {
          if (service.savedImages.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 90,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'No Saved Images Yet',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text('Resize or compress an image first.'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: service.refreshSavedImages,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: service.savedImages.length,
              itemBuilder: (context, index) {
                final file = service.savedImages[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Image.file(
                      file,
                      width: 55,
                      height: 55,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      file.path.split(Platform.pathSeparator).last,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(getFileSize(file)),
                    onTap: () => openImage(file),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await service.deleteImage(file);

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Image deleted successfully.'),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
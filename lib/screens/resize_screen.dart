
import 'package:flutter/material.dart';
import '../services/image_service.dart';

class ResizeScreen extends StatefulWidget {
  const ResizeScreen({super.key});

  @override
  State<ResizeScreen> createState() => _ResizeScreenState();
}

class _ResizeScreenState extends State<ResizeScreen> {
  final widthController = TextEditingController(text: '800');
  final heightController = TextEditingController(text: '600');

  bool isProcessing = false;

  @override
  void dispose() {
    widthController.dispose();
    heightController.dispose();
    super.dispose();
  }

  Future<void> resizeImage() async {
    final width = int.tryParse(widthController.text);
    final height = int.tryParse(heightController.text);

    if (width == null ||
        height == null ||
        width <= 0 ||
        height <= 0 ||
        width > 10000 ||
        height > 10000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter valid width and height.'),
        ),
      );
      return;
    }

    if (ImageService.instance.selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image from Home first.'),
        ),
      );
      return;
    }

    setState(() => isProcessing = true);

    try {
      await ImageService.instance.resizeImage(width, height);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image resized and saved successfully!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = ImageService.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resize Image'),
        backgroundColor: const Color(0xFF0B1D4A),
        foregroundColor: Colors.white,
      ),

      body: AnimatedBuilder(
        animation: service,
        builder: (context, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (service.selectedImage != null)
                  Image.file(
                    service.selectedImage!,
                    height: 220,
                    fit: BoxFit.contain,
                  )
                else
                  const Icon(
                    Icons.image,
                    size: 120,
                    color: Colors.grey,
                  ),

                const SizedBox(height: 25),

                const Text(
                  'Enter Image Dimensions',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: widthController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Width (pixels)',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Height (pixels)',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isProcessing ? null : resizeImage,
                    child: Text(
                      isProcessing ? 'Resizing...' : 'Resize Image',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

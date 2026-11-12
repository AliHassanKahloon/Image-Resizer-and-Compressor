import 'dart:io';

import 'package:flutter/material.dart';
import '../services/image_service.dart';

class CompressScreen extends StatefulWidget {
  const CompressScreen({super.key});

  @override
  State<CompressScreen> createState() => _CompressScreenState();
}

class _CompressScreenState extends State<CompressScreen> {
  double quality = 70;
  bool isProcessing = false;

  Future<void> compressImage() async {
    final service = ImageService.instance;

    if (service.selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image first.'),
        ),
      );
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {
      final result = await service.compressImage(quality.round());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result == null
                ? 'Compression failed.'
                : 'Image compressed and saved successfully!',
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = ImageService.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compress Image'),
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
                    size: 130,
                    color: Colors.grey,
                  ),

                const SizedBox(height: 25),

                const Text(
                  'Compression Quality',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  '${quality.round()}%',
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Slider(
                  value: quality,
                  min: 10,
                  max: 100,
                  divisions: 18,
                  label: '${quality.round()}%',
                  onChanged: (value) {
                    setState(() {
                      quality = value;
                    });
                  },
                ),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Smaller file'),
                    Text('Better quality'),
                  ],
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isProcessing ? null : compressImage,
                    icon: const Icon(Icons.compress),
                    label: Text(
                      isProcessing ? 'Compressing...' : 'Compress Image',
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
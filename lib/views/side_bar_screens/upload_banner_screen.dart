import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../controllers/banner_controller.dart';
import 'banner_widget.dart';

class UploadBannerScreen extends StatefulWidget {
  static const String id = 'BannerScreen';
  const UploadBannerScreen({super.key});

  @override
  State<UploadBannerScreen> createState() => _UploadBannerScreenState();
}

class _UploadBannerScreenState extends State<UploadBannerScreen> {
  final BannerController bannerController = BannerController();
  dynamic _image;

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload Banner',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(
            color: Colors.grey,
            thickness: 2,
          ),
          const SizedBox(height: 16),
          
          // Banner Preview
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: _image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      _image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  )
                : const Center(
                    child: Text(
                      'Banner Image\n(Recommended: 800x200)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
          ),
          
          const SizedBox(height: 16),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Pick Image'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _image != null
                      ? () async {
                          final success = await bannerController.uploadBanner(
                            pickedImage: _image,
                            context: context,
                          );
                          if (success) {
                            setState(() {
                              _image = null; // Reset image after successful upload
                            });
                          }
                        }
                      : null,
                  icon: const Icon(Icons.upload),
                  label: const Text('Upload Banner'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          const Divider(color: Colors.grey),
          const SizedBox(height: 16),
          
          const BannerWidget(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../controllers/category_controller.dart';
import 'category_widget.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = 'CategoryScreen';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final CategoryController categoryController = CategoryController();
  late String categoryName;
  dynamic _image;
  dynamic _bannerImage;

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

  pickBannerImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _bannerImage = result.files.first.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Container(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: const Text(
              'Categories',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Divider(
          color: Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: _image != null
                    ? Center(
                        child: Image.memory(_image),
                      )
                    : const Center(
                        child: Text('Category Image'),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 200,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Please enter category name';
                      }
                    },
                    onChanged: (value) {
                      categoryName = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter Category Name',
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Will implement later
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    categoryController.uploadCategory(
                      pickedImage: _image,
                      pickedBanner: _bannerImage,
                      name: categoryName,
                      context: context,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: pickImage,
            child: const Text('Pick Image'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(5),
            ),
            child: _bannerImage != null
                ? Center(
                    child: Image.memory(_bannerImage),
                  )
                : const Center(
                    child: Text('Category Banner'),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: pickBannerImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
            ),
            child: const Text(
              'Pick Image',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const Divider(
          color: Colors.grey,
        ),
        const CategoryWidget(),
      ],
        ),
      ),
    );
  }
}

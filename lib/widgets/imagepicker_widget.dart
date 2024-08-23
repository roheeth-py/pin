import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({required this.func, super.key});
  final void Function(File image) func;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? selectedImage;

  void imageSelector() async {
    final image = ImagePicker();
    final pickedImage =
        await image.pickImage(source: ImageSource.camera, imageQuality: 100);

    if (pickedImage == null) {
      return;
    }
    setState(() {
      selectedImage = File(pickedImage.path);
    });
    widget.func(selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: imageSelector,
      icon: const Icon(Icons.add_a_photo_rounded),
      label: const Text("Add Image"),
    );

    if (selectedImage != null) {
      content = GestureDetector(
        onTap: imageSelector,
        child: Image.file(
          selectedImage!,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
        clipBehavior: Clip.hardEdge,
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: content);
  }
}

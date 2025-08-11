import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPickerExample extends StatefulWidget {
  @override
  _PhotoPickerExampleState createState() => _PhotoPickerExampleState();
}

class _PhotoPickerExampleState extends State<PhotoPickerExample> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Pick from Gallery'),
            onTap: () async {
              final pickedFile = await _picker.pickImage(
                source: ImageSource.gallery,
              );
              if (pickedFile != null) {
                setState(() => _image = pickedFile);
              }
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a Photo'),
            onTap: () async {
              final pickedFile = await _picker.pickImage(
                source: ImageSource.camera,
              );
              if (pickedFile != null) {
                setState(() => _image = pickedFile);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Photo Picker Bottom Sheet")),
      body: Center(
        child: _image == null
            ? const Text('No image selected')
            : Image.file(File(_image!.path), height: 200),
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.image_outlined, color: Colors.black),
        onPressed: _showPhotoOptions,
      ),
    );
  }
}

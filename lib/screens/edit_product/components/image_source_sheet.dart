import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  ImageSourceSheet({Key? key, required this.onImageSelected}) : super(key: key);

  final Function(File) onImageSelected;
  XFile? pickedFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _cropImage(path) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
    );
    if (croppedFile != null) {
      onImageSelected(File(croppedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextButton(
            onPressed: () async {
              XFile? file = await _picker.pickImage(source: ImageSource.camera);
              _cropImage(file!.path);
            },
            child: const Text('Câmera'),
          ),
          TextButton(
            onPressed: () async {
              XFile? file =
                  await _picker.pickImage(source: ImageSource.gallery);
              _cropImage(file!.path);
            },
            child: const Text('Galeria'),
          ),
        ],
      ),
    );
  }
}

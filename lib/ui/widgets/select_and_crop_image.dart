import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:the_super11/core/permissions.dart';
import 'package:the_super11/ui/resources/resources.dart';

class ImageUtils {
  final BuildContext _context;

  ImageUtils(this._context);

  Future<File?> selectAndCropImage() async {
    return await showModalBottomSheet<File?>(
      context: _context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(12),
      )),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Capture Photo / Select Photo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Divider(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _imageSelectionOption(
                    icon: icCamera,
                    label: 'Camera',
                  ),
                  _imageSelectionOption(
                    icon: icGallery,
                    label: 'Gallery',
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _imageSelectionOption({required String label, required String icon}) =>
      Column(
        children: [
          MaterialButton(
            onPressed: () async {
              final permissions = <Permission>[];
              if (label == 'Camera')
                permissions.add(Permission.camera);
              else
                permissions.add(
                    Platform.isIOS ? Permission.photos : Permission.storage);
              managePermission(
                context: _context,
                permissions: permissions,
                onGranted: () async {
                  final picker = ImagePicker();
                  final pickedFile = await picker.getImage(
                    source: label == 'Camera'
                        ? ImageSource.camera
                        : ImageSource.gallery,
                    preferredCameraDevice: CameraDevice.front,
                  );
                  if (pickedFile != null) {
                    final file = await _openCropScreen(pickedFile.path);
                    Navigator.of(_context).pop(file);
                  }
                },
              );
            },
            shape: CircleBorder(),
            child: Image.asset(
              icon,
              width: 50,
              height: 50,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(label)
        ],
      );

  Future<File?> _openCropScreen(String imagePath) async {
    final croppedFile = await ImageCropper.cropImage(
        sourcePath: imagePath,
        compressQuality: 60,
        maxWidth: 500,
        maxHeight: 500,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Theme.of(_context).primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          activeControlsWidgetColor: Theme.of(_context).primaryColor,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
        ));
    if (croppedFile != null) return File(croppedFile.path);
  }
}

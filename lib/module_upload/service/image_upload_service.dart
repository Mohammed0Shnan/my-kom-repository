import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_kom/module_upload/repository/upload_repository.dart';
import 'package:my_kom/utils/image_compression.dart';

class ImageUploadService {
  final UploadRepository _uploadRepository = UploadRepository();
  Future<String?> uploadImage(String filePath) async {
    File out = await ImageCompression.compressAndGetFile(file: File(filePath));
     UploadTask? task = await  _uploadRepository.upload(filePath , out);
     if(task == null){
       return null;
     }
     else
       {
         final snapshot = await task.whenComplete(() {});
         final urlDownload = await snapshot.ref.getDownloadURL();
         return urlDownload;
       }
  }

  Future getImageFromGallery(ImageSource imageSource) async {
    String? _path;
    try {
      var pickedImage = await ImagePicker().pickImage(source: imageSource);
      _path = pickedImage!.path;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    String file = _path != null ? _path : '';
    return file; //await cropImage(file);
  }

  Future cropImage(String image) async {

    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: image,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    return croppedFile!.path;
  }
}

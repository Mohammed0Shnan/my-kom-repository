import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_kom/module_upload/service/image_upload_service.dart';
import 'package:my_kom/module_upload/upload_bloc.dart';


 choosePhotoSource(BuildContext maincontext, UploadBloc _bloc) async {
  ImageUploadService _servce = ImageUploadService();
  var size = MediaQuery.of(maincontext).size;
   showDialog(
      context: maincontext,
      builder: (context) {
        return AlertDialog(
          title: new Text('choose an app'),
          actions: <Widget>[
            Container(
              height: size.height * 0.1,
              child: IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  size: 50,
                ),
                onPressed: () async {
                  String pickedImage =
                      await _servce.getImageFromGallery(ImageSource.camera);
                  if (pickedImage != null) {

                    _bloc.upload(pickedImage);
                    Navigator.of(maincontext).pop();

                  }
                },
              ),
              padding: EdgeInsets.only(left: size.width * 0.15),
            ),
            Container(
              height: size.height * 0.1,
              child: IconButton(
                icon: Icon(
                  Icons.crop_original,
                  size: 50,
                ),
                onPressed: () async {
                  String pickedImage =
                      await _servce.getImageFromGallery(ImageSource.gallery);
                  if (pickedImage != null) {

                    _bloc.upload(pickedImage);
                    Navigator.of(maincontext).pop();


                  }
                  // Get.back();
                },
              ),
              padding: EdgeInsets.only(left: size.width * 0.15),
            )
          ],
        );
      });
}

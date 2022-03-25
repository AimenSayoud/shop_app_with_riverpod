import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? pickedImage;
  final ImagePicker _picked = ImagePicker();

  void _pickAnImage(ImageSource source) async {
    final pickedImageFile = await _picked.pickImage(
      source: source,
      imageQuality: 50,
      maxHeight: 200,
      maxWidth: 200,
    );
    print('extracting the pic done');
    if (pickedImageFile != null) {
      print('entering the if statement and adding the data to variables');
      setState(() {
        pickedImage = File(pickedImageFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('choose an image'),
      ),
      body: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              pickedImage == null
                  ? SizedBox(
                      height: 19,
                      child: Text('fuck u'),
                    )
                  : Column(
                      children: [
                        Image.file(pickedImage!),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(pickedImage);
                          },
                          child: Text('Save'),
                        ),
                      ],
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: TextButton.icon(
                      onPressed: () {
                        _pickAnImage(ImageSource.camera);
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        color: Theme.of(context).primaryColor,
                      ),
                      label: Text('gallery'),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton.icon(
                      onPressed: () async {
                        _pickAnImage(ImageSource.gallery);
                      },
                      icon: Icon(
                        Icons.photo,
                        color: Theme.of(context).primaryColor,
                      ),
                      label: Text('gallery'),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}

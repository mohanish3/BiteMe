import 'package:biteme/tabs/home/rewards_page.dart';
import 'package:biteme/widgets/custom_app_bar.dart';
import 'package:biteme/widgets/custom_icon_button.dart';
import 'package:biteme/routes/bookmark_page.dart';
import 'package:biteme/routes/bar_pages.dart';
import 'package:biteme/routes/home_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:biteme/utilities/server_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:biteme/utilities/firebase_functions.dart';

class ImageCapture extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ImageCaptureState();
}

class ImageCaptureState extends State<ImageCapture> {
  File _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Theme.of(context).canvasColor,
        toolbarTitle: "Crop Image",
        toolbarWidgetColor: Colors.black,
      ),
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  Widget _buildButtons(String x, String y, var a, var b) {
    if (x == null) x = "NULL";
    if (y == null) y = "NULL";

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => a,
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Color(0xFF404A5C),
                ),
                child: Center(
                  child: Text(
                    x,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: InkWell(
              onTap: () => b,
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      y,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          _imageFile == null ?"Edit Profile" : "Edit Image",
          style: TextStyle(
              fontSize: 35,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w400,
              color: Colors.black),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        toolbarOpacity: 0.0,
        bottomOpacity: 0.0,
        elevation: 0,
      ),
      bottomNavigationBar: _imageFile == null ? Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () => _pickImage(ImageSource.camera),
                child: Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: Color(0xFF404A5C),
                  ),
                  child: Center(
                    child: Text(
                      "CAMERA",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: InkWell(
                onTap: () => _pickImage(ImageSource.gallery),
                child: Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "GALLERY",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
      : Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: _cropImage,
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color: Color(0xFF404A5C),
                        ),
                        child: Center(
                          child: Text(
                            "CROP",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.0),
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ImageCapture(),
                      )),
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "RESTART",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                   SizedBox(width: 2.0),
                  Expanded(
                    child: InkWell(
                      //onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      //  builder: (context) => ImageCapture(),
                      //)),
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(0.5),
                            child: Uploader(file: _imageFile),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            
            Image.file(_imageFile),
            Uploader(file: _imageFile),
          ]
        ],
      ),
    );
  }
}

class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UploaderState();
}

class UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://biteme-1c46b.appspot.com');

  StorageUploadTask _uploadTask;

  void _startUpload() {
    String filePath = 'images/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (context, snapshot) {
          var event = snapshot?.data?.snapshot;

          double progressPercent =
              event != null ? event.bytesTransferred / event.totalByteCount : 0;

          return Column(
            children: <Widget>[
              if (_uploadTask.isComplete) Text("COMPLETE!"),
              if (_uploadTask.isPaused)
                FlatButton(
                  child: Icon(Icons.play_arrow),
                  onPressed: _uploadTask.resume,
                ),
              if (_uploadTask.isInProgress)
              FlatButton(
                  child: CircularProgressIndicator(strokeWidth: 2.0, valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),),
                  onPressed: _uploadTask.pause,
                ),
                
              //LinearProgressIndicator(
              //  value: progressPercent,
             // ),
              //Text("${(progressPercent * 100).toStringAsFixed(2)} %"),
            ],
          );
        },
      );
    } else {
      return FlatButton.icon(
        label: Text('Upload'),
        icon: Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      );
    }
  }
}

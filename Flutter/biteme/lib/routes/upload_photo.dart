import 'package:biteme/tabs/home/rewards_child.dart';
import 'package:biteme/widgets/custom_app_bar.dart';
import 'package:biteme/widgets/custom_icon_button.dart';
import 'package:biteme/routes/bookmark_page.dart';
import 'package:biteme/routes/bar_pages.dart';
import 'package:biteme/routes/home_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:biteme/utilities/server_functions.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        automaticallyImplyLeading: false,
        title: new Text(
          _imageFile == null ? "Upload an Image" : "Edit Image",
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
      bottomNavigationBar: _imageFile == null
          ? Padding(
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
                        ),
                        child: Center(
                          child: Text(
                            "CROP",
                            style: TextStyle(
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
                          color: Color(0xFF404A5C),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "RESTART",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
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
            //Uploader(file: _imageFile),
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

  /*FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user = auth.currentUser().then((FirebaseUser user){
    final userid = user.uid;
  }); */

  /*
  FirebaseUser user = FirebaseAuth.getInstance().getCurrentUser();

UserProfileChangeRequest profileUpdates = new UserProfileChangeRequest.Builder()
        .setDisplayName("Jane Q. User")
        .setPhotoUri(Uri.parse("https://example.com/jane-q-user/profile.jpg"))
        .build();

user.updateProfile(profileUpdates)
        .addOnCompleteListener(new OnCompleteListener<Void>() {
            @Override
            public void onComplete(@NonNull Task<Void> task) {
                if (task.isSuccessful()) {
                    Log.d(TAG, "User profile updated.");
                }
            }
        });

  */

  //FirebaseUser user = FirebaseAuth.getInstance().getCurrentUser();

  void _startUpload() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();

    String filePath = 'images/' + user.uid + '.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  void updateUserData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    
    final ref = FirebaseStorage.instance.ref().child("images").child(user.uid + '.png');
    var url = await ref.getDownloadURL() as String;

     DatabaseReference ref2 = FirebaseFunctions.getTraversedChild(['users', user.uid]);
      ref2.update({'photoUrl' : url});
      
      //print ("EXECUTED>>>>>>>>>>>>>>>");
  }

  Widget _uploadButton(StorageUploadTask _uploadTask) {
    if (_uploadTask.isCanceled)
      return Text(
        "CANCELLED!",
        style: TextStyle(fontWeight: FontWeight.w600),
      );
    if (_uploadTask.isSuccessful) {
      updateUserData();

      return Text(
        "COMPLETE!",
        style: TextStyle(fontWeight: FontWeight.w600),
      );
    }

    if (_uploadTask.isInProgress)
      return FlatButton(
        child: CircularProgressIndicator(
          strokeWidth: 1.0,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
        ),
        onPressed: _uploadTask.cancel,
      );

      return Text(
        "ERROR!",
        style: TextStyle(fontWeight: FontWeight.w600),
      );
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

          return Center(
            child: _uploadButton(_uploadTask),
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

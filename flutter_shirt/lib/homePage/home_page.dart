import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleUser = GoogleSignIn();
  File cameraFile;

  void _signOut() {
    _auth.signOut().then((_) {
//      googleUser.signOut();
      Navigator.of(context).pop();
    });
  }

  Map<String, dynamic> toMap(String url, String uid) {
    return {'url': url, 'uid': uid};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Flutter_Shirt homepage"),
        leading: Container(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('photos').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return ListView.builder(
                itemBuilder: (context, index) {
                  String url = snapshot.data.documents[index].data["url"];
                  return FutureBuilder(
                    future: FirebaseStorage.instance
                        .ref()
                        .child(url)
                        .getDownloadURL(),
                    builder: (context, snapshot2) {
                      if (snapshot2.hasData) {
                        return Container(
                          width: MediaQuery.of(context).size.width - 60,
                          height: MediaQuery.of(context).size.width - 60,
                          child: Center(
                            child: Card(
                              elevation: 2,
                              child: Column(
                                children: <Widget>[
                                  Image.network(snapshot2.data),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                },
                itemCount: snapshot.data.documents.length,
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          cameraFile = await ImagePicker.pickImage(
            source: ImageSource.camera,
            maxHeight: 50.0,
            maxWidth: 50.0,
          );
          print("You selected camera image : " + cameraFile.path);
          FirebaseUser user = await _auth.currentUser();
          String name =
              DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
          final StorageReference firebaseStorageRef =
              FirebaseStorage.instance.ref().child(user.uid).child(name);
          final StorageUploadTask task = firebaseStorageRef.putFile(cameraFile);
          Firestore.instance
              .collection('photos')
              .document(DateTime.now().millisecondsSinceEpoch.toString())
              .setData(toMap("${user.uid}/${name}", user.uid));
          setState(() {});
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}

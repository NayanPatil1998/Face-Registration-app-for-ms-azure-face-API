import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import './Success.dart';
import 'package:flutter/material.dart';

class AddPhoto extends StatefulWidget {
  final String text;
  AddPhoto({Key key, @required this.text}) : super(key: key);

  _AddPhotoState createState() => _AddPhotoState();
}

var personGroupId = 'class_te';
var keycode = "e9b26c8dc07542e799040328148c63d4";

class _AddPhotoState extends State<AddPhoto> {
  File _image;

  Future getImage(String id) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
    _uploadImage(id);
  }

  Future<http.Response> _uploadImage(String personId) async {
    // Map data = {"url": _image.path};
    // print(_image.path);
    // var body = jsonEncode(data);
    final bytes = _image.readAsBytesSync();
    print(bytes);
    print(personId);
    var uri = Uri.parse(
        "https://reactnativefacerecog.cognitiveservices.azure.com/face/v1.0/persongroups/${personGroupId}/persons/${personId}/persistedFaces?detectionModel=detection_02");

    var response = await http.post(uri,
        headers: {
          "Content-Type": "application/octet-stream",
          "Ocp-Apim-Subscription-Key": "e9b26c8dc07542e799040328148c63d4"
        },
        body: bytes);
    print(response.statusCode);
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: new Text("Success"),
            content: new Text("Image is uploaded"),
          );
        } 
      );
      print("ok");
    }
  }

  Future<http.Response> trainData() async {
    var uri = Uri.parse(
        "https://reactnativefacerecog.cognitiveservices.azure.com/face/v1.0/persongroups/${personGroupId}/train");

    var response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Ocp-Apim-Subscription-Key": "e9b26c8dc07542e799040328148c63d4"
      },
    );
    if (response.statusCode == 202) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage()
            ),
          );
      print("ok");
    }
    else{
      print(response.statusCode);
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: new Text("Error"),
            content: new Text("Error ${response.statusCode}"),
          );
        } 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Add Photo",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Add Photo"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Text("Upload Selfies at least 3 times"),
            ),
            Center(
              child: _image == null
                  ? Text('No image selected.')
                  : Image.file(_image),
            ),
            Center(
                child: RaisedButton(
              child: Text("Submit"),
              onPressed: trainData,
            )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => getImage(widget.text),
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
        ),
      ),
    );
  }
}

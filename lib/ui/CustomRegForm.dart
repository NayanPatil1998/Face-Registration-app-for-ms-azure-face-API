import 'dart:convert';

import 'package:flutter/material.dart';
import './AddPhoto.dart';
import 'package:http/http.dart' as http;

class CustomRegForm extends StatefulWidget {
  @override
  _CustomRegFormState createState() => _CustomRegFormState();
}

class RegData {
  var name = "";
  var info = "";
}

var personGroupId = 'class_te';
var Key = "e9b26c8dc07542e799040328148c63d4";

var uri = Uri.parse(
    "https://reactnativefacerecog.cognitiveservices.azure.com/face/v1.0/persongroups/${personGroupId}/persons");

class _CustomRegFormState extends State<CustomRegForm> {
  final _formKey = GlobalKey<FormState>();

  Future<http.Response> _makePostRequest() async {
    // var headers = {"Content-type": "application/json",'Ocp-Apim-Subscription-Key': Key};

    //  http.Response response = await http.post(uri, headers: headers, body: json);
    //   print(response);

    Map data = {"name": _data.name, "userData": _data.info};
    var body = jsonEncode(data);

    var response = await http.post(uri,
        headers: {
          "Content-Type": "application/json",
          "Ocp-Apim-Subscription-Key": "e9b26c8dc07542e799040328148c63d4"
        },
        body: body);

    // var request = new http.Request("POST", uri)
    //   ..headers['Ocp-Apim-Subscription-Key'] =
    //       "9c261636281d42c0947d89fe3982df73"
    //   ..headers['Content-Type'] = "application/json"
    //   ..body = body;
    // var response = await request.send();
    if (response.statusCode == 200) {
      print(response.body);
      var list = jsonDecode(response.body);
      print(list["personId"]);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddPhoto(
              text: list["personId"],
            ),
          ));
      print('ok');
    }
    // print(request);
    // final respStr = await response.stream.bytesToString();

    //{"personId":"ec3e5699-5249-475e-9793-398b39fe6b1f"}
  }

  RegData _data = new RegData();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Image.asset(
              "images/face.png",
              width: 90,
              height: 90,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                      gapPadding: 3.3,
                      borderRadius: BorderRadius.circular(3.3))),
              validator: (value) {
                if (value.isEmpty) {
                  return "Enter Name";
                } else {
                  _data.name = value;
                  print("Name = " + _data.name);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: "Info",
                  border: OutlineInputBorder(
                      gapPadding: 3.3,
                      borderRadius: BorderRadius.circular(3.3))),
              validator: (value) {
                if (value.isEmpty) {
                  return "Enter info";
                } else {
                  _data.info = value;
                  print("info = " + _data.info);
                }
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          _data.name = _data.name;
                        });
                        _makePostRequest();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("All is Good"),
                        ));
                      }
                    },
                    child: Text("Submit"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          _data.name = "";
                        });
                        _formKey.currentState.reset();
                      }
                    },
                    child: Text("Clear"),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

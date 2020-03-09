import 'package:flutter/material.dart';
import './ui/CustomRegForm.dart';



void main()=> runApp(Reg ());

class Reg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final appTitle = "Registration";
    return MaterialApp(

      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
          centerTitle: true,
        ),
        body: CustomRegForm(),
      ),
      
    );
  }
}


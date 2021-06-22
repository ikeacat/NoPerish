// UpdateWidget.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 21 June 2021

import 'package:flutter/material.dart';
import 'package:noperish/misc/BoldTextBar.dart';

class UpdateWidget extends StatefulWidget {
  UpdateWidget({Key? key}) : super(key: key);

  UWState createState() => UWState();
}

class UWState extends State<UpdateWidget> {
  var mainBlock = <Widget>[
    Row(
      children: [
        SizedBox(width: 15),
        CircularProgressIndicator(),
        SizedBox(width: 15),
        Text('Checking for updates...'),
      ],
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BoldTextBar(title: 'Update'),
          SizedBox(
            height: 10,
          ),
          Column(
            children: mainBlock,
          )
        ],
      ),
    );
  }
}

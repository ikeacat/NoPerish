// UpdateWidget.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 24 June 2021

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:noperish/misc/BoldTextBar.dart';
import 'package:http/http.dart';
import 'package:noperish/misc/VersionConstant.dart';

class UpdateWidget extends StatefulWidget {
  UpdateWidget({Key? key}) : super(key: key);

  UWState createState() => UWState();
}

class UWState extends State<UpdateWidget> {
  var lock = false;
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

  void doUpdateSequence() async {
    // Prevent build loop
    if (lock) {
      return;
    }
    lock = true;

    // Send GET to Github
    var githubReq = await get(
        Uri.parse("https://api.github.com/repos/ikeacat/NoPerish/releases"));
    var latest = jsonDecode(githubReq.body)[0]["tag_name"];

    List<Widget> newBlock;
    if (latest == "v" + versionNoPerish) {
      newBlock = [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You're on the latest version.",
                style: TextStyle(
                    color: Color.fromRGBO(24, 112, 12, 50),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text('Latest: $latest'),
              Text('Current: v$versionNoPerish'),
            ],
          ),
        )
      ];
    } else {
      newBlock = [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You're not on the latest version!",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                  'You can get the latest version at https://www.github.com/ikeacat/NoPerish/releases :)'),
              SizedBox(height: 5),
              RichText(
                  text: TextSpan(
                      text:
                          "It's recommend that you update to the latest version ",
                      style: TextStyle(color: Colors.blueGrey),
                      children: const <TextSpan>[
                    TextSpan(
                        text: 'before',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold)),
                    TextSpan(text: ' you install.'),
                  ])),
              SizedBox(
                height: 5,
              ),
              Text('Latest: $latest'),
              Text('Current: v$versionNoPerish')
            ],
          ),
        )
      ];
    }

    setState(() {
      mainBlock = newBlock;
    });
  }

  @override
  Widget build(BuildContext context) {
    doUpdateSequence();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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

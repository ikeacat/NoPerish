// DoneWidgetWin.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 30 April 2022

import 'package:flutter/material.dart';
import 'dart:io';

class DoneWidgetWin extends StatelessWidget {
  DoneWidgetWin({Key? key, required this.whathappened}) : super(key: key);

  final List<String> whathappened;

  List<Text> whatWeDid() {
    var newlist = <Text>[];
    for (String event in whathappened) {
      newlist.add(Text(
        event,
        style: TextStyle(color: Colors.blueGrey, fontStyle: FontStyle.italic),
      ));
    }
    return newlist;
  }

  @override
  Widget build(BuildContext context) {
    whatWeDid();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Done!',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(24, 112, 12, 50)),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
                'We never encountered any errors during installation, but maybe you will.'),
            SizedBox(
              height: 5,
            ),
            Text(
                'We recommend that when you startup this device next that you check the log at [your user directory]/AppData/Local/NoPerish/startup.log'),
            SizedBox(height: 15),
            Text(
              'What We Did',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: whatWeDid(),
            ),
            SizedBox(height: 15),
            ElevatedButton(
                onPressed: () {
                  exit(0);
                },
                child: Text(
                  'Exit',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}

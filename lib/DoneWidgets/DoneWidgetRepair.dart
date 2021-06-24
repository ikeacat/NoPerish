// DoneWidgetRepair.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 24 June 2021

import 'package:flutter/material.dart';
import 'dart:io';

class DoneRepair extends StatelessWidget {
  DoneRepair({required this.whatHappened});

  final List<String> whatHappened;

  List<Text> whatWeDid() {
    var newlist = <Text>[];
    for (String event in whatHappened) {
      newlist.add(Text(
        event,
        style: TextStyle(color: Colors.blueGrey, fontStyle: FontStyle.italic),
      ));
    }
    return newlist;
  }

  @override
  Widget build(BuildContext context) {
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
                'LISTEN UP! The program will probably still work if it did before, but it is still recommended that you test the program to make sure that saving the config file didnt break anything.'),
            SizedBox(height: 5),
            Text('Thx :)'),
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

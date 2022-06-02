// BranchToPlatformWidget.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 2 June 2022

import 'package:flutter/material.dart';

class BranchToPlatformWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please select your platform.",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 14),
            ElevatedButton(
                onPressed: () {},
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: 10, top: 10, left: 24, right: 24),
                  child: Text("Windows"),
                )),
            SizedBox(height: 7),
            ElevatedButton(
              onPressed: () {},
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: 10, top: 10, left: 24, right: 24),
                child: Text("Linux (Systemd)"),
              ),
            ),
            SizedBox(height: 7),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: 10, top: 10, left: 24, right: 24),
                child: Text("Go Back"),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
            )
          ],
        ),
      ),
    );
  }
}

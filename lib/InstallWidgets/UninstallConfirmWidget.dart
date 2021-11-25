// UninstallConfirmWidget.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 24 November 2021

import 'package:flutter/material.dart';
import 'package:noperish/InstallWidgets/UninstallWidget.dart';

class UninstallConfirmWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Are you sure you want to uninstall?",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 14),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UninstallWidget()));
              },
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: 10, top: 10, left: 24, right: 24),
                child: Text(
                  "Yes",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
            ),
            SizedBox(height: 7),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: 10, top: 10, left: 24, right: 24),
                child: Text("No"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

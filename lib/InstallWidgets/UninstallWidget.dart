// DoingInstallWidget.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 24 November 2021

import 'package:flutter/material.dart';

class UninstallWidget extends StatefulWidget {
  UninstallWidget({Key? key}) : super(key: key);

  UninstallWidgetState createState() => UninstallWidgetState();
}

class UninstallWidgetState extends State<UninstallWidget> {
  void uninstallChain(BuildContext context) {}

  String currentMessage = "Detecting platform";

  void updateMessage(String message) {
    setState(() {
      currentMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    uninstallChain(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text(
              currentMessage,
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic),
            )
          ],
        ),
      ),
    );
  }
}

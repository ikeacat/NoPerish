// UninstallWidget.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 24 November 2021

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:noperish/DoneWidgets/DoneWidgetRemoval.dart';

class UninstallWidget extends StatefulWidget {
  UninstallWidget({Key? key}) : super(key: key);

  UninstallWidgetState createState() => UninstallWidgetState();
}

class UninstallWidgetState extends State<UninstallWidget> {
  var lock = false;

  void errorAlertAndPop(String message, BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text(
        'Error',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'Ok',
              style: TextStyle(color: Colors.purple),
            ))
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  void uninstallChain(BuildContext context) async {
    // Make sure we dont start this process every time we call setState().
    if (lock) {
      return;
    }
    lock = true;

    if (Platform.isWindows) {
      updateMessage("Detected Windows -- Detecting installation...");
      var userDirectoryProcess =
          await Process.run('echo', ['%USERPROFILE%'], runInShell: true);
      var userDirectoryNT = userDirectoryProcess.stdout.toString().trim();
      var userDirectory = userDirectoryNT.replaceAll(r'\', '/');

      if (await Directory(userDirectory + "/NoPerish").exists()) {
        updateMessage("Removing $userDirectory/NoPerish");
        await Directory(userDirectory + "/NoPerish")
            .delete(recursive: true)
            .then((value) async {
          updateMessage("Removing startup file...");
          await Process.run(
              "del",
              [
                userDirectoryNT +
                    r"\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\NoPerish.lnk"
              ],
              runInShell: true);
          updateMessage("Done! -- Transitioning...");
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => DoneRemoval()));
        });
      } else {
        errorAlertAndPop(
            "No windows installation found :(\nWe didn't remove ANYTHING.",
            context);
        return;
      }
    } else if (Platform.isLinux) {}
  }

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

// UninstallWidget.dart
// This project, which includes this file, is licensed under GNU General
// Public License v3.0.
// Get a copy here: https://www.gnu.org/licenses/gpl-3.0-standalone.html
// Or just look at the LICENSE file.
// Last Updated 30 April 2022

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:noperish/DoneWidgets/DoneWidgetRemoval.dart';

class UninstallWidget extends StatefulWidget {
  UninstallWidget({Key? key}) : super(key: key);

  UninstallWidgetState createState() => UninstallWidgetState();
}

class UninstallWidgetState extends State<UninstallWidget> {
  var lock = false;
  List<String> keepTrack = ["Detecting platform"];

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
        // Keeping this in case someone tries to remove old Windows install.
        updateMessage("Found ancient installation.");
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
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DoneRemoval(whathappened: keepTrack)));
        });
      } else if (await Directory("C:/Program Files/NoPerish").exists()) {
        updateMessage("Found modern installation.");
        updateMessage("Removing Program Files folder. (The script)");
        await Directory("C:/Program Files/NoPerish").delete(recursive: true);
        updateMessage("Removing AppData folder. (The config)");
        await Directory(userDirectory + "/AppData/Local/NoPerish")
            .delete(recursive: true);
        updateMessage("Removing startup file.");
        await Process.run(
            "del",
            [
              userDirectoryNT +
                  r"\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\NoPerish.lnk"
            ],
            runInShell: true);
        updateMessage("Done! -- Transitioning...");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DoneRemoval(whathappened: keepTrack)));
      } else {
        errorAlertAndPop(
            "No windows installation found :(\nWe didn't remove ANYTHING.",
            context);
        return;
      }
    } else if (Platform.isLinux) {
      updateMessage("Detected Linux -- looking for systemd or crontab");
      if (await File("/etc/systemd/system/noperish.service").exists()) {
        updateMessage("Removing systemd service file");
        await File("/etc/systemd/system/noperish.service")
            .delete(recursive: true);
      } else {
        updateMessage(
            "Could not find service file. Still gonna try to remove /etc/noperish");
        // TODO: Update this when crontab is added.
      }
      if (await Directory("/etc/noperish/").exists()) {
        updateMessage("Removing /etc/noperish installation.");
        await Directory("/etc/noperish").delete(recursive: true);
      } else {
        errorAlertAndPop(
            "Could not detect an installation. We might have removed a service file if it exists somewhere else.",
            context);
        return;
      }
      if (await File("/usr/sbin/noperish").exists()) {
        updateMessage("Removing /usr/sbin/noperish executable.");
        await File("/usr/sbin/noperish").delete();
      } else {
        updateMessage(
            "No /usr/sbin/noperish found. Probably old installation & removed with etc");
      }
      if (await File("/var/log/noperish.log").exists()) {
        updateMessage("Removing log.");
        await File("/var/log/noperish.log").delete();
      } else {
        updateMessage(
            "No log found. Probably old installation & removed with etc");
      }
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DoneRemoval(
                whathappened: keepTrack,
              )));
    }
  }

  String currentMessage = "Detecting platform";

  void updateMessage(String message) {
    keepTrack.add(message);
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
